FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get -y install software-properties-common && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install curl git zip php7.4-fpm php7.4-gd php7.4-intl \
    php7.4-curl php7.4-mysql php7.4-sqlite php7.4-xml \
    php7.4-mbstring php7.4-zip php7.4-memcached php7.4-redis php7.4-ssh2 \
    wget xz-utils libqt4-network fontconfig libjpeg8 libxrender1 libxext6 xfonts-base

# Install wkhtmltox
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bionic_amd64.deb && \
    apt-get -y install xfonts-75dpi && \
    dpkg -i wkhtmltox_0.12.6-1.bionic_amd64.deb && \
    rm wkhtmltox_0.12.6-1.bionic_amd64.deb

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD www.conf /etc/php/7.4/fpm/pool.d/

# create pid folder
RUN mkdir /run/php

CMD ["php-fpm7.4", "-F"]

EXPOSE 9000
