#!/bin/bash

eval $(opam env)
sail --help

# Clone RiscV Sail
git clone https://github.com/rems-project/sail-riscv.git
cd ./sail-riscv
export INSTALL_DIR /usr/
make opam-build
make opam-install 