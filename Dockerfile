FROM ubuntu:xenial

COPY ./node-config/* /node-config/
COPY ./target/* /usr/local/bin/

RUN chmod +x /usr/local/bin/* && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24 && \
    su -c "echo 'deb http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main' > /etc/apt/sources.list.d/git.list" && \
    apt-get update && \
    apt-get install -y --no-install-recommends libdb-dev libsodium-dev zlib1g-dev libtinfo-dev curl unzip ca-certificates && \
    curl -L -o master.zip https://github.com/jjcollinge/quorum-setup/zipball/jjcollinge/singleton/ && \
    unzip master.zip -d node && \
    cd node/* && mv * /node/ && cd / && \
    rm master.zip && \
    apt-get remove -y curl unzip && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /node/init.sh /node/start.sh /node/stop.sh /node/run.sh

WORKDIR /node
ENTRYPOINT ["/bin/bash"]