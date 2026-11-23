FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Use the French Ubuntu mirror (default archive/security mirrors are very slow)
RUN sed -i -E 's#http://(archive|security)\.ubuntu\.com#http://fr.archive.ubuntu.com#g' /etc/apt/sources.list

# Add packages.sury.org PHP repository (replaces frozen ondrej/php PPA)
RUN apt-get update && \
    apt-get -y install --no-install-recommends ca-certificates curl lsb-release && \
    curl -fsSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb && \
    dpkg -i /tmp/debsuryorg-archive-keyring.deb && \
    rm /tmp/debsuryorg-archive-keyring.deb && \
    echo "deb [signed-by=/usr/share/keyrings/debsuryorg-archive-keyring.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install curl git zip php7.4-fpm php7.4-gd php7.4-intl \
    php7.4-curl php7.4-mysql php7.4-sqlite3 php7.4-xml \
    php7.4-mbstring php7.4-zip php7.4-memcached php7.4-redis php7.4-ssh2 \
    wget xz-utils fontconfig libjpeg8 libxrender1 libxext6 xfonts-base

# Install wkhtmltox
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb && \
    apt-get -y install ./wkhtmltox_0.12.6.1-2.jammy_amd64.deb && \
    rm wkhtmltox_0.12.6.1-2.jammy_amd64.deb

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD www.conf /etc/php/7.4/fpm/pool.d/

# create pid folder
RUN mkdir -p /run/php

CMD ["php-fpm7.4", "-F"]

EXPOSE 9000
