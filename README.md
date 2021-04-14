# speedtest2mqtt


New format:
```
{
  "download": 25099307.901190314,
  "upload": 19723012.16479094,
  "ping": 66.892,
  "server": {
    "url": "http://speed.alphacron.de:8080/speedtest/upload.php",
    "lat": "50.8892",
    "lon": "10.8789",
    "name": "Apfelstädt",
    "country": "Germany",
    "cc": "DE",
    "sponsor": "AlphaCron",
    "id": "36896",
    "host": "speed.alphacron.de:8080",
    "d": 107.11307240346001,
    "latency": 66.892
  },
  "timestamp": "2021-04-13T12:57:06.965883Z",
  "bytes_sent": 24879104,
  "bytes_received": 31624193,
  "share": null,
  "client": {
    "ip": "178.162.221.166",
    "lat": "51.2993",
    "lon": "9.491",
    "isp": "Leaseweb Deutschland GmbH",
    "isprating": "3.7",
    "rating": "0",
    "ispdlavg": "0",
    "ispulavg": "0",
    "loggedin": "0",
    "country": "DE"
  }
}
```

Pushing speedtest-cli results as json to MQTT for use in homeassistant

homeassistant config:
```
sensor speedtest_ping:
  platform: mqtt
  state_topic: 'speedtest/k77'
  name: 'Speedtest K77 Ping'
  unit_of_measurement: "ms"
  value_template: "{{ value_json.ping }}"

sensor speedtest_download:
  platform: mqtt
  state_topic: 'speedtest/k77'
  name: 'Speedtest K77 Download'
  unit_of_measurement: "Mbit/s"
  value_template: "{{ (value_json.download) | int / 1024 / 1024 | round(1) }}"

sensor speedtest_upload:
  platform: mqtt
  state_topic: 'speedtest/k77'
  name: 'Speedtest K77 Upload'
  unit_of_measurement: "Mbit/s"
  value_template: "{{ (value_json.upload) | int / 1024 / 1024 | round(1) }}"
```

Environment variables:

* MQTT_HOST: MQTT server to connect (default: localhost)
* MQTT_USER: MQTT server user
* MQTT_PASS: MQTT server password
* MQTT_ID: Client ID (default: k77)
* MQTT_TOPIC: MQTT topic (default: speedtest/k77)
* SPEEDTEST_OPTIONS: speedtest-cli options (default: --bytes)
 

Usage:

```
docker run --rm -ti \
  -e MQTT_HOST=home-assistant.lan \
  -e MQTT_ID=server1 \
  -e MQTT_TOPIC=speedtest/home-assistant.lan \
  -e MQTT_USER=user \
  -e MQTT_PASS=pass \
  -e SPEEDTEST_OPTIONS="--server 36896" \
  scm2409/speedtest2mqtt:7ab419d

```

To override values, use `-e` docker flag.
