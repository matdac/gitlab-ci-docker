FROM php:7.1-fpm
MAINTAINER Matthieu DA CONCEICAO


RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        gnupg
        
RUN apt-get install -y --install-recommends dirmngr

RUN apt-get install -y nodejs

RUN apt-get update && \
    apt-get install -y \
        openssh-client \
        curl \
        git \
        libssl1.0.0 \
        mongodb-org-shell \
        rsync \
        build-essential \
        libmemcached-dev \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libssl-dev \
        libmcrypt-dev \
        git-ftp

# Install the PHP extentions
RUN docker-php-ext-install mcrypt pdo_mysql exif pcntl bcmath

# Install the PHP gd library
RUN docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd

# Enable exif
RUN docker-php-ext-enable exif

# Install Xdebug
RUN pecl install xdebug-2.5.5 && docker-php-ext-enable xdebug

# Install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install PHP Code sniffer
RUN curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
RUN mv phpcs.phar /usr/local/bin/phpcs
RUN chmod a+x /usr/local/bin/phpcs

# Install PHP Lint
RUN curl -OL https://raw.githubusercontent.com/overtrue/phplint/master/bin/phplint
RUN mv phplint /usr/local/bin/phplint
RUN chmod a+x /usr/local/bin/phplint

# Update nodejs to stable version
RUN npm cache clean -f
RUN npm install -g n
RUN n stable

# Install stylelint
RUN npm i stylelint stylelint-config-standard && pwd && ls -lah

# Install PIP
RUN curl -O https://bootstrap.pypa.io/get-pip.py && python get-pip.py && rm get-pip.py

# SSH configuration
RUN mkdir -p ~/.ssh