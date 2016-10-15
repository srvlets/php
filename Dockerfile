FROM alpine:3.4

RUN apk update
RUN apk upgrade
RUN apk add ca-certificates
RUN apk add openssl
RUN apk add openssl-dev
RUN apk add autoconf
RUN apk add automake
RUN apk add bison
RUN apk add file
RUN apk add gcc
RUN apk add libc-dev
RUN apk add libtool
RUN apk add make
RUN apk add re2c

RUN mkdir \
"/src"


# php

ENV php \
"7.0.12"

RUN wget \
"https://php.net/get/php-${php}.tar.xz/from/this/mirror" -O \
"/src/php-${php}.tar.xz"

RUN tar -xf \
"/src/php-${php}.tar.xz" -C \
"/src"

WORKDIR \
"/src/php-${php}"

RUN ./buildconf \
    --force
RUN ./configure \
    --with-config-file-path=/etc/php \
    --disable-all \
    --disable-phpdbg \
    --disable-cgi \
    --enable-maintainer-zts

RUN make
RUN make install
RUN make distclean


# filter

WORKDIR \
"/src/php-${php}/ext/filter"

RUN phpize
RUN ./configure \
    --enable-filter

RUN make
RUN make install
RUN make distclean


# hash

WORKDIR \
"/src/php-${php}/ext/hash"

RUN phpize
RUN ./configure \
    --enable-hash

RUN make
RUN make install
RUN make distclean


# json

WORKDIR \
"/src/php-${php}/ext/json"

RUN phpize
RUN ./configure \
    --enable-json

RUN make
RUN make install
RUN make distclean


# mbstring

WORKDIR \
"/src/php-${php}/ext/mbstring"

RUN phpize
RUN ./configure \
    --enable-mbstring

RUN make
RUN make install
RUN make distclean


# pcntl

WORKDIR \
"/src/php-${php}/ext/pcntl"

RUN phpize
RUN ./configure \
    --enable-pcntl

RUN make
RUN make install
RUN make distclean


# phar

WORKDIR \
"/src/php-${php}/ext/phar"

RUN phpize
RUN ./configure \
    --enable-phar

RUN make
RUN make install
RUN make distclean


# openssl

WORKDIR \
"/src/php-${php}/ext/openssl"

RUN mv \
"/src/php-${php}/ext/openssl/config0.m4" \
"/src/php-${php}/ext/openssl/config.m4"

RUN phpize
RUN ./configure \
    --with-openssl

RUN make
RUN make install
RUN make distclean


# ev

ENV ev \
"1.0.3"

RUN wget \
"https://pecl.php.net/get/ev-${ev}.tgz" -O \
"/src/ev-${ev}.tgz"

RUN tar -xf \
"/src/ev-${ev}.tgz" -C \
"/src"

WORKDIR \
"/src/ev-${ev}"

RUN phpize
RUN ./configure \
    --enable-ev

RUN make
RUN make install
RUN make distclean


# pthreads

ENV pthreads \
"3.1.6"

RUN wget \
"https://pecl.php.net/get/pthreads-${pthreads}.tgz" -O \
"/src/pthreads-${pthreads}.tgz"

RUN tar -xf \
"/src/pthreads-${pthreads}.tgz" -C \
"/src"

WORKDIR \
"/src/pthreads-${pthreads}"

RUN phpize
RUN ./configure \
    --enable-pthreads

RUN make
RUN make install
RUN make distclean


# composer

COPY php.ini /etc/php/php.ini

RUN wget \
"https://getcomposer.org/installer" -O \
"/src/composer-setup.php"

RUN php \
"/src/composer-setup.php" \
"--install-dir=/usr/local/bin"


# cleanup

WORKDIR \
"/"

RUN rm -rf \
"/src"

RUN apk del ca-certificates
RUN apk del openssl
RUN apk del openssl-dev
RUN apk del autoconf
RUN apk del automake
RUN apk del bison
RUN apk del file
RUN apk del gcc
RUN apk del libc-dev
RUN apk del libtool
RUN apk del make
RUN apk del re2c
