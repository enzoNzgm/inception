FROM debian:bullseye

# Mettre à jour et installer nginx
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Créer le répertoire pour les certificats SSL
RUN mkdir -p /etc/nginx/ssl

# Générer un certificat SSL auto-signé
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=enzuguem.42.fr/UID=enzuguem"

# Copier la configuration nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Exposer le port 443
EXPOSE 443

# Lancer nginx en mode foreground
CMD ["nginx", "-g", "daemon off;"]
