#!/bin/bash

mkdir -p example-config
cd example-config

# Get example genesis file
curl -O https://raw.githubusercontent.com/jpmorganchase/quorum-examples/master/examples/7nodes/genesis.json

mkdir -p keys

# Get example key files
curl https://raw.githubusercontent.com/jpmorganchase/quorum-examples/master/examples/7nodes/keys/tm1.key -O
mv tm1.key node.key

curl https://raw.githubusercontent.com/jpmorganchase/quorum-examples/master/examples/7nodes/keys/tm1.pub -O
mv tm1.pub node.pub

curl https://raw.githubusercontent.com/jpmorganchase/quorum-examples/master/examples/7nodes/keys/tm1a.key -O
mv tm1a.key nodea.key

curl https://raw.githubusercontent.com/jpmorganchase/quorum-examples/master/examples/7nodes/keys/tm1a.pub -O
mv tm1a.pub nodea.pub

curl https://raw.githubusercontent.com/jpmorganchase/quorum-examples/master/examples/7nodes/keys/key1 -O

# Get example conf
curl https://raw.githubusercontent.com/jpmorganchase/quorum-examples/master/examples/7nodes/tm1.conf -O
mv tm1.conf node.conf
sed -i -e s/tm1/node/g node.conf