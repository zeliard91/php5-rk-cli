FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Prevent services from starting during installation
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d

# Add ondrej/php repository and install everything in one layer
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    lsb-release && \
    echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ondrej-php.list && \
    curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c" -o /tmp/ondrej.key && \
    gpg --dearmor < /tmp/ondrej.key > /etc/apt/trusted.gpg.d/ondrej-php.gpg && \
    rm /tmp/ondrej.key && \
    apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install --no-install-recommends \
    openssh-client git zip wget xz-utils unzip 7zip-standalone vim \
    php8.3-bz2 php8.3-cli php8.3-common php8.3-curl \
    php8.3-fpm php8.3-gd php8.3-igbinary php8.3-imagick php8.3-imap php8.3-intl php8.3-mbstring \
    php8.3-memcached php8.3-msgpack php8.3-mysql php8.3-opcache php8.3-readline php8.3-redis php8.3-ssh2 php8.3-xml php8.3-zip php8.3-soap php8.3-gmp php8.3-bcmath \
    fontconfig libjpeg8 libxrender1 libxext6 xfonts-base poppler-utils xfonts-75dpi \
    libasound2t64 libatk1.0-0 libatk-bridge2.0-0 libcups2 libxcomposite1 libxrandr2 libxdamage1 \
    libxkbcommon0 libpangocairo-1.0-0 libpango-1.0-0 libgbm1 libnss3 libxcb1 libxshmfence1 libxfixes3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm -rf /usr/share/doc /usr/share/man /usr/share/locale

# Install wkhtmltox and clean up in same layer
RUN wget -q https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb && \
    dpkg -i wkhtmltox_0.12.6.1-2.jammy_amd64.deb || (apt-get update && apt-get -y -f install) && \
    rm wkhtmltox_0.12.6.1-2.jammy_amd64.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    rm -rf /tmp/*

# Install Chrome and ChromeDriver, clean up in same layer
RUN wget -q https://github.com/ungoogled-software/ungoogled-chromium-portablelinux/releases/download/138.0.7204.100-1/ungoogled-chromium_138.0.7204.100-1_linux.tar.xz && \
    tar -xJf ungoogled-chromium_138.0.7204.100-1_linux.tar.xz && \
    mv ungoogled-chromium_138.0.7204.100-1_linux /opt/chrome && \
    find /opt/chrome/locales -type f ! -name 'en-US.pak' -delete && \
    find /opt/chrome -type f -name '*.pak' ! -name 'en-US.pak' ! -name 'resources.pak' ! -name 'chrome_100_percent.pak' -delete && \
    ln -s /opt/chrome/chrome /usr/local/bin/chrome && \
    ln -s /opt/chrome/chromedriver /usr/local/bin/chromedriver && \
    rm ungoogled-chromium_138.0.7204.100-1_linux.tar.xz

ADD www.conf /etc/php/8.3/fpm/pool.d/

CMD ["php-fpm8.3", "-F"]

EXPOSE 9000