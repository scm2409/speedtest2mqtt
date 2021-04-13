#!/usr/bin/env bash

set -o errexit; set -o pipefail; set -o nounset

readonly MQTT_HOST=${MQTT_HOST:-localhost}
readonly MQTT_ID=${MQTT_ID:-k77}
readonly MQTT_TOPIC=${MQTT_TOPIC:-speedtest/k77}
readonly MQTT_OPTIONS=${MQTT_OPTIONS:-"-V mqttv311"}
readonly MQTT_USER=${MQTT_USER}
readonly MQTT_PASS=${MQTT_PASS}
readonly SPEEDTEST_OPTIONS=${SPEEDTEST_OPTIONS:-}

/usr/bin/speedtest-cli --json ${SPEEDTEST_OPTIONS} | \
  /usr/bin/mosquitto_pub -h ${MQTT_HOST} -i ${MQTT_ID} -l -t ${MQTT_TOPIC} ${MQTT_OPTIONS} -u ${MQTT_USER} -P ${MQTT_PASS}