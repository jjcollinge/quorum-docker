#!/bin/bash

mkdir -p node-config
cd node-config

# Get example genesis file
curl -O https://raw.githubusercontent.com/jpmorganchase/quorum-examples/master/examples/7nodes/genesis.json

mkdir -p keys

# Get example key files
curl https://github.com/jpmorganchase/quorum-examples/blob/master/examples/7nodes/keys/tm1.key -O
mv tm1.key keys/node.key

curl https://github.com/jpmorganchase/quorum-examples/blob/master/examples/7nodes/keys/tm1.pub -O
mv tm1.pub keys/node.pub

curl https://github.com/jpmorganchase/quorum-examples/blob/master/examples/7nodes/keys/tm1a.key -O
mv tm1a.key keys/nodea.key

curl https://github.com/jpmorganchase/quorum-examples/blob/master/examples/7nodes/keys/tm1a.pub -O
mv tm1a.pub keys/nodea.pub

# Get example conf
curl https://raw.githubusercontent.com/jpmorganchase/quorum-examples/master/examples/7nodes/tm1.conf -O
mv tm1.conf node.conf