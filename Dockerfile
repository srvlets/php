FROM alpine
 RUN apk update
 RUN apk upgrade
 RUN apk add autoconf
 RUN apk add automake
 RUN apk add bison
 RUN apk add file
 RUN apk add gcc
 RUN apk add libc-dev
 RUN apk add libtool
 RUN apk add make
 RUN apk add re2c
 RUN apk add openssl
 RUN apk add openssl-dev

ENV php \
"php-7.0.11"

ENV pthreads \
"pthreads-3.1.6"

RUN mkdir \
"/src"

RUN wget \
"https://php.net/get/${php}.tar.xz/from/this/mirror" -O \
"/src/${php}.tar.xz"

RUN wget \
"https://pecl.php.net/get/${pthreads}.tgz" -O \
"/src/${pthreads}.tgz"

RUN wget \
"https://getcomposer.org/installer" -O \
"/src/composer-setup.php"

RUN tar -xf \
"/src/${php}.tar.xz" -C \
"/src"

RUN tar -xf \
"/src/${pthreads}.tgz" -C \
"/src"

RUN mv \
"/src/${pthreads}" \
"/src/${php}/ext/pthreads"

WORKDIR \
"/src/${php}"

RUN ./buildconf \
    --force

RUN ./configure \
    --with-config-file-path=/etc/php \
    --disable-all \
    --disable-phpdbg \
    --disable-cgi \
    --enable-maintainer-zts \
    --enable-pthreads \
    --enable-json \
    --enable-phar \
    --enable-filter \
    --enable-hash \
    --enable-mbstring \
    --with-openssl

RUN make
RUN make install
RUN make distclean

RUN apk del autoconf
RUN apk del automake
RUN apk del bison
RUN apk del file
RUN apk del gcc
RUN apk del libc-dev
RUN apk del libtool
RUN apk del make
RUN apk del re2c
RUN apk del openssl
RUN apk del openssl-dev

WORKDIR \
"/"

RUN php \
"/src/composer-setup.php" \
"--install-dir=/usr/local/bin"

RUN mkdir \
"/etc/php"

RUN cp \
"/src/${php}/php.ini-production" \
"/etc/php/php.ini"

RUN rm -rf \
"/src"
