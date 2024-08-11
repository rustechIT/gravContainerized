# FROM ubuntu/apache2:2.4-22.04_edge
# FROM php:8.3.8

FROM php:8.3.8-apache


# Enable Apache Rewrite + Expires Module
RUN a2enmod rewrite expires && \
    sed -i 's/ServerTokens OS/ServerTokens ProductOnly/g' \
    /etc/apache2/conf-available/security.conf

# Install dependencies
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
# see https://secure.php.net/manual/en/opcache.installation.php\
 # echo 'upload_max_filesize=128M'; \
    # echo 'post_max_size=128M'; \
    # echo 'expose_php=off'; \
        # echo 'opcache.fast_shutdown=1'; \

RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=60'; \
    echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/php-recommended.ini

# original: 
# RUN pecl install apcu \
#     && pecl install yaml-2.0.4 \
#     && docker-php-ext-enable apcu yaml
# my edits
# RUN docker-php-ext-enable apcu yaml

COPY grav.conf /etc/apache2/sites-available/grav.conf
RUN a2dissite 000-default.conf
RUN a2ensite grav.conf
RUN a2enmod rewrite
RUN service apache2 restart

# Set user to www-data
RUN chown www-data:www-data /var/www
USER www-data

# Define Grav specific version of Grav or use latest stable
ARG GRAV_VERSION=latest

# Install grav + my edits
WORKDIR /var/www/html
RUN curl -o grav.zip -SL https://getgrav.org/download/core/grav/1.7.46 && \
    unzip grav.zip && \
    # mv /var/www/html/grav-admin /var/www/html/grav && \
    # mv -T /var/www/grav-admin /var/www/html && \
    rm grav.zip


# don't know how that works so, leaving it off
# Create cron job for Grav maintenance scripts
# RUN (crontab -l; echo "* * * * * cd /var/www/html;/usr/local/bin/php bin/grav scheduler 1>> /dev/null 2>&1") | crontab -

# Return to root user
USER root

# Copy init scripts
# COPY docker-entrypoint.sh /entrypoint.sh

# also don't know how that works so leaving that off
# provide container inside image for data persistence
# VOLUME ["/var/www/html"]

# yup also dont' know what this does
# ENTRYPOINT ["/entrypoint.sh"]
# CMD ["apache2-foreground"]
# CMD ["sh", "-c", "cron && apache2-foreground"]