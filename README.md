# knx-mqtt-bridge

![npm](https://img.shields.io/npm/v/knx-mqtt-bridge.svg) ![license](https://img.shields.io/npm/l/knx-mqtt-bridge.svg) ![github-issues](https://img.shields.io/github/issues/pakerfeldt/knx-mqtt-bridge.svg)

A KNX / MQTT bridge

![nodei.co](https://nodei.co/npm/knx-mqtt-bridge.png?downloads=true&downloadRank=true&stars=true)

![](https://david-dm.org/pakerfeldt/knx-mqtt-bridge/status.svg)
![](https://david-dm.org/pakerfeldt/knx-mqtt-bridge/dev-status.svg)

## Features
Bridges KNX and MQTT using the [knx.js library](https://bitbucket.org/ekarak/knx.js/src/master/).
A Dockerfile is also provided for creating a working docker container.

KNX events are written to the MQTT topic `knx/x/y/z` where `x/y/z` is the group
address. Writing to KNX is done by sending an MQTT message to topic
`knx/x/y/z/write` with the value to write as the message. Again `x/y/z` is the
group address to write to. The bridge also supports reading of values by sending
an MQTT message to `knx/x/y/z/read`.

It's highly recommended to provide an ETS export of all the group addresses and
their corresponding datapoint types. By doing this, values will be automatically
converted from and to its raw type. If you are reading or writing to an unknown
group address the raw byte buffer is what's being communicated and you would
need to convert back and forth yourself.

Providing an ETS export is done by exporting an XML of all group addresses and
its datapoint types from the ETS software. This file is then referenced from
the configuration file.

## Install

Docker Anleitung findet Ihr unter: https://www.elektrifiziert.net/blog/index.php?entry/177-knx-to-mqtt/
Ab hier wieder Originaltext - ich supporte nur Dockerinstallation - von daher habe ich den entsprechende 
baremetall Abschnitt entfernt.

## Configuring
See config.example.yaml for a configuration example. By default, the bridge will
try to connect to a KNX router using the multicast address. If you prefer
unicast you can add `ipAddr` and `ipPort` to the options block under knx in the
configuration file.

## Usage
Writing values to a mapped group address is straight forward. Send a message to
`knx/x/y/z/write` with the value to write. However, if the group address is not
mapped to a datapoint you can still write to that group address but you would
have to provide the raw buffer yourself. Again, you can still write to
`knx/x/y/z/write`, however knx-mqtt-bridge need to know the datapoint type of
the address you are writing to for proper conversion. This is especially true
for dpt1, dpt2 and dpt3. In this case you pass that information to the topic,
like so: `knx/x/y/z/write/dpt1`. For instance, if you would want to send a
1/true to light switch using `mosquitto_pub` it could look something like this:
`mosquitto_pub -h localhost -t 'knx/1/1/65/write/dpt1' -m "{\"type\":\"Buffer\",\"data\":[1]}"`.
For any datapoint other than dpt1, dpt2 or dpt3 you don't need to pass that
additional information.

## License

 - **Apache-2.0** : http://opensource.org/licenses/Apache-2.0
