FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" >> /etc/apt/sources.list && \
    echo "deb-src http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-key E5267A6C && \
    apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install curl git php7.2-fpm php7.2-gd php7.2-intl \
    php7.2-curl php7.2-mysql php7.2-sqlite php7.2-xml \
    php7.2-mbstring php7.2-zip php-memcached php-redis php7.2-zip php-ssh2 \
    wget xz-utils libqt4-network fontconfig libjpeg8 libxrender1 libxext6 xfonts-base

# Install wkhtmltox
RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.xenial_amd64.deb && \
    apt-get -y install xfonts-75dpi && \
    dpkg -i wkhtmltox_0.12.5-1.xenial_amd64.deb && \
    rm wkhtmltox_0.12.5-1.xenial_amd64.deb

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD www.conf /etc/php/7.2/fpm/pool.d/

# create pid folder
RUN mkdir /run/php

CMD ["php-fpm7.2", "-F"]

EXPOSE 9000
