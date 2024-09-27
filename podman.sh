#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Must Specify the docker image to run "
    echo "Usage: docker.sh <imagename:version>"
    echo "imagename can be a local docker image or one from docker hub"
    exit 1
fi

GROUP=$(id -g $USER)
USER=$(id -u $USER)

sudo podman run -it --user ${USER}:${GROUP} -v $(pwd):/source $1
