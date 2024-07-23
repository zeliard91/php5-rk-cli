FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install software-properties-common && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install --no-install-recommends curl git zip php8.3 php8.3-bz2 php8.3-cli php8.3-common php8.3-curl \
    php8.3-fpm php8.3-gd php8.3-igbinary php8.3-imagick php8.3-imap php8.3-intl php8.3-mbstring \
    php8.3-memcached php8.3-msgpack php8.3-mysql php8.3-opcache php8.3-readline php8.3-redis php8.3-ssh2 php8.3-xml php8.3-zip php8.3-soap \
    wget xz-utils fontconfig libjpeg8 libxrender1 libxext6 xfonts-base poppler-utils wkhtmltopdf


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD www.conf /etc/php/8.3/fpm/pool.d/

CMD ["php-fpm8.3", "-F"]

EXPOSE 9000
