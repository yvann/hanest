#!/bin/bash -eux

echo "==> Removing all linux kernels except the currrent one"
dpkg --list | awk '{ print $2 }' | grep 'linux-image-[34].*-generic' | grep -v $(uname -r) | xargs apt-get -y purge

echo "==> Installing common packages"
aptitude -y install \
  linux-headers-$(uname -r) build-essential perl dkms \
  linux-image-extra-$(uname -r) \
  apt-transport-https ca-certificates \
  htop curl unzip tar git jq \
  python python-pip
