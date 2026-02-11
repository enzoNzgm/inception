FROM debian:bullseye

# Installer PHP-FPM et dépendances WordPress
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-cli \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-curl \
    php7.4-gd \
    php7.4-zip \
    mariadb-client \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Télécharger et installer WordPress
RUN wget https://wordpress.org/latest.tar.gz -P /tmp && \
    cd /tmp && \
    tar -xzf latest.tar.gz && \
    rm latest.tar.gz && \
    mkdir -p /var/www/html && \
    mv /tmp/wordpress/* /var/www/html/ && \
    rm -rf /tmp/wordpress && \
    chown -R www-data:www-data /var/www/html

# Télécharger et installer WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Créer le répertoire pour PHP-FPM
RUN mkdir -p /run/php && chown www-data:www-data /run/php

# Copier la configuration PHP-FPM
RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf

# Copier le script de configuration
COPY conf/auto-config.sh /usr/local/bin/auto-config.sh
RUN chmod +x /usr/local/bin/auto-config.sh

# Exposer le port PHP-FPM
EXPOSE 9000

# Lancer le script de configuration
CMD ["/usr/local/bin/auto-config.sh"]
