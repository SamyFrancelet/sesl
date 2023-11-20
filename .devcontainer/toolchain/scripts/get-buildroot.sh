#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

git clone git://git.buildroot.net/buildroot /buildroot

cd /buildroot
git checkout -b sesl 2022.08.3

rsync -a /workspace/config/board/ /buildroot/board/
rsync -a /workspace/config/configs/ /buildroot/configs/

make sesl_defconfig
