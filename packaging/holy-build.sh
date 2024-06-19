#!/bin/bash

set -e

BUILD_TYPE=$1
NPROCS=$(grep -c ^processor /proc/cpuinfo)

echo "Build Type: ${BUILD_TYPE}"

# Activate Holy Build Box environment.
source /hbb_exe/activate
# Remove -fvisibility=hidden and -g from CFLAGS
CFLAGS=${CFLAGS//-fvisibility=hidden}
CFLAGS=${CFLAGS//-g}

set -x

# Extract and enter source
# Use /luvi dir to avoid CMake assertion failure in /
mkdir -p luvi
tar xzf /io/luvi-src.tar.gz --directory luvi
cd luvi
make ${BUILD_TYPE}
make -j${NPROCS}
ldd build/luvi
libcheck build/luvi
cp build/luvi /io
