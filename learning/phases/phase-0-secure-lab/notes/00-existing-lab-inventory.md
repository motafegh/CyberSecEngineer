# Existing Lab Environment Inventory

> **Date:** 2026-06-29
> **Purpose:** Document what already exists in the lab environment before making changes.
> **Session:** Session 1–2 (discovered during Session 1 review)

---

## Overview

Before building anything new, we audited what Docker resources and lab files already existed. This document records that inventory.

---

## Docker Images (Pre-Pulled)

All of these were already downloaded and available:

| Image | Size | Purpose | Origin |
|---|---|---|---|
| `kalilinux/kali-rolling:latest` | 120MB | Base Kali Linux image (no tools pre-installed) | Docker Hub official |
| `kali-tools:latest` | 774MB | Kali with security tools pre-installed (built locally) | Built from `Dockerfile.kali-tools` |
| `vulnerables/web-dvwa:latest` | 712MB | Damn Vulnerable Web Application (PHP/MySQL) | Docker Hub |
| `webgoat/webgoat:latest` | 601MB | OWASP WebGoat — intentionally vulnerable web app | Docker Hub |
| `bkimminich/juice-shop:latest` | 338MB | OWASP Juice Shop — modern Node.js vulnerable web app | Docker Hub |
| `alpine:latest` | 8.44MB | Minimal Linux for quick tests | Docker Hub |
| `postgres:16-alpine` | 276MB | PostgreSQL database | Docker Hub |
| `nginx:latest` | 152MB | Nginx web server | Docker Hub |
| `redis:7-alpine` | 41.4MB | Redis in-memory store | Docker Hub |
| `mythril/myth:latest` | 716MB | Mythril smart contract security analyzer | Docker Hub |
| `slither-analyzer:latest` | 425MB | Slither Solidity static analyzer | Docker Hub |
| `zkcli-in-memory-node-zksync:latest` | 226MB | zkSync development node | Docker Hub |
| `ollama/ollama:latest` | 3.96GB | Local LLM runtime | Docker Hub |
| `prom/prometheus:latest` | 378MB | Prometheus monitoring | Docker Hub |
| `grafana/grafana:latest` | 746MB | Grafana dashboards | Docker Hub |
| `chainguardian-api:latest` | 1.86GB | (unknown — likely a project image) | Local |
| Various `persianlllm-api` images | ~11GB each | Persian LLM API (project image) | ghcr.io / local |

### Key Observations

1. **Kali base image is already downloaded** — no need to pull it again
2. **`kali-tools` image is pre-built** from an existing Dockerfile with nmap, nikto, gobuster, sqlmap, hydra, john — but no metasploit and runs as root
3. **Three vulnerable web targets are already pulled** — DVWA, WebGoat, Juice Shop
4. Several unrelated project images exist (LLM APIs, smart contract tools, monitoring) — not part of the CyberSecEngineer lab

---

## Existing Lab Files

### `building/labs/Dockerfile.kali-tools`

```dockerfile
FROM kalilinux/kali-rolling

RUN apt update && apt install -y \
    nmap \
    netcat-openbsd \
    nikto \
    gobuster \
    sqlmap \
    hydra \
    john \
    curl \
    wget \
    iproute2 \
    dnsutils \
    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
```

**Analysis:**
- ✅ Good tool selection for initial recon and exploitation
- ❌ Runs as **root** — no non-root `analyst` user
- ❌ Missing: metasploit-framework, dirb
- ✅ Already built into image `kali-tools:latest` (774MB)

### `building/labs/web-labs/docker-compose.yml`

```yaml
services:
  dvwa:
    image: vulnerables/web-dvwa
    ports:
      - "8080:80"
    environment:
      - MYSQL_PASS=password

  webgoat:
    image: webgoat/webgoat
    ports:
      - "8081:8080"

  juice-shop:
    image: bkimminich/juice-shop
    ports:
      - "8082:3000"
```

**Analysis:**
- ❌ All targets exposed on **host ports** (`localhost:8080/8081/8082`) — violates isolation
- ❌ Default **bridge network** — not isolated, targets have internet access
- ❌ No shared internal network for Kali to reach them
- ❌ DVWA password hardcoded as `password` in plain text
- ✅ Target images already pulled — no download needed

---

## Docker Networks (Current)

| Network | Driver | Scope | Purpose |
|---|---|---|---|
| `bridge` (default) | bridge | local | Default — containers get internet via NAT |
| `host` | host | local | Container uses host's network stack |
| `none` | null | local | No network at all |

**No custom networks exist yet** — `lab-net-internal` and `lab-net-nat` were created and deleted during the isolation testing session.

---

## Docker Containers (Current)

No containers are running. Clean slate.

---

## Security Issues Identified

| Issue | Severity | Location |
|---|---|---|
| Targets exposed to host via port mapping | High | `web-labs/docker-compose.yml` |
| Kali image runs as root | Medium | `Dockerfile.kali-tools` — no `USER` directive |
| Hardcoded password in compose file | Low | `web-labs/docker-compose.yml` — lab-only password |
| No isolation between target and internet | High | Targets on `bridge` network by default, not `--internal` |

---

## What We Have vs What We Need

| Need | Current State | Action Needed |
|---|---|---|
| Attack workstation with tools | ✅ `kali-tools` image exists (774MB) | Add `analyst` user, optionally add metasploit |
| Vulnerable web target | ✅ DVWA image pulled | Redploy on `--internal` network, no host ports |
| Additional web targets | ✅ WebGoat, Juice Shop pulled | Same — deploy on internal network |
| Vulnerable Linux target | ❌ Not pulled yet | Need Metasploitable or similar Docker image |
| Isolated network | ❌ `lab-net-internal` was deleted | Recreate when needed |
| Target inventory document | ❌ Not created | Create during Session 2 |

---

## Summary

The environment has all the big images pre-downloaded (Kali, DVWA, WebGoat, Juice Shop). The main work is reconfiguring the deployment to use **isolated internal networks** instead of exposing targets to the host. The pre-built `kali-tools` image is usable but needs a non-root user and potentially more tools.
