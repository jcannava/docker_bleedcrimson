FROM php:5.6-fpm
MAINTAINER jason@cannavale.com

# Generate locale files
RUN locale-gen en_US.UTF-8

# Export it
ENV LANG en_US.UTF-8

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y build-essential curl libcurl4-gnutls-dev \
                       libmysqlclient-dev libhiredis-dev liboping-dev \
                       libyajl-dev libpq-dev git-core python libfreetype6-dev \
                       libjpeg62-turbo-dev libmcrypt-dev libpng12-dev wget\ 
                       git libmemcached-dev zlib1g-dev libsasl2-dev

RUN cd /opt && wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
RUN cd /opt && tar -xvzf /opt/libmemcached-1.0.18.tar.gz && cd libmemcached-1.0.18 && ./configure && make && make install

RUN docker-php-source extract \
        && git clone --branch master https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached/ \
        && docker-php-ext-install memcached
RUN docker-php-ext-install -j$(nproc) mysqli
