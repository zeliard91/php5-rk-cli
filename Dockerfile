FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install --no-install-recommends software-properties-common && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install --no-install-recommends openssh-client curl git zip php8.3 php8.3-bz2 php8.3-cli php8.3-common php8.3-curl \
    php8.3-fpm php8.3-gd php8.3-igbinary php8.3-imagick php8.3-imap php8.3-intl php8.3-mbstring \
    php8.3-memcached php8.3-msgpack php8.3-mysql php8.3-opcache php8.3-readline php8.3-redis php8.3-ssh2 php8.3-xml php8.3-zip php8.3-soap \
    wget xz-utils fontconfig libjpeg8 libxrender1 libxext6 xfonts-base poppler-utils xfonts-75dpi vim unzip \
    libasound2t64 libatk1.0-0 libatk-bridge2.0-0 libcups2 libxcomposite1 libxrandr2 libxdamage1 libxkbcommon0  libpangocairo-1.0-0 libpango-1.0-0 libgbm1 libnss3 libxcb1 libxshmfence1 libxfixes3 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install wkhtmltox
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb && \
    dpkg -i wkhtmltox_0.12.6.1-2.jammy_amd64.deb && \
    rm wkhtmltox_0.12.6.1-2.jammy_amd64.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Chrome
RUN wget https://storage.googleapis.com/chrome-for-testing-public/138.0.7204.157/linux64/chrome-linux64.zip && \
    unzip chrome-linux64.zip && \
    mv chrome-linux64 /opt/chrome && \
    ln -s /opt/chrome/chrome /usr/local/bin/chrome && \
    rm chrome-linux64.zip

# Install ChromeDriver
RUN wget https://storage.googleapis.com/chrome-for-testing-public/138.0.7204.157/linux64/chromedriver-linux64.zip && \
    unzip chromedriver-linux64.zip && \
    mv chromedriver-linux64/chromedriver /usr/local/bin/chromedriver && \
    chmod +x /usr/local/bin/chromedriver && \
    rm -rf chromedriver-linux64*


ADD www.conf /etc/php/8.3/fpm/pool.d/

CMD ["php-fpm8.3", "-F"]

EXPOSE 9000
