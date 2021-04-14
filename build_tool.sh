#!/usr/bin/env bash

set -o errexit; set -o pipefail; set -o nounset

readonly BT_DOCKER_PASSWORD
readonly BT_DOCKER_USERNAME

declare _BT_VCS_REF; _BT_VCS_REF=$(git rev-parse --short HEAD)
readonly _BT_IMAGE_VERSION="${_BT_VCS_REF}"
readonly _BT_DOCKER_REPOSITORY="scm2409/speedtest2mqtt"
readonly _BT_DOCKER_TAG="${_BT_DOCKER_REPOSITORY}:${_BT_IMAGE_VERSION}"
readonly _BT_DOCKER_REGISTRY_TAG="${_BT_DOCKER_REPOSITORY}:${_BT_IMAGE_VERSION}"

_docker_login() {
    echo "${BT_DOCKER_PASSWORD:?}" | docker login -u "${BT_DOCKER_USERNAME:?}" --password-stdin
}

case "${1:-}" in
    build)
        _docker_login

        # build slim image for production
        docker build --pull --tag "${_BT_DOCKER_TAG}" \
            --label "org.label-schema.build-date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
            --label "org.label-schema.version=${_BT_IMAGE_VERSION}" \
            --label "org.label-schema.vcs-ref=${_BT_VCS_REF}" \
            .
        ;;
    run)
        _docker_login

        # build  image
        docker build --pull --tag ${_BT_DOCKER_TAG} .

        shift # remove first argument

        # run image
        docker run --rm --tty --interactive ${_BT_DOCKER_TAG} "$@"
        ;;
    publish)
        _docker_login
        # tag image for push
        docker tag ${_BT_DOCKER_TAG} ${_BT_DOCKER_REGISTRY_TAG}
        # push image
        docker push ${_BT_DOCKER_REGISTRY_TAG}
        ;;
    *)
        echo "Usage: ${0} {build|run|publish}"
        exit 1
esac
