ARG IMAGE=php:7-apache

FROM composer:1 AS build

WORKDIR /build
ADD web/composer.json .
ADD web/composer.lock .
ADD web/server.php .
RUN composer global require hirak/prestissimo && composer install

# Build PHP
FROM ${IMAGE}

WORKDIR /var/webdav
COPY --from=build /build/ /var/webdav

COPY scripts/entrypoint.sh /entrypoint.sh
COPY scripts/install.sh /install.sh
COPY config/apache/vhost.conf /etc/apache2/sites-available/000-default.conf
COPY config/php/webdav.ini /usr/local/etc/php/conf.d/

RUN a2enmod rewrite

# Default webdav user (CHANGE THIS!)
ENV           WEBDAV_USERNAME admin
ENV           WEBDAV_PASSWORD admin
ENV           SKIP_PERMISSIONS_FIX no

# # Defaults
WORKDIR       /var/webdav
VOLUME        /var/webdav/public
VOLUME        /var/webdav/data

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "apache2-foreground" ]