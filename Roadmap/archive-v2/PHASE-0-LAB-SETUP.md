# Phase 0 — Lab Setup (Weeks 1–2)

> **Prerequisites:** None  
> **Output:** Fully isolated virtual lab environment + note-taking system  
> **Everything here is free. No accounts with KYC required.**

---

## Table of Contents

- [What to Install](#what-to-install)
- [Network Architecture](#network-architecture-to-build)
- [VM Setup Guide](#vm-setup-guide)
- [Docker Lab Environment](#docker-lab-environment)
- [What to Understand](#what-to-understand)
- [Note-Taking System](#note-taking-system)
- [Checklist](#checklist)

---

## What to Install

### Virtualization Layer (pick one)

| Option | Best For | Where to Get |
|---|---|---|
| **VirtualBox** | Beginners, easiest setup | virtualbox.org (free) |
| **QEMU/KVM** | Linux hosts, better performance | distro package manager |

> **Recommendation:** Start with VirtualBox. Migration to QEMU/KVM is straightforward later.

---

### Required Virtual Machines

| VM | Purpose | Source | Account Needed |
|---|---|---|---|
| **Kali Linux** | Primary attack machine | kali.org (VirtualBox OVA) | None |
| **Metasploitable 2** | Vulnerable Linux target | vulnhub.com | None |
| **Metasploitable 3** | Modern vulnerable target | vulnhub.com / GitHub | None |
| **Windows Server 2019 Evaluation** | AD domain controller | Microsoft eval center | Free email |
| **Windows 10 Evaluation** | AD client machine | Microsoft eval center | Free email |

#### Download Links

- **Kali Linux OVA:** https://www.kali.org/get-kali/#kali-virtual-machines
- **Metasploitable 2:** https://www.vulnhub.com/entry/metasploitable-2,29/
- **Metasploitable 3:** https://github.com/rapid7/metasploitable3
- **Windows Server 2019 Eval:** https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2019
- **Windows 10 Eval:** https://www.microsoft.com/en-us/evalcenter/evaluate-windows-10-enterprise

---

### Docker (required)

Used for web application labs (DVWA, WebGoat, Juice Shop, crAPI, etc.)

```bash
# Ubuntu/Debian
sudo apt update && sudo apt install docker.io docker-compose

# Or use official Docker repo: https://docs.docker.com/engine/install/
```

---

## Network Architecture to Build

```
Host Machine
├── Kali Linux        → NAT (internet) + Host-Only (lab)
├── Metasploitable 2  → Host-Only only
├── Metasploitable 3  → Host-Only only
├── Windows Server    → Host-Only only
├── Windows 10        → Host-Only only
└── Docker containers → Bridge to host-only via docker network
```

### Why This Architecture

| Adapter Type | Purpose | Risk |
|---|---|---|
| **NAT** | Kali reaches internet for updates, downloads | — |
| **Host-Only** | Lab VMs talk to each other and Kali only | Isolated from your real network |
| **No Bridged** | Prevents attack VMs from reaching your LAN | Eliminates accidental lateral movement |

### VirtualBox Network Setup Steps

1. **Create Host-Only adapter:**
   ```
   File → Host Network Manager → Create
   vboxnet0: 192.168.56.1/24, DHCP enabled
   ```

2. **Kali Network config:**
   ```
   Adapter 1: NAT (for internet)
   Adapter 2: Host-Only Adapter (vboxnet0 — for lab)
   ```

3. **Target VMs config (all):**
   ```
   Adapter 1: Host-Only Adapter (vboxnet0)
   No other adapters
   ```

4. **Verify connectivity:**
   ```bash
   # From Kali
   ping 192.168.56.x   # should reach target VMs
   ping 8.8.8.8        # should reach internet via NAT
   ```

---

## VM Setup Guide

### Kali Linux

1. Import the OVA into VirtualBox
2. Start Kali, update immediately:
   ```bash
   sudo apt update && sudo apt full-upgrade -y
   ```
3. Install essential tools not included:
   ```bash
   sudo apt install ghidra ghidra-data   # if not present
   pip3 install pwntools requests scapy beautifulsoup4
   ```
4. **Snapshot:** Name it "Fresh Install — Phase 0"

### Metasploitable 2

1. Download the VM files
2. Set network to Host-Only (vboxnet0)
3. Start — login is `msfadmin:msfadmin`
4. Check IP: `ifconfig` — should be in 192.168.56.0/24
5. **Snapshot:** Name it "Fresh"

### Metasploitable 3

1. Follow build instructions at the GitHub repo
2. Requires Vagrant + VirtualBox provider
3. Or use the pre-built VM image if available
4. Set network to Host-Only (vboxnet0)
5. **Snapshot:** Name it "Fresh"

### Windows Server 2019 (Domain Controller)

1. Install from ISO in VirtualBox
2. Set network to Host-Only (vboxnet0)
3. Configure static IP: `192.168.56.10`
4. Set hostname: `DC01`
5. **Install Active Directory Domain Services:**
   ```powershell
   # Server Manager → Manage → Add Roles
   # Select: Active Directory Domain Services
   # Promote to DC: Create new forest
   # Domain: lab.local
   ```
6. Create domain users (see Track D file for detailed AD setup)
7. **Snapshot:** Name it "DC — Fresh Domain"

### Windows 10 (Domain Client)

1. Install from ISO in VirtualBox
2. Set network to Host-Only (vboxnet0)
3. Join domain: `lab.local`
4. **Snapshot:** Name it "Domain Joined"

---

## Docker Lab Environment

```yaml
# docker-compose.yml for web security labs
# Save in ~/labs/web-labs/

version: '3'
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

  crapi:
    image: crapi/crapi-all
    ports:
      - "8083:8080"
      - "8443:8443"
```

```bash
# Start all labs
cd ~/labs/web-labs && docker-compose up -d

# Verify
docker ps
```

---

## What to Understand

### Why Isolation Matters

| Scenario | Without Isolation | With Host-Only Network |
|---|---|---|
| Metasploitable has default creds | Attacker on your LAN can reach it | Only Kali can reach it |
| Malware during RE analysis | Could beacon to internet | No outbound route |
| Accidental DHCP conflict | Breaks home network | Isolated vboxnet0 only |

### Networking Concepts to Master (before Phase 1)

| Concept | What It Means | Where Used |
|---|---|---|
| **NAT** | VM shares host IP for outbound | Kali internet access |
| **Host-Only** | VMs on a private virtual switch | All lab traffic |
| **Bridged** | VM gets IP from your router LAN | **Not used — too risky** |
| **Snapshots** | Frozen VM state you can revert to | Before every attack |

### Snapshot Discipline (Critical)

```
BEFORE any attack:    Take snapshot → "Pre-Attack [name]"
AFTER attack done:    Restore snapshot → clean state
BEFORE any config:    Take snapshot → "Pre-Config [change]"
```

This habit prevents configuration drift and ensures reproducible attacks.

---

## Note-Taking System

**Tool:** Obsidian (local, free) **or** plain markdown files in a git repo

### Directory Structure

```
security-notes/
├── phases/
│   ├── phase-0-lab-setup/
│   ├── phase-1-foundations/
│   ├── phase-2-core-attack-defense/
│   ├── phase-3-track-a-web3/
│   ├── phase-3-track-b-ai-ml/
│   ├── phase-3-track-c-cloud/
│   ├── phase-3-track-d-windows-ad/
│   └── phase-4-portfolio/
├── ctf-writeups/
│   ├── vulnhub/
│   ├── picoctf/
│   ├── pwn.college/
│   └── ethernaut/
├── tools/
│   └── cheatsheets/
│       ├── nmap.md
│       ├── wireshark.md
│       ├── metasploit.md
│       ├── burp-suite.md
│       ├── foundry.md
│       ├── ghidra.md
│       └── ...
├── vulnerability-research/
│   ├── findings/
│   └── reports/
└── portfolio/
    ├── resume.md
    ├── project-readmes/
    └── blog-posts/
```

### Note-Taking Rules

1. **Every command you learn** → goes in the relevant cheatsheet
2. **Every finding** → goes in vulnerability-research/findings/
3. **Every CTF/lab** → gets a dated write-up in ctf-writeups/
4. **Weekly** → git commit all notes with a descriptive message
5. **Every tool discovered** → add to your personal tool reference

---

## Checklist

- [ ] VirtualBox or QEMU/KVM installed and working
- [ ] Kali Linux imported, updated, snapshotted
- [ ] Metasploitable 2 imported, snapshotted
- [ ] Metasploitable 3 imported, snapshotted
- [ ] Windows Server 2019 installed as DC, snapshotted
- [ ] Windows 10 joined to domain, snapshotted
- [ ] Docker installed, docker-compose available
- [ ] Host-only network (vboxnet0) configured
- [ ] Kali can ping all VMs and reach internet
- [ ] Target VMs are isolated (cannot reach internet or host LAN)
- [ ] Note-taking directory created with full structure
- [ ] Git repo initialized for notes
- [ ] First commit pushed

---

**Next → [PHASE-1-FOUNDATIONS.md](PHASE-1-FOUNDATIONS.md)**

---

*v2 — Local-first · Free · No KYC · No Subscriptions*
