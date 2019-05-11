#!/bin/bash
set -ex

VERSIONS=$@

if [[ -z "$VERSIONS" ]]; then
    VERSIONS=2.7 3.5 3.6 3.7 3.7.1
fi

for VER in $VERSIONS
do
    echo "Building version $VER"
    docker build -t python-mode:${VER} --build-arg PYTHON=${VER} -f Dockerfile .
done
