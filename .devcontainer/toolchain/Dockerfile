# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.238.0/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version (use ubuntu-22.04 or ubuntu-18.04 on local arm64/Apple Silicon): ubuntu-22.04, ubuntu-20.04, ubuntu-18.04
ARG VARIANT="jammy"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

ENV PATH=$PATH:/buildroot/output/host/bin/
RUN export PATH

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>
WORKDIR /root/work

RUN apt update && export DEBIAN_FRONTEND=noninteractive && yes | unminimize && apt install -y \
    man \
    net-tools \
    iputils-ping \
    netcat \
    curl \
    gpg \
    gcc \
    g++ \
    gdb \
    autoconf \
    libtool \
    device-tree-compiler \
    make \
    patch \
    u-boot-tools \
    libncurses5-dev \
    mercurial \
    flex \
    bison \
    swig \
    python-dev-is-python3 \
    python3-dev \
    libyaml-dev \
    libssl-dev \
    minicom \
    wget \
    cpio \
    unzip \
    rsync \
    bzip2 \
    tree \
    bc   \
    ruby \
    btrfs-progs \
    f2fs-tools \
    cryptsetup

COPY scripts/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*


### RUN chmod +s /usr/bin/minicom

### WORKDIR buildroot


