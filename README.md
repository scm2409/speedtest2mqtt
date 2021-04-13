# speedtest2mqtt

**DESCRIPTION OUTDATED**

Pushing speedtest-cli results as json to MQTT for use in homeassistant

homeassistant config:
```
sensor speedtest_ping:
  platform: mqtt
  state_topic: 'speedtest/k77'
  name: 'Speedtest K77 Ping'
  unit_of_measurement: "ms"
  value_template: "{{ value_json.Ping_ms }}"

sensor speedtest_download:
  platform: mqtt
  state_topic: 'speedtest/k77'
  name: 'Speedtest K77 Download'
  unit_of_measurement: "Mbit"
  value_template: "{{ value_json.Download_Mbit }}"

sensor speedtest_upload:
  platform: mqtt
  state_topic: 'speedtest/k77'
  name: 'Speedtest K77 Upload'
  unit_of_measurement: "Mbit"
  value_template: "{{ value_json.Upload_Mbit }}"
```

Environment variables:

* MQTT_HOST: MQTT server to connect (default: localhost)
* MQTT_ID: Client ID (default: k77)
* MQTT_TOPIC: MQTT topic (default: speedtest/k77)
* SPEEDTEST_OPTIONS: speedtest-cli options (default: --bytes)
 

Usage:

```
docker run --rm eminguez/speedtest2mqtt
```

To override values, use `-e` docker flag.
