#!/bin/bash

UNIQUE_ID=$(date +%s)
LOG="run-${UNIQUE_ID}.log"

if [ ! -d "target" ]; then
        BUILD_IMAGE_ID="build${UNIQUE_ID}"
        BUILD_INSTANCE_ID="${BUILD_IMAGE_ID}-container"
        echo "Building image ${BUILD_IMAGE_ID}">>${LOG}
        docker build -t $BUILD_IMAGE_ID -f Dockerfile.build .
        echo "Creating container ${BUILD_INSTANCE_ID}">>${LOG}
        docker run --name $BUILD_INSTANCE_ID $BUILD_IMAGE_ID
        mkdir -p ./target
        docker cp $BUILD_INSTANCE_ID:quorum/build/bin/bootnode ./target/bootnode
        docker cp $BUILD_INSTANCE_ID:quorum/build/bin/geth ./target/geth
        docker cp $BUILD_INSTANCE_ID:ubuntu1604/constellation-enclave-keygen ./target/constellation-enclave-keygen
        docker cp $BUILD_INSTANCE_ID:ubuntu1604/constellation-node ./target/constellation-node
        docker rm $BUILD_INSTANCE_ID
else
        echo "Artefacts in target folder already exist, skipping build">>${LOG}
fi

SERVICE_IMAGE_ID="service${UNIQUE_ID}"
SERVICE_CONTAINER_ID="${SERVICE_IMAGE_ID}-container"
echo "Build image ${SERVICE_IMAGE_ID}">>${LOG}
docker build --no-cache -t $SERVICE_IMAGE_ID -f Dockerfile .
ARGS="--rm -it -e BOOTNODE_ADDRESS=${BOOTNODE_ADDRESS} -p 33445:33445 -p 8545:8545 -p 30303:30303 ${SERVICE_IMAGE_ID}"
echo "Creating container ${SERVICE_CONTAINER_ID}">>${LOG}
echo "Args: ${ARGS}">>${LOG}
docker run --name $SERVICE_CONTAINER_ID $ARGS