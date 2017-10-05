FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" >> /etc/apt/sources.list && \
    echo "deb-src http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-key E5267A6C && \
    apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install curl git libxrender1 php7.1-fpm php7.1-gd php7.1-intl \
    php7.1-mcrypt php7.1-curl php7.1-mysql php7.1-sqlite php7.1-xml \
    php7.1-mbstring php7.1-zip php-memcached php-redis php7.1-zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD www.conf /etc/php/7.1/fpm/pool.d/

# create pid folder
RUN mkdir /run/php

CMD ["php-fpm7.1", "-F"]

EXPOSE 9000
