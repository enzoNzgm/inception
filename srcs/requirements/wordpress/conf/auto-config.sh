#!/bin/bash
set -e

cd /var/www/html

# Attendre que MariaDB soit prêt
echo "Waiting for MariaDB to be ready..."
until mysql -h mariadb -u"$SQL_USER" -p"$SQL_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; do
    echo "MariaDB is unavailable - sleeping"
    sleep 3
done
echo "MariaDB is up - continuing"

# Créer wp-config.php si il n'existe pas
if [ ! -f wp-config.php ]; then
    echo "Creating WordPress configuration..."
    wp config create --allow-root \
        --dbname="$SQL_DATABASE" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PASSWORD" \
        --dbhost=mariadb:3306
fi

# Installer WordPress si pas encore installé
if ! wp core is-installed --allow-root 2>/dev/null; then
    echo "Installing WordPress..."
    wp core install --allow-root \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"

    # Créer un utilisateur supplémentaire (requis par le sujet)
    echo "Creating additional user..."
    wp user create --allow-root \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author

    echo "WordPress installation complete!"
fi

# Lancer PHP-FPM en mode foreground
echo "Starting PHP-FPM..."
exec php-fpm7.4 -F
