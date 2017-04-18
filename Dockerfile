FROM ubuntu:xenial

COPY ./target/geth /usr/local/bin/geth
COPY ./target/bootnode /usr/local/bin/bootnode
COPY ./target/constellation-node /usr/local/bin/constellation-node
COPY ./target/constellation-enclave-keygen /usr/local/bin/constellation-enclave-keygen

RUN chmod +x /usr/local/bin/geth /usr/local/bin/bootnode /usr/local/bin/constellation-enclave-keygen /usr/local/bin/constellation-node

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24
RUN su -c "echo 'deb http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main' > /etc/apt/sources.list.d/git.list"
RUN apt-get update
RUN apt-get install -y libdb-dev libsodium-dev zlib1g-dev libtinfo-dev curl unzip
RUN curl -L -o master.zip http://github.com/jjcollinge/quorum-examples/zipball/jjcollinge/singleton/ && unzip master.zip -d examples

RUN apt-get autoremove

ENTRYPOINT ["/bin/bash"]