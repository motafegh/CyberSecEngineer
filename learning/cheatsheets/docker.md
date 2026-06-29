# Docker & Docker Compose Cheatsheet

## Core Commands

```bash
# List running containers
docker ps

# List ALL containers (including stopped)
docker ps -a

# List downloaded images
docker images

# Pull an image
docker pull <image-name>

# Run a container
docker run <image-name>

# Run container in background
docker run -d <image-name>

# Run container with port mapping
docker run -p 8080:80 <image-name>

# Stop a container
docker stop <container-id>

# Remove a container
docker rm <container-id>

# Remove an image
docker rmi <image-name>

# View logs of a container
docker logs <container-id>

# Follow logs (live)
docker logs -f <container-id>

# Execute a command inside running container
docker exec -it <container-id> bash

# Remove unused containers, images, networks
docker system prune
```

## Docker Compose Commands

```bash
# Pull all images defined in compose file
docker compose pull

# Start all services in background
docker compose up -d

# Stop all services
docker compose down

# View logs of all services
docker compose logs

# View logs of specific service
docker compose logs <service-name>

# Restart a specific service
docker compose restart <service-name>

# Rebuild and start (after changing compose file)
docker compose up -d --build

# List running services
docker compose ps
```

## Common Patterns

### Port Mapping Syntax
```
"host-port:container-port"
```

Examples:
- `"8080:80"` → localhost:8080 reaches container port 80
- `"8082:3000"` → localhost:8082 reaches container port 3000

### Running Containers in Background
Always use `-d` (detach) to avoid blocking your terminal:
```bash
docker compose up -d
```

### Checking If a Container Is Healthy
```bash
docker ps
# Look at STATUS column — should say "Up" not "Exited"
```

## Our Current Setup

| Service | Image | Port | URL |
|---|---|---|---|
| dvwa | vulnerables/web-dvwa | 8080:80 | http://localhost:8080 |
| webgoat | webgoat/webgoat | 8081:8080 | http://localhost:8081/WebGoat |
| juice-shop | bkimminich/juice-shop | 8082:3000 | http://localhost:8082 |

All defined in: `~/projects/CyberSecEngineer/labs/web-labs/docker-compose.yml`
