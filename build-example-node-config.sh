#!/bin/bash
while getopts n:a: option
do
        case "${option}"
        in
                n) INDEX=${OPTARG};;
                a) EXISTING_NODE=${OPTARG};;
        esac
done

if [ -z "$INDEX" ];
then
    echo "No index given, defaulting to 1"
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
EXAMPLE_PORT_EXT=$((INDEX - 1))
sed -i -e "s/127.0.0.1:900${EXAMPLE_PORT_EXT}/0.0.0.0:9000/g" node.conf

# Add existing node if one has been provided
if [ -n "$EXISTING_NODE" ];
then
    sed -i -e "s/127.0.0.1:9000/${EXISTING_NODE}:9000/g" node.conf
fi
