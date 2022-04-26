FROM docker.io/bitnami/minideb:bullseye AS base
LABEL maintainer "laparca <laparca@laparca.es>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

RUN install_packages python3

FROM base AS builder
LABEL maintainer "laparca <laparca@laparca.es>"

ARG ASK_SONIC_REPO=https://github.com/srichter/asksonic.git
ARG ASK_SONIC_BRANCH=master

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

RUN install_packages build-essential \
                     python3 \
                     python3-pip \
                     python3-setuptools \
                     python3-dev \
                     python3-wheel \
                     git \
                     libssl-dev \
                     libffi-dev \
                     && \
    echo "Cloning $ASK_SONIC_REPO branch $ASK_SONIC_BRANCH" && \
    git clone $ASK_SONIC_REPO /asksonic && \
    if [ -n "$ASK_SONIC_BRANCH" ]; then pushd /asksonic; git checkout "$ASK_SONIC_BRANCH"; fi && \
    pip3 install -r /asksonic/requirements.txt -t /asksonic/deps

FROM base AS deploy
COPY entrypoint.sh /
COPY --from=builder /asksonic /asksonic

ENTRYPOINT ["/entrypoint.sh"]
