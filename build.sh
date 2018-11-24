#!/bin/bash

if [ "$1" = "" ]; then
    echo usage: build.sh TAG
    exit 1
fi

export DOCKER_TAG=$1
export IMAGE_NAME=runoshun/docker-pyspark-notebook:${DOCKER_TAG}
export DOCKERFILE_PATH=""
./hooks/build
