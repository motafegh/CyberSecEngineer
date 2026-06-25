# Lab Architecture Overview

## What We Are Building

A safe, isolated cybersecurity practice lab. This is where you'll learn to hack without accidentally hacking yourself.

## The Three Layers

### Layer 1 — Kali Linux (Attack Machine)
Your primary weapon. Kali comes with 600+ pre-installed security tools:
- **nmap** — network scanning
- **Metasploit** — exploit framework
- **Burp Suite** — web proxy for intercepting/modifying HTTP requests
- **Wireshark** — packet sniffing and analysis
- **Ghidra** — reverse engineering
- **John/Hashcat** — password cracking

Kali has **two network adapters**:
1. **NAT** — reaches the internet (for updates, downloading tools)
2. **Host-Only** — reaches lab target VMs (for attacking)

### Layer 2 — Target VMs (Things You Attack)
Intentionally vulnerable machines:

| VM | Purpose |
|---|---|
| Metasploitable 2 | Beginner Linux target — default creds, known vulns |
| Metasploitable 3 | Modern Linux target with real-world vulnerabilities |
| Windows Server 2019 | Active Directory domain controller |
| Windows 10 | Domain-joined client machine |

These VMs have **one network adapter**: Host-Only only. They cannot reach the internet or your real network.

### Layer 3 — Docker Containers (Web App Targets)
Lightweight vulnerable web applications:

| App | Technology | Teaches | Difficulty |
|---|---|---|---|
| DVWA | PHP/MySQL | SQLi, XSS, File Upload, Command Injection | Beginner |
| WebGoat | Java/Spring | OWASP Top 10 guided lessons | Beginner |
| Juice Shop | Node.js | 100+ modern web app challenges | Intermediate |

These run inside WSL2 and are accessed via localhost.

## The Full Picture

```
Your Windows PC
├── WSL2 (Ubuntu)
│   ├── Docker containers → localhost:8080-8082
│   └── Python tools (pwntools, scapy, semgrep)
│
└── VirtualBox
    ├── Kali Linux (attack machine) → NAT + Host-Only
    ├── Metasploitable 2 → Host-Only only
    ├── Metasploitable 3 → Host-Only only
    ├── Windows Server DC → Host-Only only
    └── Windows 10 → Host-Only only
```

## Why This Architecture

- **Safety**: Target VMs cannot escape to your real network
- **Reproducibility**: Snapshots let you reset after every attack
- **Separation of concerns**: WSL2 handles lightweight dev tools, VirtualBox handles full VMs

## Key Principle

> If you can hack your own lab, you have proof you can do it for real.
> If your lab gets hacked, nothing bad happens.
