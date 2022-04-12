FROM docker.io/bitnami/minideb:bullseye AS base
LABEL maintainer "laparca <laparca@laparca.es>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

RUN install_packages python3

FROM base AS builder
LABEL maintainer "laparca <laparca@laparca.es>"

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
    git clone https://github.com/srichter/asksonic.git /asksonic && \
    pip3 install -r /asksonic/requirements.txt -t /asksonic/deps

FROM base AS deploy
COPY entrypoint.sh /
COPY --from=builder /asksonic /asksonic

ENTRYPOINT ["/entrypoint.sh"]
