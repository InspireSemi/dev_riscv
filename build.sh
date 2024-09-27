#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Must Specify the docker image name and docker file "
    echo "Usage: build.sh <name:version> <dockerfile>"
    exit 1
fi

sudo podman build --rm -t $1 . -f $2

