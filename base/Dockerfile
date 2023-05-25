FROM ubuntu:22.04
LABEL maintainer = "Marc Karasek"

# Install some base tools that we will need to get the risc-v toolchain working.
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
  autoconf \
  automake \
  apt-utils \
  autotools-dev \
  bison \
  build-essential \
  curl \
  flex \
  gawk \
  git \
  gperf \
  libmpc-dev \
  libmpfr-dev \
  libgmp-dev \
  libtool \
  patchutils \
  texinfo \
  make \
  gcc \
  python3 \
  zlib1g-dev \
  libexpat-dev \
  wget \
  cpio \
  unzip \
  rsync \
  bc \
  cmake \
  python3-pip \
  python-dev-is-python3 \
  fakeroot \
  ninja-build

RUN apt-get clean 

# Make a working folder and set the necessary environment variables.
ENV RISCV /opt/riscv64
RUN mkdir -p $RISCV

# Add the GNU utils bin folder to the path.
ENV PATH $RISCV/bin:$PATH

# Checkout the tag that was used for the build.  This will set the submodules in the repo properly
RUN git clone https://github.com/riscv/riscv-gnu-toolchain.git && cd ./riscv-gnu-toolchain && \
git checkout master && git submodule init && git submodule update
#git checkout b715e4f01b43efef487166f75d5d85d3c33fa7ef && \
#git submodule update --init riscv-binutils && \
#git submodule update --init riscv-dejagnu && \
#git submodule update --init riscv-gcc && \
#git submodule update --init riscv-glibc && \
#git submodule update --init riscv-newlib && \
#git submodule update --init riscv-gdb

# Use this if you need qemu also above are all submodules minus qemu
#git checkout master
#git submodule init && git submodule update

# GCC version 10.2.0, binutils 2.36.1
#git checkout b715e4f01b43efef487166f75d5d85d3c33fa7ef && \
# gcc 9.2.0 binutils 2.35
#git checkout b426ddd55c1e8cfc6ed991e8cdeca873f5ab2c17 && \

# configure and build the tools 
WORKDIR ./riscv-gnu-toolchain
RUN ./configure --prefix=/opt/riscv64 --with-cmodel=medany --with-arch=rv64gczicsr_zifencei --with-abi=lp64d && \
make newlib -j 4 && make linux -j 4

# Sanity check to make sure tools are compiled and PATH is set properly
RUN riscv64-unknown-linux-gnu-gcc --version && riscv64-unknown-elf-gcc --version
# Change default shell to bash instead of dash
RUN ln -sf /bin/bash /bin/sh

WORKDIR /
# cleanup build dir to make docker image smaller 
RUN rm -rf riscv-gnu-toolchain

# We are done.
