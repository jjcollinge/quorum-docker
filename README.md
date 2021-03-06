# Quorum + Docker

## Dockerfile.build
Pulls the Quorum and Constellation repositories, installs all build dependencies and then builds both packages into 4 binaries.
* bootnode
* geth
* constellation-enclave-keygen
* constellation-node

## Dockerfile
Mounts the above binaries, installs any runtime dependencies and then executes a network initialisation script.

## build-and-run script
This script orchestrates the invocation of both the above docker files and extracts the build artifacts from the Dockerfile.build container and makes them available to Dockerfile for mounting.

## Justification
The reason for spliting out the build and the runtime containers is to reduce the footprint of the running quorum and constellation containers. The current quorum/constellation docker files I have been able to find all have a 1GB > footprint, even those that remove packages and obsolete files. By splitting the containers, the runtime Docker image is around 310MB. This could be further reduced by changing the base OS image. This does come as a trade off for portablility, the docker container is now not self contained and idempotent.

## Usage
On an Ubuntu machine with Docker installed, perform the following operations:
1. git clone https://github.com/jjcollinge/quorum-docker.git && cd quorum-docker
2. chmod +x build-and-run.sh
3. export BOOTNODE_ADDRESS="IP of bootnode"
4. ./build-and-run.sh
5. cd node/*
6. chmod +x init.sh start.sh stop.sh
7. ./init.sh
8. ./start.sh

## Configuration
The deployment package quorum-docker has a folder called `node-config`. By changing the keys to one of the other accounts defined in the gensis.json you can setup additional member nodes. This will be revised and made easier in the near future.