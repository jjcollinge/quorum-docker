#!/bin/bash

UNIQUE_ID=$(date +%s)
LOG="run-${UNIQUE_ID}.log"

if [ ! -v "PATH_TO_NODE" ];
then
        echo "PATH_TO_NODE not set, please provide a valid node config">>${LOG}
        exit 1;
elif [ ! -d "${PATH_TO_NODE}" ];
then
        echo "PATH_TO_NODE set, but ${PATH_TO_NODE} directory doesn't exist">>${LOG}
        exit 1;
else
        echo "Copying node-config from ${PATH_TO_NODE} to local directory">>${LOG}
        rm -rf node-config
        mkdir -p node-config
        cp -rp $PATH_TO_NODE/* node-config
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
ARGS="--name $SERVICE_CONTAINER_ID --rm -it -e BOOTNODE_ADDRESS=${BOOTNODE_ADDRESS} --net=host ${SERVICE_IMAGE_ID}"
echo "Creating container ${SERVICE_CONTAINER_ID}">>${LOG}
echo "Args: ${ARGS}">>${LOG}
docker run $ARGS