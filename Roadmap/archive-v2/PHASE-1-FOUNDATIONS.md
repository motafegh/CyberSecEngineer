# Phase 1 — Foundations (Months 1–3)

> **The substrate everything else is built on. Rushing this creates gaps that cost you months later.**  
> **Prerequisites:** [PHASE-0-LAB-SETUP.md](PHASE-0-LAB-SETUP.md) complete  
> **Timeline:** ~10 weeks total  

---

## Table of Contents

- [1.1 Linux (~3 weeks)](#11-linux--3-weeks)
- [1.2 Networking (~3 weeks)](#12-networking--3-weeks)
- [1.3 Cryptography (~2 weeks)](#13-cryptography--2-weeks)
- [1.4 Python for Security (~2 weeks)](#14-python-for-security--2-weeks)
- [1.5 Threat Modeling (~1 week)](#15-threat-modeling--1-week)
- [Phase 1 Capstone — SecAudit CLI](#phase-1-capstone--secaudit-cli)
- [Phase 1 Exit Criteria](#phase-1-exit-criteria)

---

## 1.1 Linux (~3 weeks)

### Concepts

Filesystem hierarchy (FHS), users & groups, permission model (rwx, SUID, SGID, sticky bit), processes & signals, services & init systems (systemd), package management (apt/dpkg), environment variables, job scheduling (cron, at).

### Skills

Shell navigation, file manipulation, text processing, process control, user management, SSH key-based authentication, bash scripting, log reading (syslog, auth.log, journalctl).

### Tools

```
bash, grep, awk, sed, find, cut, sort, uniq, xargs,
ss, netstat, ps, systemctl, cron, vim, ssh, scp, chmod, chown
```

### Practice: OverTheWire

| Challenge | Levels | Skills Targeted | URL |
|---|---|---|---|
| **Bandit** | 0–34 | Core Linux: SSH, file ops, permissions, scripting | overthewire.org/wargames/bandit |
| **Leviathan** | 0–7 | Privilege escalation basics, reverse engineering | overthewire.org/wargames/leviathan |

> **Goal:** Complete all 34 Bandit levels, then start Leviathan.

### Mini Project — System Auditor Script

Write a bash script that automatically checks:

```bash
#!/bin/bash
# system-auditor.sh
# Checks to implement:

# 1. SUID/SGID binaries
find / -perm -4000 -o -perm -2000 2>/dev/null

# 2. World-writable files and directories
find / -writable -perm -002 2>/dev/null

# 3. Cron jobs for all users
for user in $(cut -f1 -d: /etc/passwd); do
    crontab -u $user -l 2>/dev/null
done
cat /etc/crontab /etc/cron.*/* 2>/dev/null

# 4. Open ports and listening services
ss -tulnp

# 5. Users with no password
awk -F: '($2 == "" || $2 == "x") {print $1}' /etc/shadow

# 6. Recently modified files in /etc
find /etc -mtime -7 -type f 2>/dev/null

# Output: structured report with timestamps and risk ratings
```

**Deliverable:** Working script + sample output on your Kali VM. Commit to GitHub.

---

## 1.2 Networking (~3 weeks)

### Concepts

| Layer | Name | Real Example | Attack Example |
|---|---|---|---|
| 7 | Application | HTTP, DNS, SSH | SQL injection |
| 6 | Presentation | TLS/SSL, encoding | POODLE, BEAST |
| 5 | Session | Cookies, session tokens | Session fixation |
| 4 | Transport | TCP, UDP | SYN flood, RST injection |
| 3 | Network | IP, ICMP, routing | IP spoofing, route hijack |
| 2 | Data Link | Ethernet, ARP, MAC | ARP poisoning |
| 1 | Physical | Cables, Wi-Fi signals | Evil twin AP |

Full coverage: TCP/IP stack, TCP 3-way handshake & 4-way teardown, UDP characteristics, IP addressing & subnetting, ARP & MAC addresses, DNS resolution chain (recursive + authoritative), DHCP DORA, HTTP/S request-response lifecycle, TLS handshake (full), NAT types, routing basics, VLAN concepts.

### Skills

- Reading and filtering packet captures
- Identifying protocols by behavior
- Spotting anomalies in traffic
- Tracing a request from browser to server at every layer

### Tools

```
Wireshark, tcpdump, nmap (basic), netcat, dig, nslookup,
curl, ping, traceroute, arp
```

### Practice

Capture and analyze **between your local VMs** (Kali ↔ Metasploitable 2):

1. **FTP session** — show cleartext credentials in Wireshark
2. **HTTP login form** — show POST body with plaintext password
3. **DNS query chain** — trace from client to recursive to authoritative
4. **TCP handshake** — SYN, SYN-ACK, ACK sequence numbers
5. **TLS negotiation** — ClientHello, ServerHello, certificate exchange

### Mini Project — Network Discovery Tool

Python script — **build the socket logic yourself, no nmap library**:

```python
# network_discovery.py
# Features to implement:
# 1. Host discovery on a subnet (ICMP ping sweep or TCP SYN)
# 2. TCP port scan on each live host (top 1000 ports)
# 3. Banner grabbing on open ports
# 4. Basic OS fingerprint from TTL and open ports
# 5. Structured JSON report output

# Socket pseudo-code:
import socket, struct, json, threading, ipaddress

def host_discovery(subnet):
    # ICMP echo request or TCP SYN to port 80/443
    pass

def port_scan(host, ports):
    # TCP connect scan using socket.connect()
    # Timeout-based, multi-threaded
    pass

def banner_grab(host, port):
    # socket.recv() after connect, decode with errors='ignore'
    pass

def generate_report(results):
    # JSON output with timestamp, hosts, ports, banners, risk notes
    pass
```

**Deliverable:** Working tool + scan results from your lab. Commit to GitHub.

---

## 1.3 Cryptography (~2 weeks)

### Concepts

**Symmetric encryption:** AES (modes: ECB flaw → why you see the penguin, CBC, GCM)

**Asymmetric encryption:** RSA (key pairs, why you can't reverse without the private key), ECDSA (secp256k1 — critical for Ethereum)

**Hashing vs Encryption vs Encoding:**
| Operation | Reversible? | Key? | Purpose |
|---|---|---|---|
| Encoding | Yes | No | Data representation (Base64, hex) |
| Encryption | Yes | Yes | Confidentiality |
| Hashing | No | No | Integrity verification |

**Password hashing:** bcrypt, scrypt, argon2 vs MD5/SHA1 (dangerous)

**Digital signatures & PKI:** Certificate chain, TLS internals, key derivation functions

**Attacks:** Rainbow tables, salting, collision resistance, length extension

### Skills

- Identifying weak cryptographic choices in applications
- Cracking weak hashes (MD5, SHA1)
- Reading TLS certificates with openssl
- Understanding why specific schemes break

### Tools

```
openssl, hashcat, john the ripper, CyberChef (local/self-hosted)
```

### Practice

| Platform | Focus | Account |
|---|---|---|
| **CryptoPals** | Hands-on crypto attacks | None |
| **CryptoHack** | Modern crypto challenges | Email only |

**Goal:** Complete CryptoPals Set 1 (Basics) and Set 2 (Block crypto). Start CryptoHack challenges.

### Mini Project — Password Audit Tool

```python
# password_audit.py
# Features:
# 1. Hash identification (MD5, SHA1, SHA256, bcrypt, etc.)
# 2. Wordlist + rule-based cracking with hashcat integration
# 3. Reused password detection across accounts
# 4. Weak algorithm flagging (MD5, SHA1 unsalted)
# 5. Risk-rated report (Critical/High/Medium/Low)
```

**Deliverable:** Working tool + test against known weak hashes. Commit to GitHub.

---

## 1.4 Python for Security (~2 weeks)

### Concepts

Socket programming, HTTP at the code level (without requests library first), subprocess control, binary data handling, regular expressions for extraction, file format parsing, threading and async for speed.

### Skills

- Write security tools from scratch rather than only using existing ones
- Automate manual processes
- Parse and extract from raw binary/text output
- Build modular CLI tools with argparse

### Libraries to Master

| Library | Use Case |
|---|---|
| `socket` | Raw TCP/UDP connections |
| `requests` | HTTP client operations |
| `scapy` | Packet crafting and sniffing |
| `subprocess` | Calling external tools |
| `re` | Pattern extraction from text |
| `threading` / `asyncio` | Parallel operations |
| `argparse` | CLI interface |
| `json` | Structured output |
| `hashlib` | Hash computation |
| `cryptography` | AES, RSA operations |
| `beautifulsoup4` | HTML parsing |
| `paramiko` | SSH client implementation |

### Mini Project — Recon Automation CLI

```python
# secaudit.py — modular CLI tool (this is the Phase 1 capstone foundation)
# Structure:
# secaudit/
# ├── secaudit.py          # main entry point with argparse
# ├── modules/
# │   ├── __init__.py
# │   ├── scanner.py       # port scan + banner grab
# │   ├── web.py           # directory enum + header audit
# │   ├── crypto.py        # hash identify + crack
# │   └── parser.py        # extract IPs/domains/hashes from logs
# ├── utils/
# │   └── output.py        # JSON + human-readable formatters
# └── requirements.txt

# Usage:
# python secaudit.py scan --target 192.168.56.0/24
# python secaudit.py web --url http://target
# python secaudit.py hash --file hashes.txt --wordlist rockyou.txt
# python secaudit.py parse --file access.log
```

**Deliverable:** Modular CLI with at least `scan` and `web` working. Each module outputs JSON.

---

## 1.5 Threat Modeling (~1 week)

### Concepts

- What threat modeling is and why it **precedes** any security work
- Assets vs threats vs vulnerabilities vs risks
- Attacker perspective vs defender perspective
- Attack surface definition
- Trust boundaries

### Frameworks

#### STRIDE
| Letter | Threat | Example |
|---|---|---|
| S | Spoofing | Fake login page |
| T | Tampering | Modify API request |
| R | Repudiation | Delete audit logs |
| I | Information Disclosure | SQLi exposing data |
| D | Denial of Service | Resource exhaustion |
| E | Elevation of Privilege | User → Admin |

#### PASTA
Process for Attack Simulation and Threat Analysis — 7-stage risk-centric methodology:
1. Define objectives
2. Define technical scope
3. Application decomposition (DFD)
4. Threat analysis
5. Vulnerability analysis
6. Attack enumeration
7. Risk & impact analysis

#### Attack Trees
Decompose an attack goal into sub-goals recursively. Root = attacker goal. Leaves = individual actions.

#### DREAD Scoring
| Factor | Question | Score 1–10 |
|---|---|---|
| Damage | How bad is the impact? | |
| Reproducibility | Can it be repeated reliably? | |
| Exploitability | How hard is the attack? | |
| Affected Users | How many users impacted? | |
| Discoverability | How easy to find? | |

**Score > 15 = High risk. Score > 25 = Critical.**

### Skills

- Draw data flow diagrams (DFD)
- Identify trust boundaries
- Enumerate threats per component using STRIDE
- Prioritize by risk using DREAD
- Propose controls per threat
- Write a threat model document

### Mini Project — Threat Model a Simple App

**Target:** A basic 3-tier web app (frontend → API → database)

**Deliverable:** Document containing:
1. Data flow diagram with trust boundaries
2. STRIDE applied to each component and data flow
3. Attack tree for "attacker steals user data"
4. DREAD scoring for each identified threat
5. One control per threat with implementation notes

> **This exact skill is tested in security engineering interviews.**

---

## Phase 1 Capstone — SecAudit CLI

### What It Is
A comprehensive Python security reconnaissance tool integrating everything from Phase 1.

### Features

| Module | Capability |
|---|---|
| **Network** | Host discovery, port scanning, banner grabbing, service fingerprinting |
| **Web** | HTTP header security audit, directory enumeration, SSL/TLS certificate inspection |
| **Credentials** | Hash identification and cracking, default credential check for common services |
| **Reports** | Structured JSON output + human-readable summary with risk ratings |

### Architecture

```
secaudit-cli/
├── secaudit.py              # CLI entry point
├── modules/
│   ├── network.py           # Host discovery, port scan, banner grab
│   ├── web.py               # Header audit, directory enum, TLS check
│   ├── crypto.py            # Hash ID, cracking attempt
│   └── reporter.py          # JSON + markdown report generation
├── utils/
│   ├── validators.py        # IP, URL, hash validation
│   └── formatters.py        # Output formatting
├── wordlists/
│   └── common-services.txt  # Default creds for common services
├── requirements.txt
└── README.md
```

### What It Demonstrates
- Python proficiency
- Networking understanding
- Security awareness
- Tool-building ability

### Where It Goes
GitHub, linked from your resume as **"built from scratch, no nmap dependency."**

---

## Phase 1 Exit Criteria

Before moving to Phase 2, you must complete **all** of the following:

- [ ] Completed OverTheWire Bandit all 34 levels
- [ ] Can explain every layer of the OSI model with a real attack example at each layer
- [ ] Can extract credentials from a captured FTP/HTTP session in Wireshark
- [ ] Can explain why MD5 password storage is dangerous with a specific attack (rainbow tables)
- [ ] Has produced a STRIDE threat model for a simple application (documented)
- [ ] SecAudit CLI published on GitHub with professional README
- [ ] System auditor script working on your Kali VM
- [ ] Network discovery tool tested against your lab subnet
- [ ] Password audit tool tested against weak hashes
- [ ] All notes committed to your notes repository

---

**Prerequisites:** [PHASE-0-LAB-SETUP.md](PHASE-0-LAB-SETUP.md)  
**Next → [PHASE-2-CORE-ATTACK-DEFENSE.md](PHASE-2-CORE-ATTACK-DEFENSE.md)**

---

*v2 — Local-first · Free · No KYC · No Subscriptions*
