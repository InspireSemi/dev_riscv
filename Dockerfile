FROM ubuntu:18.04
#FROM ubuntu:20.04
LABEL maintainer = "Marc Karasek"

# Install some base tools that we will need to get the risc-v
# toolchain working.
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  autoconf \
  automake \
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
  bc

# Make a working folder and set the necessary environment variables.
ENV RISCV /opt/riscv64
ENV NUMJOBS 1
RUN mkdir -p $RISCV

# Add the GNU utils bin folder to the path.
ENV PATH $RISCV/bin:$PATH

# Checkout the tag that was used for the build.  This will set the submodules in the repo properly
RUN git clone https://github.com/riscv/riscv-gnu-toolchain && cd ./riscv-gnu-toolchain && \
git checkout master && \
git submodule init && git submodule update

#git checkout b426ddd55c1e8cfc6ed991e8cdeca873f5ab2c17 && \

# configure and build the tools 
WORKDIR ./riscv-gnu-toolchain
RUN ./configure --prefix=/opt/riscv64 --with-cmodel=medany --with-arch=rv64imafdc --with-abi=lp64d && \
make newlib -j 4 && make linux -j 4

# Sanity check to make sure tools are compiled and PATH is set properly
RUN riscv64-unknown-linux-gnu-gcc --version && riscv64-unknown-elf-gcc --version
# Change default shell to bash instead of dash
RUN ln -sf /bin/bash /bin/sh

WORKDIR /
# cleanup build dir to make docker image smaller 
RUN rm -rf riscv-gnu-toolchain

# We are done.
