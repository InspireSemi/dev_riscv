#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Must Specify the docker/podman image name and container file "
    echo "Usage: build.sh <name:version> <containerfile>"
    exit 1
fi

sudo podman build --rm -t $1 -f $2 .

