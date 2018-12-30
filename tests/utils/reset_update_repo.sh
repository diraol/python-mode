#!/bin/bash

git reset --hard HEAD
git checkout origin develop
git pull origin develop
git submodule sync --recursive
git submodule update --init --recursive
