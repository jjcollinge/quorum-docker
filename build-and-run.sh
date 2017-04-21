#!/bin/bash

UNIQUE_ID=$(date +%s)
LOG="run-${UNIQUE_ID}.log"

if [ ! -v "NODE_CONFIG_PATH" ];
then
        echo "NODE_CONFIG_PATH not set, please provide a valid node config">>${LOG}
        exit 1;
elif [ ! -d "${NODE_CONFIG_PATH}" ];
then
        echo "NODE_CONFIG_PATH set, but ${NODE_CONFIG_PATH} directory doesn't exist">>${LOG}
        exit 1;
else
        echo "Copying node-config from ${NODE_CONFIG_PATH} to local directory">>${LOG}
        rm -rf node-config
        mkdir -p node-config
        cp -rp $NODE_CONFIG_PATH/* node-config
fi

if [ ! -f "./target/bootnode" ] &&
   [ ! -f "./target/geth" ] &&
   [ ! -f "./target/constellation-enclave-keygen" ] &&
   [ ! -f "./target/constellation-node" ];
then
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
        echo "Binaries already in target/ folder, to force a rebuild, stop this command and re-run after deleting the existing target/ folder">>${LOG}
fi

SERVICE_IMAGE_ID="service${UNIQUE_ID}"
SERVICE_CONTAINER_ID="${SERVICE_IMAGE_ID}-container"
echo "Build image ${SERVICE_IMAGE_ID}">>${LOG}
docker build --no-cache -t $SERVICE_IMAGE_ID -f Dockerfile .
. env.sh
ARGS="--name $SERVICE_CONTAINER_ID --rm -d -e BOOTNODE_IP=${BOOTNODE_IP} -e BOOTNODE_PORT=${BOOTNODE_PORT} -e RPC_PORT=${RPC_PORT} -e CONSTELLATION_PORT=${CONSTELLATION_PORT} -e GETH_PORT=${GETH_PORT} --net=host ${SERVICE_IMAGE_ID}"
echo "Creating container ${SERVICE_CONTAINER_ID}">>${LOG}
echo "Args: ${ARGS}">>${LOG}
docker run $ARGS