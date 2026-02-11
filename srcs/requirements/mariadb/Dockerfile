FROM debian:bullseye

# Installer MariaDB
RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Copier la configuration MariaDB
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copier le script d'initialisation
COPY tools/init-db.sh /usr/local/bin/init-db.sh
RUN chmod +x /usr/local/bin/init-db.sh

# Créer le répertoire pour le socket MySQL
RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

# Exposer le port MySQL
EXPOSE 3306

# Lancer le script d'initialisation
CMD ["/usr/local/bin/init-db.sh"]
