FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list && \
    echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu trusty main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-key E5267A6C && \
    apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install curl git php7.0-fpm php7.0-gd php7.0-intl \
    php7.0-mcrypt php7.0-curl php7.0-mysql php7.0-sqlite php7.0-xml

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD www.conf /etc/php/7.0/fpm/pool.d/

# create pid folder
RUN mkdir /run/php

CMD ["php-fpm7.0", "-F"]

EXPOSE 9000
