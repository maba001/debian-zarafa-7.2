FROM debian:jessie-slim

COPY /src/etc/ /etc/

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y apt-utils \
 && apt-get install -y bash-completion locales mktemp gawk w3m tk wish unzip zip poppler-utils catdoc \
 && apt-get install -y perl perl-modules rename \
 && apt-get install -y libssl1.0.0 libicu52 libcurl3 libmysqlclient18 openssl \
 && apt-get install -y libxml2 xsltproc libboost-filesystem1.55.0 libtcmalloc-minimal4 \
 && apt-get install -y python libpython2.7 python-xapian python-flask python-sleekxmpp  \
 && apt-get install -y php5 php5-common php5-cli \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY /src/deb-archive/ /tmp/deb-archive/

RUN cd /tmp/deb-archive/ \
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

ENV SHELL=/bin/bash
WORKDIR /root

COPY /src/usr/ /usr/

# /etc/apache2/sites-available/000-default.conf:  #ServerName www.example.com
RUN sed -i '/^#ServerRoot/a ServerName zarafa\.local' /etc/apache2/apache2.conf \
 && sed -i 's/#\s*ServerName.*/ServerName zarafa\.local/' /etc/apache2/sites-available/000-default.conf \
 && cd /etc/apache2/sites-enabled \
 && ln -s ../sites-available/002-zarafa-webapp.conf .

CMD [ "/usr/local/bin/startup" ]