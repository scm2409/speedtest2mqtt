#!/usr/bin/env bash

set -o errexit; set -o pipefail; set -o nounset

# (see https://github.com/krallin/tini#remapping-exit-codes)
exec /sbin/tini -e 143 -- "$@"
