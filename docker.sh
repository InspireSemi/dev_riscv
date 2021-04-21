#!/bin/bash

GROUP=$(id -g $USER)
USER=$(id -u $USER)

sudo docker run -it --user ${USER}:${GROUP} -v $(pwd):/source mkarasek/inspire_dev:$1
