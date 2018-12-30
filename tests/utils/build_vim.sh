#!/bin/bash
set -e
SPACER="#####################################################################"

PYTHON=$1
echo "Python version: ${PYTHON}"

cd /opt/vim

args=(  )
# args+=( --with-features=huge )
args+=( --enable-multibyte )
args+=( --enable-cscope )

PYTHON_CONFIG_DIR=$(find /usr -type d -name 'config*' | grep python | grep -v dist-packages)

if [[ ${PYTHON} =~ ^2 ]]; then
    args+=( --enable-pythoninterp=yes )
    args+=( --with-python-config-dir=${PYTHON_CONFIG_DIR} )
else
    args+=( --enable-python3interp=yes )
    args+=( --with-python3-config-dir=${PYTHON_CONFIG_DIR} )
fi

args+=( --prefix=/usr/local )

echo ${SPACER}
echo Starting build with args: ${args[@]}
echo ${SPACER}

./configure ${args[@]}

make

make install

echo ${SPACER}
echo vim installed with config args: ${args[@]}
echo ${SPACER}
