# syntax=docker/dockerfile:1

FROM ubuntu:18.04 AS base
RUN apt update && apt install -y \
    bc \
    binutils-aarch64-linux-gnu \
    bison \
    build-essential \
    ca-certificates \
    cpio \
    curl \
    flex \
    gcc \
    gcc-aarch64-linux-gnu \
    git \
    gnupg \
    libelf-dev \
    libelf-dev \
    libncurses-dev \
    libssl-dev \
    lsb-release \
    make \
    software-properties-common \
    wget

FROM base as llvm

ENV LLVM_VERSION=13
RUN wget https://apt.llvm.org/llvm.sh \
    && chmod +x llvm.sh \
    && ./llvm.sh $LLVM_VERSION \
    && rm ./llvm.sh \
    && ln -s --force /usr/bin/clang-$LLVM_VERSION /usr/bin/clang \
    && ln -s --force /usr/bin/ld.lld-$LLVM_VERSION /usr/bin/ld.lld \
    && ln -s --force /usr/bin/llvm-objdump-$LLVM_VERSION /usr/bin/llvm-objdump \
    && ln -s --force /usr/bin/llvm-ar-$LLVM_VERSION /usr/bin/llvm-ar \
    && ln -s --force /usr/bin/llvm-nm-$LLVM_VERSION /usr/bin/llvm-nm \
    && ln -s --force /usr/bin/llvm-strip-$LLVM_VERSION /usr/bin/llvm-strip \
    && ln -s --force /usr/bin/llvm-objcopy-$LLVM_VERSION /usr/bin/llvm-objcopy \
    && ln -s --force /usr/bin/llvm-readelf-$LLVM_VERSION /usr/bin/llvm-readelf \
    && ln -s --force /usr/bin/clang++-$LLVM_VERSION /usr/bin/clang++

FROM llvm
ENV KERNEL_ROOT=/src
WORKDIR $KERNEL_ROOT
CMD [ "/bin/sh", "-c" , "make -j$(nproc) LLVM=1 bzImage" ]
