FROM debian:jessie-slim

COPY /src/etc/ /etc/

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install apt-utils -y \
 && apt-get clean
# && apt-get clean \
# && rm -rf /var/lib/apt/lists/*

RUN apt-get install -y libssl1.0.0 libicu52 libcurl3 libmysqlclient18 \
    bash-completion locales mktemp gawk w3m xsltproc unzip poppler-utils catdoc \
    python libpython2.7 python-xapian python-flask python-sleekxmpp libxml2 \
    libboost-filesystem1.55.0 libtcmalloc-minimal4 \
    php5 php5-common php5-cli

COPY /src/deb-archive/ /tmp/deb-archive/

RUN cd /tmp \
 && tar -xzf ./deb-archive/zcp*.tar.gz \
 && cd zcp-7.2.5.109-debian-8.0-x86_64-supported \
 && rm zarafa-dbg* zarafa-dev* libical-zarafa-dev* libgsoap-zarafa-dbg* \
    libical-zarafa-dbg* libvmime-zarafa7-dev* zcp-nonoss-dbg* pacemaker-zarafa* \
    zarafa-backup_* zarafa-multiserver_* \
 && dpkg --install libzcp-common-util0*.deb \
 && rm libzcp-common-util0*.deb \
 && dpkg --install zarafa-lang*.deb \
 && rm zarafa-lang*.deb \
 && dpkg --install libgsoap-zarafa-2*.deb libical-zarafa1*.deb \
 && rm libgsoap-zarafa-2*.deb libical-zarafa1*.deb \
 && dpkg --install libzcp-common-service0*.deb libzcp-common-ssl0*.deb libzcp-pydirector0*.deb \
 && rm libzcp-common-service0*.deb libzcp-common-ssl0*.deb libzcp-pydirector0*.deb \
 && dpkg --install libzarafa-soapclient0*.deb libzarafa-soapserver0*.deb \
 && rm libzarafa-soapclient0*.deb libzarafa-soapserver0*.deb \
 && dpkg --install libmapi1*.deb libzcp-common-mapi0*.deb zarafa-client*.deb \
    libzarafasync0*.deb libfreebusy0*.deb \
 && rm libmapi1*.deb libzcp-common-mapi0*.deb zarafa-client*.deb \
    libzarafasync0*.deb libfreebusy0*.deb \
 && dpkg --install libicalmapi1*.deb libinetmapi1*.deb libvmime-zarafa7*.deb \
 && rm libicalmapi1*.deb libinetmapi1*.deb libvmime-zarafa7*.deb \
 && dpkg --install libzarafa-archiver-core0*.deb libzarafa-archiver0*.deb libzcp-pyconv0*.deb zarafa-contacts*.deb\
 && rm libzarafa-archiver-core0*.deb libzarafa-archiver0*.deb libzcp-pyconv0*.deb zarafa-contacts*.deb \
 && dpkg --install python-*.deb php5-mapi*.deb \
 && rm python-*.deb php5-mapi*.deb \
 && dpkg --install libzarafa-server0*.deb zarafa-common*.deb \
 && rm libzarafa-server0*.deb zarafa-common*.deb \
 && dpkg --install zarafa*.deb

# RUN dpkg --install libzcp-*.deb

ENV SHELL=/bin/bash
WORKDIR /root
