#!/usr/bin/env bash
set -e

sudo yum groups install -y Development\ tools
sudo yum install -y cmake
sudo yum install -y python2-{devel,pip}
sudo yum install -y python34-{devel,pip}
sudo pip-2 install neovim --upgrade
sudo pip3.4 install neovim --upgrade
(
cd "$(mktemp -d)"
git clone https://github.com/neovim/neovim.git
cd neovim
make CMAKE_BUILD_TYPE=Release
sudo make install
)
