docker build -t build-img -f .\Dockerfile.build .
docker run --name build-cont build-img
mkdir -p ./target
docker cp build-cont:quorum/build/bin/bootnode ./target/bootnode
docker cp build-cont:quorum/build/bin/geth ./target/geth
docker cp build-cont:ubuntu1604/constellation-enclave-keygen ./target/constellation-enclave-keygen
docker cp build-cont:ubuntu1604/constellation-node ./target/constellation-node
docker build --no-cache -t service-img -f .\Dockerfile .
docker run --name service-cont --rm -it -p 8545:8545 -p 30303:30303 service-img