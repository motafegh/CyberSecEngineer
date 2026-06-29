# Session 0 — Lab Setup (WSL2-Optimized)

> **Roadmap ref:** `PHASE-0-LAB-SETUP.md`
> **Environment:** WSL2 Ubuntu 24.04 + Windows host
> **Topics:** Docker, lightweight Kali, web app labs

## Architecture

```
WSL2 (Ubuntu 24.04)
├── Docker Engine          → containers for DVWA, WebGoat, Juice Shop
├── Kali Linux (Docker)    → lightweight, no GUI needed

Windows Host
└── Kali Linux VM (VirtualBox)  ← for full GUI tools (Wireshark, Burp)
    └── Metasploitable 2 VM      ← vulnerable target
```

## What We'll Install

| Layer | Tool | Purpose |
|---|---|---|
| Container | Docker Engine | Run web app lab targets |
| Container | Kali Docker image | CLI attack tools from WSL2 |
| Host | Docker compose | Multi-container orchestration |
| Host (Windows) | VirtualBox + Kali OVA | Full attack VM for packet captures |

## Checklist

- [x] docker-compose.yml already exists in `building/labs/web-labs/`
- [ ] Install Docker Engine
- [ ] Start DVWA, WebGoat, Juice Shop containers
- [ ] Pull Kali Docker image for CLI access
- [ ] Verify all containers accessible from WSL2
- [ ] Take note of Windows-side VirtualBox plan
