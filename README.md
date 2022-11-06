# InfluxDB docker

Docker configuration for InfluxDB on a Raspberry Pi 4.

The Influx Extension is installed in Visual Source Code to manage the databases.

The container is managed with by a script. 

```
docker run -d -p 8086:8086 --name influxdb2 -v $PWD:/var/lib/influxdb2 influxdb:2.5.0
```

## Setup

A primary bucket is created during the setup. In case metrics are enabled the bucket is cluttered with InfluxDB internal measurments. 

> metrics-disabled: true
