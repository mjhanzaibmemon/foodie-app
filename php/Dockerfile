# ---------- Stage 1: Build Composer deps ----------
FROM composer:2 AS vendor

WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --prefer-dist --no-progress --no-interaction

# ---------- Stage 2: LiteSpeed runtime ----------
FROM litespeedtech/openlitespeed:latest

# Install PHP extensions you need (similar to before)
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libicu-dev libpq-dev libonig-dev \
 && docker-php-ext-install pdo pdo_mysql intl zip opcache \
 && rm -rf /var/lib/apt/lists/*

# Optional: Configure Opcache
RUN { echo "opcache.enable=1"; \
      echo "opcache.jit_buffer_size=64M"; \
      echo "opcache.jit=tracing"; } > /usr/local/lsws/lsphp81/etc/php.d/99-opcache.ini

# ---------- Copy app code ----------
# Use /usr/local/lsws/Example/html as the web root
WORKDIR /usr/local/lsws/Example/html

# Copy app code (only public-facing files)
COPY public/ ./

# Copy vendor deps from Composer build stage
COPY --from=vendor /app/vendor /usr/local/lsws/Example/html/vendor

# Copy any backend logic (if not under public/)

# ---------- Configure LiteSpeed ----------
# Change LiteSpeed default document root to public/
RUN sed -i 's|$VH_ROOT/html|$VH_ROOT|g' /usr/local/lsws/conf/httpd_config.conf

# Expose LiteSpeed ports
EXPOSE 8088 7080

# Start LiteSpeed
CMD ["/usr/local/lsws/bin/lswsctrl", "start", "-d", "&&", "tail", "-f", "/usr/local/lsws/logs/error.log"]
