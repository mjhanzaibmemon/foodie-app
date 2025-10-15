FROM litespeedtech/openlitespeed:latest

# Add LiteSpeed repo
RUN apt-get update && apt-get install -y curl gnupg2 ca-certificates && \
    curl -s https://repo.litespeed.sh | bash

# Install PHP 8.1 and common extensions
RUN apt-get update && apt-get install -y \
    lsphp81 lsphp81-common lsphp81-mysql lsphp81-intl lsphp81-curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory (default OLS doc root)
WORKDIR /usr/local/lsws/Example/html

# Remove default files
RUN rm -rf /usr/local/lsws/Example/html/*

# Copy your PHP app (e.g., index.php inside ./public)
COPY public/ ./

# Set up PHP 8.1 handler
RUN ln -sf /usr/local/lsws/lsphp81/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp

# Copy virtual host config
COPY ols-vhconf.conf /usr/local/lsws/conf/vhosts/Example/vhconf.conf

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8088

CMD ["/entrypoint.sh"]