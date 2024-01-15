#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

cd /buildroot

rsync -a /workspace/config/board/ /buildroot/board/
rsync -a /workspace/config/configs/ /buildroot/configs/
rsync -a /workspace/config/package/ /buildroot/package/

make sesl_defconfig