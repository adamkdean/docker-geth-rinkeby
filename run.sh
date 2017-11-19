#!/bin/bash

cd "${0%/*}"

# ensure host has docker installed
if ! [ -x "$(command -v docker)" ]; then
  echo "error: docker not found, please see https://get.docker.com/"
  exit 1
fi

# build image
docker build --tag geth-rinkeby .

# remove existing container if necessary
GETH_RINKEBY_EXISTS=$(docker ps -a --format "{{.Names}}" | grep ^geth-rinkeby$)
if [[ ! -z $GETH_RINKEBY_EXISTS ]]; then
  docker stop geth-rinkeby
  docker rm geth-rinkeby
fi

# run local geth container
docker run \
  --detach \
  --restart always \
  --publish 8545:8545 \
  --name geth-rinkeby \
  geth-rinkeby