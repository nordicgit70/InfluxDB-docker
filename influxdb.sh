#!/bin/bash
export DISPLAY=:0

# Execution parameters
exec="InfluxDB"
stop_sig="9"
pidfile="/var/run/influxdb.pid"
cidfile="influxdb.cid"
image="nordic/influxdb:latest"

# Container start function
container_start(){
    if [ -s $cidfile ];
    then
        cid=`cat "$cidfile"`
        printf "\\n%s container is already running with id %s.\\n\\n" $exec $cid
        exit 0
    fi;

    printf "\\nStarting %s container...\\n" $exec

    # Disable colors
    export NO_COLOR=1

    # Start the container with host networking (automatic removed when stopped)
    # removed: --restart unless-stopped
    docker run -d --name $exec --init --restart always \
      --network host --cidfile $cidfile \
      -v $(pwd)/config.yml:/etc/influxdb2/config.yml \
      -v /var/lib/influxdb:/var/lib/influxdb2 \
      -itd $image
    echo
}

# Container stop function
container_stop(){
  printf "\\nStopping %s container...\\n" $exec
  docker stop $exec
  if [ -s $cidfile ]
  then  rm "$cidfile"
  fi;
  echo
}

# Build function
container_build(){
  if [ "$(id -u)" = "0" ]; then
    echo "It appears we are in the container and option build is not valid."
    exit
  fi

  if [ -s $cidfile ];
  then
      printf "\\n%s container is still running.\\n\\n" $exec
  else
      printf "\\nBuilding %s docker container...\\n" $exec
      docker build -t $image -f DockerFile .
  fi;
}

# Command control
case "$1" in
build)    container_build
          ;;
start)    container_start
          ;;
stop)     container_stop
          ;;
*)        echo
          echo " InfluxDB script"
          echo " Synopsis"
          echo "      influxdb.sh build | start | stop | --help"
          echo
          echo " Description"
          echo "      InfluxDB container control."
          echo
          echo " Options"
          echo "      build  to build the image"
          echo "      start  to start the container"
          echo "      stop   to stop the container"
          echo "      --help   displays this text"
          echo
          echo " Usage : influxdb.sh build | start | stop | --help"
          echo
          exit 2
            ;;
esac
exit 0
