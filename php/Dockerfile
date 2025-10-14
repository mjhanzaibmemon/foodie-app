# ---------- Stage 1: Build Composer deps ----------
FROM composer:2 AS vendor

WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --prefer-dist --no-progress --no-interaction

# In your LSWS stage
FROM litespeedtech/openlitespeed:latest

# Install system deps
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libicu-dev libpq-dev libonig-dev \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions using LiteSpeed's helper
RUN lsphp81-ext-install pdo_mysql intl zip opcache

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
