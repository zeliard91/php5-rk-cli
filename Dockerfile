FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Use the French Ubuntu mirror (default archive/security mirrors are very slow)
RUN sed -i -E 's#http://(archive|security)\.ubuntu\.com#http://fr.archive.ubuntu.com#g' /etc/apt/sources.list.d/ubuntu.sources

# Prevent services from starting during installation
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d

# Add packages.sury.org PHP repository (replaces frozen ondrej/php PPA) and install everything in one layer
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    ca-certificates \
    curl \
    lsb-release && \
    curl -fsSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb && \
    dpkg -i /tmp/debsuryorg-archive-keyring.deb && \
    rm /tmp/debsuryorg-archive-keyring.deb && \
    echo "deb [signed-by=/usr/share/keyrings/debsuryorg-archive-keyring.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install --no-install-recommends \
    openssh-client git zip wget xz-utils unzip 7zip-standalone vim \
    php8.5-bz2 php8.5-cli php8.5-common php8.5-curl \
    php8.5-fpm php8.5-gd php8.5-igbinary php8.5-imagick php8.5-imap php8.5-intl php8.5-mbstring \
    php8.5-memcached php8.5-msgpack php8.5-mysql php8.5-readline php8.5-redis php8.5-ssh2 php8.5-xml php8.5-zip php8.5-soap php8.5-gmp php8.5-bcmath php8.5-gnupg \
    fontconfig libjpeg8 libxrender1 libxext6 xfonts-base poppler-utils xfonts-75dpi \
    libasound2t64 libatk1.0-0 libatk-bridge2.0-0 libcups2 libxcomposite1 libxrandr2 libxdamage1 tnef \
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

ADD www.conf /etc/php/8.5/fpm/pool.d/

CMD ["php-fpm8.5", "-F"]

EXPOSE 9000