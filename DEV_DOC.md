# Developer Documentation - Inception

## Environment Setup from Scratch

### Prerequisites

- Docker Engine (with Docker Compose plugin)
- Git
- A Debian-based system (tested on Debian 11 Bullseye VM)

### Install Docker

```bash
su -
apt-get update
apt-get install -y ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
usermod -aG docker enzuguem
reboot
```

### Configure hostname

```bash
echo "127.0.0.1 enzuguem.42.fr" | sudo tee -a /etc/hosts
```

### Configuration Files

| File | Purpose |
|------|---------|
| `srcs/.env` | Environment variables for all services |
| `srcs/docker-compose.yml` | Service orchestration |
| `secrets/` | Sensitive credentials (not committed to git) |

### Secrets Setup

Create the following files in the `secrets/` directory:

- `credentials.txt` - WordPress admin and user credentials
- `db_password.txt` - MariaDB user password
- `db_root_password.txt` - MariaDB root password

## Build and Launch

### Using Makefile

```bash
make        # Build images and start containers
make down   # Stop containers
make clean  # Stop containers and remove volumes
make fclean # Full cleanup (remove all Docker data)
make re     # Rebuild from scratch
```

### Direct Docker Compose commands

```bash
cd srcs
docker compose up -d --build   # Build and start
docker compose down            # Stop
docker compose down -v         # Stop and remove volumes
docker compose logs -f         # Follow logs
```

## Container Management

### Access a container shell

```bash
docker exec -it nginx /bin/bash
docker exec -it wordpress /bin/bash
docker exec -it mariadb /bin/bash
```

### Restart a specific service

```bash
cd srcs && docker compose restart nginx
cd srcs && docker compose restart wordpress
cd srcs && docker compose restart mariadb
```

### Check container health

```bash
cd srcs && docker compose ps
docker inspect --format='{{.State.Status}}' nginx wordpress mariadb
```

## Volume Management

### Data storage locations

| Volume | Host Path | Container Path |
|--------|-----------|----------------|
| wordpress | `/home/enzuguem/data/wordpress` | `/var/www/html` |
| mariadb | `/home/enzuguem/data/mariadb` | `/var/lib/mysql` |

### Data persistence

Data persists across container restarts and rebuilds. Volumes are only removed when running:

```bash
make clean   # Removes named volumes
make fclean  # Removes all Docker data including volumes
```

### Inspect volumes

```bash
docker volume ls
docker volume inspect srcs_wordpress
docker volume inspect srcs_mariadb
```

### Verify data on host

```bash
ls -la /home/enzuguem/data/wordpress/  # WordPress files
ls -la /home/enzuguem/data/mariadb/    # MariaDB database files
```

## Architecture

```
Internet (HTTPS:443)
       |
    [NGINX] ---- SSL/TLS termination
       |
       | FastCGI :9000
       |
  [WordPress + PHP-FPM]
       |
       | MySQL :3306
       |
   [MariaDB]
```

All containers communicate through the `inception` Docker bridge network. Only NGINX exposes port 443 to the host.