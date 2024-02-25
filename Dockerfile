FROM node:14

RUN npm install -g knx-mqtt-bridge
ENV KNX_MQTT_CONFIG=/config/config.yaml
CMD knx-mqtt-bridge
