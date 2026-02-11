*This project has been created as part of the 42 curriculum by enzuguem.*

# Inception

## Description

Inception is a system administration project that uses Docker to set up a small infrastructure composed of three services: NGINX, WordPress (with PHP-FPM), and MariaDB. Each service runs in its own dedicated container, built from Debian Bullseye, and communicates through a Docker bridge network.

The project demonstrates containerization concepts, secure service configuration, and infrastructure orchestration using Docker Compose.

### Design Choices

- **Base image**: Debian Bullseye (penultimate stable version) for all containers
- **TLS**: Self-signed certificate with TLSv1.2 and TLSv1.3 only
- **PHP-FPM**: Listens on TCP port 9000, proxied by NGINX via FastCGI
- **Data persistence**: Docker named volumes stored in `/home/enzuguem/data/`

### Virtual Machines vs Docker

| Aspect | Virtual Machine | Docker |
|--------|----------------|--------|
| Isolation | Full OS-level isolation | Process-level isolation sharing host kernel |
| Resource usage | Heavy (full OS per VM) | Lightweight (shares host kernel) |
| Startup time | Minutes | Seconds |
| Portability | Less portable (large images) | Highly portable (small images) |
| Use case | Full OS environments | Microservices and application deployment |

### Secrets vs Environment Variables

| Aspect | Secrets | Environment Variables |
|--------|---------|----------------------|
| Storage | Encrypted at rest, mounted as files | Plain text in memory |
| Access | Limited to authorized services | Available to all processes in container |
| Security | Higher (temporary filesystem) | Lower (visible in inspect/logs) |
| Use case | Passwords, API keys, certificates | Non-sensitive configuration |

### Docker Network vs Host Network

| Aspect | Docker Network (bridge) | Host Network |
|--------|------------------------|--------------|
| Isolation | Containers isolated from host | No network isolation |
| Port mapping | Explicit port mapping required | Uses host ports directly |
| Security | Better (controlled exposure) | Less secure (all ports exposed) |
| Performance | Slight overhead | Native performance |

### Docker Volumes vs Bind Mounts

| Aspect | Docker Volumes | Bind Mounts |
|--------|---------------|-------------|
| Management | Managed by Docker | Direct host path |
| Portability | More portable | Host-dependent |
| Permissions | Docker handles permissions | Depends on host filesystem |
| Backup | Via Docker CLI | Direct file access |
| Use in Inception | Named volumes with local driver | Not allowed by subject |

## Instructions

### Prerequisites

- Docker and Docker Compose installed
- Domain `enzuguem.42.fr` pointing to `127.0.0.1` in `/etc/hosts`

### Installation and Execution

```bash
# Add domain to hosts file
echo "127.0.0.1 enzuguem.42.fr" | sudo tee -a /etc/hosts

# Build and start the infrastructure
make

# Stop the infrastructure
make down

# Stop and remove volumes
make clean

# Full cleanup (remove all Docker data)
make fclean

# Rebuild from scratch
make re
```

### Access

- Website: https://enzuguem.42.fr
- Admin panel: https://enzuguem.42.fr/wp-admin/

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress CLI Documentation](https://developer.wordpress.org/cli/commands/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [Debian Wiki](https://wiki.debian.org/)

### AI Usage

AI tools were used for:
- Debugging Docker configuration issues (volume permissions, network setup)
- Understanding Docker Compose syntax and best practices
- Generating documentation structure

All AI-generated content was reviewed, tested, and adapted to fit the specific project requirements.