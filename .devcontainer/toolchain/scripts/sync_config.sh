#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

rsync -a /workspace/config/board/ /buildroot/board/
rsync -a /workspace/config/configs/ /buildroot/configs/