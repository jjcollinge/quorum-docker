# Quorum + Docker

## Dockerfile.build
Pulls the Quorum and Constellation repositories, installs all build dependencies and then builds both packages into 4 binaries.
* bootnode
* geth
* constellation-enclave-keygen
* constellation-node

## Dockerfile
Mounts the above binaries, installs any runtime dependencies and then executes a network initialisation script.

## build-and-run script
This script orchestrates the invocation of both the above docker files and extracts the build artifacts from the Dockerfile.build container and makes them available to Dockerfile for mounting.

## Justification
The reason for spliting out the build and the runtime containers is to reduce the footprint of the running quorum and constellation containers. The current quorum/constellation docker files I have been able to find all have a 1GB > footprint, even those that remove packages and obsolete files. By splitting the containers, the runtime Docker image is around 310MB. This could be further reduced by changing the base OS image.