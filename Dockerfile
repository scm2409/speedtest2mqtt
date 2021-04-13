ARG TIMEZONE="Europe/Vienna"

ARG _BASE_IMAGE_NAME="alpine"
ARG _BASE_IMAGE_VERSION="3.13.4"

ARG _BASE_IMAGE="${_BASE_IMAGE_NAME}:${_BASE_IMAGE_VERSION}"

########################################################################################################################
# TIMEZONE
########################################################################################################################
FROM ${_BASE_IMAGE} as timezone

RUN apk add --no-cache tzdata

########################################################################################################################
# MAIN
########################################################################################################################
FROM ${_BASE_IMAGE}

#=======================================================================================================================
# variables
#-----------------------------------------------------------------------------------------------------------------------
ENV ST_SCRIPTS_DIR=/opt/scripts
ENV PATH="${ST_SCRIPTS_DIR}:${PATH}"

#=======================================================================================================================
# set timezone (see https://wiki.alpinelinux.org/wiki/Setting_the_timezone)
#-----------------------------------------------------------------------------------------------------------------------
ARG TIMEZONE
COPY --from=timezone /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
RUN echo "${TIMEZONE}" >  /etc/timezone

#=======================================================================================================================
# install packages
#-----------------------------------------------------------------------------------------------------------------------
RUN apk upgrade --update && \
    apk add --no-cache \
      bash \
      tini \
      mosquitto-clients \
      git \
      py3-pip && \
    rm -f /var/cache/apk/*

#=======================================================================================================================
# install speedtest-cli
#-----------------------------------------------------------------------------------------------------------------------
# see https://github.com/sivel/speedtest-cli
ARG ST_SPEEDTEST_CLI_GIT_TAG="v2.1.3"

RUN pip install git+https://github.com/sivel/speedtest-cli.git@${ST_SPEEDTEST_CLI_GIT_TAG}

#=======================================================================================================================
# copy scripts
#-----------------------------------------------------------------------------------------------------------------------
COPY ./speedtest2mqtt.sh /${ST_SCRIPTS_DIR}/
COPY ./entrypoint.sh /${ST_SCRIPTS_DIR}/
RUN find /${ST_SCRIPTS_DIR}/ -name "*.sh" -exec chmod +x {} \;

#=======================================================================================================================
# user
#-----------------------------------------------------------------------------------------------------------------------
RUN addgroup -S docker && \
    adduser -D -s /bin/bash -G docker docker

USER docker:docker

#=======================================================================================================================
# entrypoint
#-----------------------------------------------------------------------------------------------------------------------
ENTRYPOINT ["entrypoint.sh"]
CMD ["speedtest2mqtt.sh"]

#-----------------------------------------------------------------------------------------------------------------------
# END
#=======================================================================================================================
