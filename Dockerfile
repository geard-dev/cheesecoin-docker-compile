FROM ubuntu:latest
MAINTAINER Crypto B612 "crypto.b612@gmail.com"

# Install dependencies for compiling Litecoin
RUN sed -i -e "s/\/\/archive\.ubuntu/\/\/us.archive.ubuntu/" /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev libminiupnpc-dev libzmq3-dev libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler libqrencode-dev libdb5.3++-dev git-core lcov

# Add a user named 'litecoin'
RUN useradd -ms /bin/bash litecoin
USER litecoin

# Change to the home directory
WORKDIR /home/litecoin

# Clone litecoin code
RUN git clone https://github.com/litecoin-project/litecoin litecoin-src
WORKDIR litecoin-src

# Checkout the v0.14.2 release
RUN git checkout v0.14.2

# Compile
RUN ./autogen.sh
RUN ./configure --enable-lcov --with-incompatible-bdb
RUN make -j 32

# Install
USER root
RUN make install

# Run
USER litecoin
CMD /usr/local/bin/litecoind -txindex=1 -reindex -printtoconsole -debug=1
