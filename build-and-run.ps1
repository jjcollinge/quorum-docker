docker build -t build-img -f .\Dockerfile.build .
docker run --name build-cont build-img
mkdir -p ./target
docker cp build-cont:quorum/build/bin/bootnode ./target/bootnode
docker cp build-cont:quorum/build/bin/geth ./target/geth
docker cp build-cont:ubuntu1604/constellation-enclave-keygen ./target/constellation-enclave-keygen
docker cp build-cont:ubuntu1604/constellation-node ./target/constellation-node
docker rm build-cont
docker build --no-cache -t service-img -f .\Dockerfile .
docker run --name service-cont --rm -it -e BOOTNODE_ADDRESS="127.0.0.1" -e START_BOOTNODE=true service-img