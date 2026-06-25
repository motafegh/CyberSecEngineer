# Docker Setup for Web App Labs

## What Is Docker?

A tool that runs applications in isolated containers. Each container bundles the app + its dependencies (libraries, configs, etc.) so it runs identically everywhere.

**Docker vs Virtual Machines:**
| | Docker Container | Virtual Machine |
|---|---|---|
| Boot time | Seconds | Minutes |
| Size | MB | GB |
| Isolation | Shares host OS kernel | Full OS per VM |
| Use case | Lightweight apps | Full operating systems |

## Why Docker for Security Labs?

Instead of manually installing Apache, PHP, MySQL, and a web app configuration (which takes 30+ minutes and varies per OS), we define the setup in a YAML file and run one command. Docker handles the rest.

## Our Docker Compose File

Located at: `CyberSecEngineer/labs/web-labs/docker-compose.yml`

```yaml
services:
  dvwa:
    image: vulnerables/web-dvwa
    ports:
      - "8080:80"

  webgoat:
    image: webgoat/webgoat
    ports:
      - "8081:8080"

  juice-shop:
    image: bkimminich/juice-shop
    ports:
      - "8082:3000"
```

### What Each App Teaches

| App | Port | Technology | Difficulty | What You'll Learn |
|---|---|---|---|---|
| DVWA | 8080 | PHP + MySQL | Beginner | SQL injection, XSS, file upload, command injection |
| WebGoat | 8081 | Java (Spring) | Beginner | OWASP Top 10 with guided exercises |
| Juice Shop | 8082 | Node.js | Intermediate | 100+ challenges, API abuse, modern web flaws |

### Breakdown of the Compose File

- **`services:`** — Defines each containerized app
- **`image:`** — The pre-built Docker image pulled from Docker Hub
- **`ports:`** — Maps host port to container port (`"host:container"`)

Example: `"8080:80"` means visit `http://localhost:8080` to reach the app's port 80 inside the container.

## Problem We Encountered

The original `docker-compose.yml` from the roadmap included:

```yaml
  crapi:
    image: crapi/crapi-all
    ports:
      - "8083:8080"
```

**crAPI** (Completely Ridiculous API) is an OWASP API security training app. The old automated Docker image (`crapi/crapi-all`) was removed from Docker Hub. We removed it from the compose file because you won't need API security training until later phases, and the setup method may change by then.

## Commands Reference

```bash
# Pull images (download them)
docker compose pull

# Start all containers in background
docker compose up -d

# View running containers
docker ps

# Stop all containers
docker compose down

# View logs of a specific container
docker compose logs <service-name>
# Example: docker compose logs webgoat

# Restart a single service
docker compose restart <service-name>
```

## Verification

After running `docker compose up -d`, visit:

| App | URL |
|---|---|
| DVWA | http://localhost:8080 |
| WebGoat | http://localhost:8081/WebGoat |
| Juice Shop | http://localhost:8082 |

All three are currently running and accessible.
