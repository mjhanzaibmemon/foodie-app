# ---------- Stage 1: deps ----------
FROM composer:2 AS vendor

# Optional: speed up installs using cache if composer.lock exists
WORKDIR /app
COPY composer.json composer.lock ./
# If you need private GitHub packages, pass COMPOSER_AUTH at build time (see step 4)
RUN composer install --no-dev --prefer-dist --no-progress --no-interaction

# Copy the rest of the app and optimize autoload later in the final stage
# We only need vendor/ from this stage
# -------------------------------------------------------------

# ---------- Stage 2: runtime ----------
FROM php:8.2-fpm

# System deps (add as needed)
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libicu-dev libpq-dev libonig-dev \
 && docker-php-ext-install pdo pdo_mysql intl zip \
 && rm -rf /var/lib/apt/lists/*

# (Optional) Opcache for prod performance
RUN docker-php-ext-install opcache \
 && { echo "opcache.enable=1"; \
      echo "opcache.jit_buffer_size=64M"; \
      echo "opcache.jit=tracing"; } > /usr/local/etc/php/conf.d/opcache.ini

WORKDIR /var/www/html

# Copy application code
COPY . .

# Copy vendor deps from the Composer stage
COPY --from=vendor /app/vendor /var/www/html/vendor

# Optimize autoload (class map) now that code is in place
RUN php -d detect_unicode=0 -r "copy('https://getcomposer.org/installer','composer-setup.php');" \
 && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
 && composer dump-autoload --optimize --no-dev --classmap-authoritative \
 && rm -f composer-setup.php

# Health + runtime
EXPOSE 9000
CMD ["php-fpm"]
