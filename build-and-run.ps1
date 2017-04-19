$BOOTNODE_ADDRESS=[System.Environment]::GetEnvironmentVariable('BOOTNODE_ADDRESS')

docker build -t build-img -f .\Dockerfile.build .
docker run --name build-cont build-img
mkdir -p ./target
docker cp build-cont:quorum/build/bin/bootnode ./target/bootnode
docker cp build-cont:quorum/build/bin/geth ./target/geth
docker cp build-cont:ubuntu1604/constellation-enclave-keygen ./target/constellation-enclave-keygen
docker cp build-cont:ubuntu1604/constellation-node ./target/constellation-node
docker rm build-cont
docker build --no-cache -t service-img -f .\Dockerfile .
docker run --name service-cont --rm -it -e BOOTNODE_ADDRESS="$BOOTNODE_ADDRESS" -p 33445:33445 -p 8545:8545 -p 30303:30303 service-img