FROM fedora:latest

ADD speedtest2mqtt.sh /opt/speedtest2mqtt.sh

RUN dnf install -y speedtest-cli mosquitto perl && \
    chmod 777 /opt/speedtest2mqtt.sh && \
    dnf clean all && \
    groupadd -r foo && \
    useradd --no-log-init -r -g foo foo

USER foo

CMD ["/opt/speedtest2mqtt.sh"]
