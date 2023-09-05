FROM debian:jessie-slim

COPY /src/etc/ /etc/

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install apt-utils -y \
 && apt-get clean
# && apt-get clean \
# && rm -rf /var/lib/apt/lists/*

RUN apt-get install -y libssl1.0.0 libicu52 libcurl3 libmysqlclient18 \
    bash-completion python libpython2.7 \
    libboost-filesystem1.55.0

COPY /src/deb-archive/ /tmp/deb-archive/

RUN cd /tmp \
 && tar -xzf ./deb-archive/zcp*.tar.gz \
 && cd zcp-7.2.5.109-debian-8.0-x86_64-supported \
 && rm zarafa-dbg* zarafa-dev* libgsoap-zarafa-dbg* libical-zarafa-dbg* libvmime-zarafa7-dev* zcp-nonoss-dbg* \
 && dpkg --install ./libzcp-common-util0*.deb \
 && rm ./libzcp-common-util0*.deb \
 && dpkg --install zarafa-bash-completion*.deb

RUN dpkg --install ./libzcp-common-util0*.deb

ENV SHELL=/bin/bash
WORKDIR /root
