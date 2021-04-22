#FROM ubuntu:18.04
FROM ubuntu:20.04
LABEL maintainer = "Marc Karasek"

# Vars for tzdata install
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

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
  bc \
  cmake \
  device-tree-compiler \
  opam \
  z3 \
  pkg-config


# Make a working folder and set the necessary environment variables.
ENV RISCV /opt/riscv64
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

#install spike
RUN git clone https://github.com/riscv/riscv-isa-sim.git
WORKDIR ./riscv-isa-sim
RUN mkdir build && cd build && ../configure --prefix=$RISCV && make && make install 

WORKDIR /
RUN rm -rf riscv-isa-sim

#install SAIL using opam
RUN opam init --disable-sandboxing --yes && opam switch create ocaml-base-compiler.4.06.1 && eval $(opam config env) && opam install sail --yes


# Run this docker image now with the dev_riscv as a volume. 
# cd into spike_sail
# execute the sailbuild.sh script
# After sail-riscv is done building/installed remove the repo
# Use docker commit to create a new image from the running container with riscv-sail installed
# docker commmit -m "commit msg" -a "author" <image ID> <new image name:version>