#!/bin/bash

source /hbb_exe/activate
set -xeuo pipefail

BUILD_TYPE=$1
LUA_ENGINE=$2
ARCH=$3

rm -f /etc/yum.repos.d/phusion_centos-6-scl-i386.repo
yum install -y cmake3-*.$ARCH

make $BUILD_TYPE CMAKE=cmake3 WITH_LUA_ENGINE=$LUA_ENGINE
make             CMAKE=cmake3
make test        CMAKE=cmake3
