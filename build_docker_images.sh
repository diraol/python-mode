#!/bin/bash

for VER in 2.7 3.5 3.6 3.7 3.7.1
do
    docker build -t python-mode:${VER} --build-arg PYTHON=${VER} -f Dockerfile .
done
