# Session 2 — Phase 0, Module 0.3–0.4: Kali Workstation & Vulnerable Targets

> **Roadmap ref:** `PHASE-0-SECURE-LAB.md` §10–11 (Modules 0.3 + 0.4)
> **Date:** 2026-06-29
> **Status:** [x] Done (Session 2a — Kali workstation only. Targets deferred to Session 3)

---

## Session Goals

- [ ] Set up Kali Linux as the attack workstation inside Docker
- [ ] Install essential security tools (nmap, curl, nikto, msf, etc.)
- [ ] Deploy a vulnerable web target (DVWA) on an isolated network
- [ ] Deploy a vulnerable Linux target (multi-service container) on an isolated network
- [ ] Verify the attack workstation can reach targets
- [ ] Verify targets CANNOT reach the internet or the host
- [ ] Write a target inventory with purpose and risk

---

## Chunk 1: Kali Linux Attack Workstation

### What We'll Learn

| Concept | Security Relevance |
|---|---|
| Kali Linux in Docker | Lightweight attack workstation that can be destroyed and recreated |
| Dockerfile to build a customized Kali image | Reproducible attack environment |
| Kali tools installation | Only install what you need — smaller image, less attack surface |
| User management inside Kali | Don't work as root inside the container either |

### What We'll Build

A Dockerfile that creates a Kali container with:
- Non-root user
- Core security tools (nmap, curl, msf, nikto, gobuster, dirb, hydra, john)
- Directory structure for reports and evidence
- Bash aliases for common tasks

```bash
# building/labs/compose/kali/Dockerfile
FROM kalilinux/kali-rolling

RUN apt update && apt install -y \
    # Network scanning and recon
    nmap \
    netcat-openbsd \
    curl \
    wget \
    # Web application testing
    dirb \
    gobuster \
    nikto \
    # Exploitation frameworks
    metasploit-framework \
    # Password attacks
    hydra \
    john \
    # Utilities
    iproute2 \
    dnsutils \
    iputils-ping \
    && apt clean

RUN useradd -m -s /bin/bash analyst && \
    echo "analyst:analyst" | chpasswd

USER analyst
WORKDIR /home/analyst

RUN mkdir -p reports evidence tools

CMD ["/bin/bash"]
```

### Key Takeaway

A containerized Kali means you can destroy it, rebuild it, and start fresh instantly. No leftover files, no configuration drift.

---

## Chunk 2: Vulnerable Targets

### What We'll Learn

| Concept | Security Relevance |
|---|---|
| DVWA (Damn Vulnerable Web Application) | PHP/MySQL web app with every major vuln (SQLi, XSS, RCE, file upload) |
| Metasploitable-like container | Multi-service Linux target (FTP, SSH, SMB, HTTP) |
| Isolated deployment | Target has NO internet access — cannot phone home |
| Docker Compose | Define and run multi-container environments reproducibly |

### Targets We'll Deploy

**Target 1 — DVWA (Web):**
- Container: `vulnerables/web-dvwa`
- Network: `lab-net-internal` (no internet)
- Ports: 80 (Apache), 3306 (MySQL) — only accessible from Kali on the same network

**Target 2 — Metasploitable-like (Linux):**
- Container: `tleemcjr/metasploitable2`
- Network: `lab-net-internal` (no internet)
- Ports: 21 (FTP), 22 (SSH), 23 (Telnet), 25 (SMTP), 80 (HTTP), 445 (SMB), etc.

---

## Chunk 3: Verification

### What We'll Verify

| Test | Expected Result | Command |
|---|---|---|
| Kali can reach internet | ✅ Yes | `curl -I https://google.com` |
| Kali can reach DVWA | ✅ Yes | `curl -I http://dvwa` |
| Kali can reach Metasploitable | ✅ Yes | `nmap -sn metasploitable` |
| DVWA can reach internet | ❌ No | `ping 8.8.8.8` from inside DVWA |
| Metasploitable can reach internet | ❌ No | `ping 8.8.8.8` from inside |
| Host can reach targets | ❌ No | Targets are on isolated network, host not attached |
| Targets can reach each other | ✅ Yes | They're on the same internal network |

### What We'll Produce

A connectivity matrix document (`building/labs/CONNECTIVITY-MATRIX.md`) that maps every allowed and denied path.

---

## Quiz — Chunk 1 (Kali)

1. Why build Kali as a Docker image with a Dockerfile instead of installing tools interactively?
2. What's the advantage of having a non-root user inside the Kali container?
3. You run `docker build -t my-kali .` and it fails. Where do you start debugging?

## Quiz — Chunk 2 (Targets)

4. DVWA runs on `lab-net-internal`. You're on your WSL2 host. Can you open `http://dvwa/` in your browser? Why or why not?
5. The Metasploitable container has port 23 (Telnet) open — a known vulnerable service. What's the risk of this being on a NAT network instead of `--internal`?

## Quiz — Chunk 3 (Verification)

6. You run `ping 8.8.8.8` from inside the Metasploitable container and it succeeds. What's broken and how do you fix it?
7. After the session, you need to preserve evidence. What do you save?

---

## What We'll Produce by End of Session

| Artifact | Location |
|---|---|
| Kali Dockerfile | `building/labs/compose/kali/Dockerfile` |
| Docker Compose for lab | `building/labs/compose/docker-compose.yml` |
| Target inventory | `building/labs/TARGET-INVENTORY.md` |
| Connectivity matrix | `building/labs/CONNECTIVITY-MATRIX.md` |
| Sample evidence | `building/labs/evidence/*` |
| Learning note | `notes/02-kali-and-targets.md` |
| Evidence file | `evidence/2026-06-29-session-2-target-deployment.txt` |

---

## Next Session

**Session 3 — Phase 0, Module 0.5–0.6:** Telemetry and evidence pipeline, documentation system, Architecture Decision Record, lab threat model.
