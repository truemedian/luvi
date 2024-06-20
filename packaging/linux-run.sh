#!/bin/bash

set -xeuo pipefail

LIBC=$1
ARCH=$2
LIBC_ARCH=$LIBC-$ARCH

shift 2

if [ x$LIBC == xglibc ]; then
    container_host="quay.io/pypa/manylinux2014_$ARCH"
else    
    container_host="quay.io/pypa/musllinux_1_2_$ARCH"
fi

docker run --rm \
    -v "$GITHUB_WORKSPACE":"/github/workspace" \
    -w /github/workspace \
    $container_host \
    /bin/bash packaging/linux-build.sh $ARCH $@
