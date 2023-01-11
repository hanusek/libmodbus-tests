FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update --fix-missing -y
RUN apt install -y build-essential gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf libc6-dev-armhf-cross
RUN apt install -y gcc-multilib-arm-linux-gnueabihf g++-multilib-arm-linux-gnueabihf
RUN apt install -y automake autoconf clang-3.9 libclang-dev libtool
RUN apt install -y sshpass sed curl unzip tar wget git-core git iputils-ping pkg-config sudo libgl1-mesa-dev
RUN apt install -y linux-headers-generic

ENV PKG_CONFIG_ALLOW_CROSS=1

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

ENV PATH=/root/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/arm-linux-gnueabihf/bin/

RUN rustup toolchain add 1.54.0-x86_64-unknown-linux-gnu
RUN rustup default 1.54.0-x86_64-unknown-linux-gnu
RUN rustup target add arm-unknown-linux-gnueabihf

RUN mkdir -p /source /.cargo /usr/local/src && \
    echo "[target.arm-unknown-linux-gnueabihf]\nlinker = \"arm-linux-gnueabihf-gcc\"" > /.cargo/config

ENV CARGO_TARGET_ARMV7_UNKNOWN_LINUX_GNUEABIHF_LINKER=arm-linux-gnueabihf-gcc CC_armv7_unknown_Linux_gnueabihf=arm-linux-gnueabihf-gcc CXX_armv7_unknown_linux_gnueabihf=arm-linux-gnueabihf-g++
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/lib/arm-linux-gnueabihf/pkgconfig

WORKDIR /usr/local/src
VOLUME /usr/local/src
VOLUME /transfer

COPY . .
 
CMD cargo +1.54.0 b --release --target=arm-unknown-linux-gnueabihf && cp ./target/arm-unknown-linux-gnueabihf/release/* /transfer
