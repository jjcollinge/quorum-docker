#!/bin/bash
while getopts n: option
do
        case "${option}"
        in
                n) INDEX=${OPTARG};;
        esac
done

if [ -z "$INDEX" ];
then
    INDEX=1
fi

mkdir -p example-config
cd example-config

# Get example genesis file
curl -O https://raw.githubusercontent.com/jpmorganchase/quorum-examples/master/examples/7nodes/genesis.json

# Get example key files
curl "https://raw.githubusercontent.com/jpmorganchase/quorum-examples/master/examples/7nodes/keys/tm${INDEX}.key" -O
mv "tm${INDEX}.key" node.key

curl "https://raw.githubusercontent.com/jpmorganchase/quorum-examples/master/examples/7nodes/keys/tm${INDEX}.pub" -O
mv "tm${INDEX}.pub" node.pub

curl "https://raw.githubusercontent.com/jpmorganchase/quorum-examples/master/examples/7nodes/keys/tm${INDEX}a.key" -O
mv "tm${INDEX}a.key" nodea.key

curl "https://raw.githubusercontent.com/jpmorganchase/quorum-examples/master/examples/7nodes/keys/tm${INDEX}a.pub" -O
mv "tm${INDEX}a.pub" nodea.pub

curl "https://raw.githubusercontent.com/jpmorganchase/quorum-examples/master/examples/7nodes/keys/key${INDEX}" -O

# Get example conf
curl "https://raw.githubusercontent.com/jpmorganchase/quorum-examples/master/examples/7nodes/tm${INDEX}.conf" -O
mv "tm${INDEX}.conf" node.conf
sed -i -e "s/tm${INDEX}/node/g" node.conf