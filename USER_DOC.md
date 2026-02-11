# User Documentation - Inception

## Services Overview

This stack provides a WordPress website accessible via HTTPS. It consists of three services:

| Service | Description |
|---------|-------------|
| **NGINX** | Web server and reverse proxy, handles HTTPS (port 443) |
| **WordPress** | Content management system with PHP-FPM |
| **MariaDB** | Database server storing WordPress data |

## Start and Stop

### Start the project

```bash
make
```

This command builds all Docker images and starts the containers in the background.

### Stop the project

```bash
make down
```

This stops all running containers without removing data.

### Full reset

```bash
make fclean
```

This stops containers, removes volumes, and cleans all Docker data.

## Accessing the Website

1. Ensure `enzuguem.42.fr` is configured in `/etc/hosts`:
   ```
   127.0.0.1 enzuguem.42.fr
   ```

2. Open a web browser and navigate to:
   - **Website**: https://enzuguem.42.fr
   - **Admin panel**: https://enzuguem.42.fr/wp-admin/

3. Accept the self-signed certificate warning in your browser.

## Credentials

Credentials are stored in the following locations:

| File | Content |
|------|---------|
| `srcs/.env` | Environment variables (database, WordPress config) |
| `secrets/credentials.txt` | WordPress user credentials |
| `secrets/db_password.txt` | Database user password |
| `secrets/db_root_password.txt` | Database root password |

### WordPress Users

| Role | Username | Description |
|------|----------|-------------|
| Administrator | See `srcs/.env` (`WP_ADMIN_USER`) | Full access to WordPress admin |
| Author | See `srcs/.env` (`WP_USER`) | Can write and publish posts |

To log in, go to https://enzuguem.42.fr/wp-admin/ and enter the credentials from the `.env` file.

## Checking Services Status

### Verify containers are running

```bash
cd srcs && docker compose ps
```

All three containers (nginx, wordpress, mariadb) should show status `Up`.

### View container logs

```bash
cd srcs && docker compose logs           # All services
cd srcs && docker compose logs nginx     # NGINX only
cd srcs && docker compose logs wordpress # WordPress only
cd srcs && docker compose logs mariadb   # MariaDB only
```

### Test HTTPS connectivity

```bash
curl -k https://enzuguem.42.fr
```

A successful response returns the WordPress HTML page.