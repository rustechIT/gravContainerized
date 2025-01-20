FROM php:8.4.1-apache

# install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libyaml-dev \
    libzip4 \
    libzip-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
    git \
    cron \
    vim \
    && docker-php-ext-install opcache \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install zip \
    && rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=2'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
    echo 'upload_max_filesize=128M'; \
    echo 'post_max_size=128M'; \
    echo 'expose_php=off'; \
    } > /usr/local/etc/php/conf.d/php-recommended.ini


# copy your webistes conf file into the container
COPY yoursite.com.conf /etc/apache2/sites-available/
# copy apache configuration file to the container
COPY apache2.conf /etc/apache2/

# disable the default site
RUN a2dissite 000-default.conf
# enable your site
RUN a2ensite yoursite.com
# enable rewrite
RUN a2enmod rewrite
# RUN service apache2 restart

# Set user to www-data
RUN chown www-data:www-data /var/www
USER www-data

# Define Grav specific version of Grav or use latest stable
ARG GRAV_VERSION=latest

# Install grav
WORKDIR /var/www/html
RUN curl -o grav.zip -SL https://getgrav.org/download/core/grav/1.7.48 && \
    unzip grav.zip && \
    rm grav.zip
# install desired themes (cURLing them does not work because when it downloads the name throws off the unzip so you have to download them from grav and save them in the same directory)
COPY desiredtheme /var/www/html/grav/user/themes/desiretheme
# preconfigure ahead of time    
COPY site.yaml /var/www/html/grav/user/config
# preconfigure ahead of time
COPY system.yaml /var/www/html/grav/user/config
# preconfigure ahead of time
COPY hostname /etc/
# preconfigure ahead of time
COPY hosts /etc/
# RUN service apache2 restart
