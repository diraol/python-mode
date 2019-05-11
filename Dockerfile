# VERSION 1.0.0
# AUTHOR: Diego Rabatone Oliveira (@diraol)
# DESCRIPTION: Image used to test python-mode
# BUILD: Use the build_docker_images.sh file
#   docker build -t python-mode:<VER> -f Dockerfile --build-arg PYTHON=<VER> .
# SOURCE: https://github.com/python-mode/python-mode
ARG PYTHON
FROM python:$PYTHON

# Passing arg inside the build stage
ARG PYTHON

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# https://docs.python.org/3.6/using/cmdline.html#envvar-PYTHONUNBUFFERED
# https://github.com/sclorg/s2i-python-container/issues/157
ENV PYTHONUNBUFFERED 1

# Clonning and building VIM for the specific python version
COPY ./tests/utils/build_vim.sh /opt/build_vim.sh
RUN set -ex \
    && cd /opt \
    && chmod +x build_vim.sh \
    && git clone https://github.com/vim/vim.git \
    && ./build_vim.sh ${PYTHON} \
    && rm -rf vim build_vim.sh

ENV PYTHON_MODE_HOME /root/.vim/pack/foo/start/python-mode/
ENV VIM_RC /root/.vimrc
ENV PYMODE_RC /root/.pymoderc
ENV TEST_PATH /root/tests

COPY . ${PYTHON_MODE_HOME}
RUN set -ex \
    && cd ${PYTHON_MODE_HOME} \
    && find . -type f -name '*.pyc' -delete \
    && find . -type d -name '__pycache__' -delete \
    && mkdir -p /root/tests \
    && ln -s ${PYTHON_MODE_HOME}tests/utils/test.py ${TEST_PATH} \
    && ln -s ${PYTHON_MODE_HOME}tests/utils/pymoderc ${PYMODE_RC} \
    && ln -s ${PYTHON_MODE_HOME}tests/utils/vimrc ${VIM_RC} \
    && touch /root/.vimrc.before /root/.vimrc.after

RUN set -ex && vim -e -s -c ':exec ":helptags ALL" | exec ":qall!"'

WORKDIR /root
ENTRYPOINT ["/bin/bash"]
