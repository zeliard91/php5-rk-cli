FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get -y install software-properties-common && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install curl git zip php8.1 php8.1-bz2 php8.1-cli php8.1-common php8.1-curl \
    php8.1-fpm php8.1-gd php8.1-igbinary php8.1-imagick php8.1-imap php8.1-intl php8.1-mbstring \
    php8.1-memcached php8.1-msgpack php8.1-mysql php8.1-opcache php8.1-readline php8.1-redis php8.1-ssh2 php8.1-xml php8.1-zip \
    wget xz-utils fontconfig libjpeg8 libxrender1 libxext6 xfonts-base poppler-utils

# Install wkhtmltox
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bionic_amd64.deb && \
    apt-get -y install xfonts-75dpi && \
    dpkg -i wkhtmltox_0.12.6-1.bionic_amd64.deb && \
    rm wkhtmltox_0.12.6-1.bionic_amd64.deb

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD www.conf /etc/php/8.1/fpm/pool.d/

# create pid folder
RUN mkdir /run/php

CMD ["php-fpm8.1", "-F"]

EXPOSE 9000
