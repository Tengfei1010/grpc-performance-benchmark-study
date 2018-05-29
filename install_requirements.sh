#!/bin/bash

set -ex

sudo apt-get update

# Install Java 8 JDK (to build gRPC Java)
sudo apt-get install -y openjdk-8-jdk
sudo apt-get install -y unzip lsof

sudo apt-get install -y \
  autoconf \
  autotools-dev \
  build-essential \
  bzip2 \
  ccache \
  curl \
  gcc \
  gcc-multilib \
  git \
  gyp \
  lcov \
  libc6 \
  libc6-dbg \
  libc6-dev \
  libcurl4-openssl-dev \
  libgtest-dev \
  libreadline-dev \
  libssl-dev \
  libtool \
  make \
  strace \
  pypy \
  python-dev \
  python-pip \
  python-setuptools \
  python-yaml \
  python3-dev \
  python3-pip \
  python3-setuptools \
  python3-yaml \
  telnet \
  unzip \
  wget \
  zip \
  zlib1g-dev\
  shellcheck

# perftools
sudo apt-get install -y google-perftools libgoogle-perftools-dev

# netperf
sudo apt-get install -y netperf

# C++ dependencies
sudo apt-get install -y libgflags-dev libgtest-dev libc++-dev clang

# Python dependencies
sudo pip install --upgrade pip==10.0.1
sudo pip install tabulate
sudo pip install google-api-python-client
sudo pip install virtualenv

curl -O https://bootstrap.pypa.io/get-pip.py
sudo pypy get-pip.py
sudo pypy -m pip install tabulate
sudo pip install google-api-python-client

# # Install scipy and numpy for benchmarking scripts
sudo apt-get install -y python-scipy python-numpy

# Go dependencies
# Currently, the golang package available via apt-get doesn't have the latest go.
# Significant performance improvements with grpc-go have been observed after
# upgrading from go 1.5 to a later version, so a later go version is preferred.
# Following go install instructions from https://golang.org/doc/install
GO_VERSION=1.8
OS=linux
ARCH=amd64
curl -O https://storage.googleapis.com/golang/go${GO_VERSION}.${OS}-${ARCH}.tar.gz
sudo tar -C /usr/local -xzf go$GO_VERSION.$OS-$ARCH.tar.gz
# Put go on the PATH, keep the usual installation dir
sudo ln -s /usr/local/go/bin/go /usr/bin/go
rm go$GO_VERSION.$OS-$ARCH.tar.gz


# Install perf, to profile benchmarks. (need to get the right linux-tools-<> for kernel version)
sudo apt-get install -y linux-tools-common linux-tools-generic "linux-tools-$(uname -r)"
# see http://unix.stackexchange.com/questions/14227/do-i-need-root-admin-permissions-to-run-userspace-perf-tool-perf-events-ar
echo 0 | sudo tee /proc/sys/kernel/perf_event_paranoid
# see http://stackoverflow.com/questions/21284906/perf-couldnt-record-kernel-reference-relocation-symbol
echo 0 | sudo tee /proc/sys/kernel/kptr_restrict

# qps workers under perf appear to need a lot of mmap pages under certain scenarios and perf args in
# order to not lose perf events or time out
echo 4096 | sudo tee /proc/sys/kernel/perf_event_mlock_kb

# Fetch scripts to generate flame graphs from perf data collected
# on benchmarks
git clone -v https://github.com/brendangregg/FlameGraph ~/FlameGraph
