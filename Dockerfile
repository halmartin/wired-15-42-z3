FROM ubuntu:18.04
# default to uid 1000
ARG UID=1000
ARG GID=1000

RUN apt-get update && apt-get install -y --no-install-recommends \
  gawk wget git-core diffstat unzip texinfo gcc-multilib \
  build-essential chrpath socat ca-certificates python python3 \
  python3-distutils locales rsync sharutils cpio file \
  openjdk-17-jdk sudo
  #perl binutils make build-essential flex bison ncurses-dev bc \
  #git ca-certificates python3 python

RUN locale-gen en_US.UTF-8

RUN groupadd -g ${GID} meraki && useradd -u ${UID} -g ${GID} -M -d /src meraki

WORKDIR /src

