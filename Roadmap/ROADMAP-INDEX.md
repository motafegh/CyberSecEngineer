# Cybersecurity Career Roadmap v2 — Master Index

> **Local-first · Free · No KYC · No Subscriptions**  
> **Background:** Intermediate — ML, Deep Learning, Solidity, AI/LLMs  
> **Target:** First AI/ML/LLM/Security role in 3–4 months  

---

## Your Starting Position

| Skill You Have | What It Unlocks |
|---|---|
| Solidity | Skip to smart contract vulnerability classes directly |
| ML / Deep Learning | Adversarial ML and AI red-teaming from month 7 |
| Python | No language barrier — only security libraries to learn |
| LLM knowledge | Prompt injection, jailbreak research, OWASP LLM Top 10 |
| SENTINEL project | Deployable portfolio piece from day one |

---

## Roadmap Overview

```
Phase 0   Weeks 1–2     Lab Setup
Phase 1   Months 1–3    Foundations
Phase 2   Months 3–7    Core Attack & Defense
Phase 3   Months 7–14   Specializations (4 parallel tracks)
Phase 4   Months 14–18  Portfolio & Job Hunt
```

---

## Phase Files

### Phase 0 — Lab Setup
**[PHASE-0-LAB-SETUP.md](PHASE-0-LAB-SETUP.md)**

- VirtualBox/QEMU + Kali Linux + target VMs
- Network architecture (NAT + Host-Only isolation)
- Windows Server 2019 + Windows 10 for AD track
- Docker for web app labs
- Obsidian + git-based note-taking system

---

### Phase 1 — Foundations
**[PHASE-1-FOUNDATIONS.md](PHASE-1-FOUNDATIONS.md)**

| Module | Duration | Topics |
|---|---|---|
| Linux | ~3 weeks | FHS, permissions, bash scripting, OverTheWire Bandit |
| Networking | ~3 weeks | OSI 7 layers, TCP/IP, Wireshark, packet analysis |
| Cryptography | ~2 weeks | AES/RSA, hashing, password cracking, TLS, CryptoPals |
| Python for Security | ~2 weeks | Socket programming, scapy, tool building from scratch |
| Threat Modeling | ~1 week | STRIDE, PASTA, attack trees, DREAD scoring |

**Capstone:** SecAudit CLI — comprehensive Python security reconnaissance tool

---

### Phase 2 — Core Attack & Defense
**[PHASE-2-CORE-ATTACK-DEFENSE.md](PHASE-2-CORE-ATTACK-DEFENSE.md)**

| Module | Duration | Topics |
|---|---|---|
| Web Application Security | ~4 weeks | OWASP Top 10, SQLi, XSS, IDOR, PortSwigger |
| API Security | ~2 weeks | REST/GraphQL/gRPC, BOLA/BFLA, OWASP API Top 10 |
| Network Penetration Testing | ~3 weeks | nmap deep, VulnHub machines, methodology |
| Exploitation Fundamentals | ~3 weeks | Metasploit, privesc, Linux paths, LOLBins |
| Binary Exploitation (Intro) | ~3 weeks | Stack overflow, mitigations, pwntools, pwn.college |
| Reverse Engineering (Intro) | ~2 weeks | Ghidra, assembly, crackmes, static analysis |
| Secure Code Review | ~2 weeks | Taint analysis, Semgrep, secret scanning, audit reports |
| Defensive Security / Blue Team | ~2 weeks | SIEM/Wazuh, detection rules, MITRE ATT&CK |

**Capstone:** Full penetration test report on a VulnHub machine

---

### Phase 3 — Specializations (4 Parallel Tracks)

| Day | Track | File |
|---|---|---|
| Monday | Track A — Web3 & Smart Contract Security | [PHASE-3-TRACK-A-WEB3.md](PHASE-3-TRACK-A-WEB3.md) |
| Tuesday | Track B — AI/ML Security | [PHASE-3-TRACK-B-AI-ML.md](PHASE-3-TRACK-B-AI-ML.md) |
| Wednesday | Track C — Cloud Security | [PHASE-3-TRACK-C-CLOUD.md](PHASE-3-TRACK-C-CLOUD.md) |
| Thursday | Track D — Windows & Active Directory | [PHASE-3-TRACK-D-WINDOWS-AD.md](PHASE-3-TRACK-D-WINDOWS-AD.md) |
| Friday | Competitive audit / CTF / write-ups | See capstones in each track file |
| Saturday | Deep work on whichever track has an active project | — |
| Sunday | Documentation, GitHub, review | — |

---

### Phase 4 — Portfolio & Job Hunt
**[PHASE-4-PORTFOLIO-JOB-HUNT.md](PHASE-4-PORTFOLIO-JOB-HUNT.md)**

- Portfolio requirements & required pieces
- Visibility strategy (no KYC)
- Target roles by fit
- Target employers for your profile
- Interview preparation by role (5 role types)

---

## Reference Files

| File | Contents |
|---|---|
| **[REFERENCE-TOOLS.md](REFERENCE-TOOLS.md)** | All tools organized by category — foundations, scanning, web/API attack, exploitation, post-exploitation, smart contract, AI/ML, cloud, secrets scanning, defense/monitoring |
| **[REFERENCE-RESOURCES.md](REFERENCE-RESOURCES.md)** | All free hands-on labs, references, and the 18-step priority order for when time is limited |

---

## AI Assistant

| File | Purpose |
|---|---|
| **[CUSTOM-INSTRUCTIONS.md](CUSTOM-INSTRUCTIONS.md)** | Optimized system prompt for your AI pair programmer, teacher, and mentor |

---

## File Dependency Map

```
ROADMAP-INDEX.md
├── PHASE-0-LAB-SETUP.md
│   └── (required by all other phase files)
├── PHASE-1-FOUNDATIONS.md
│   ├── REFERENCE-TOOLS.md
│   ├── REFERENCE-RESOURCES.md
│   └── (required by Phase 2)
├── PHASE-2-CORE-ATTACK-DEFENSE.md
│   ├── REFERENCE-TOOLS.md
│   ├── REFERENCE-RESOURCES.md
│   └── (required by all Phase 3 tracks)
├── PHASE-3-TRACK-A-WEB3.md ──┐
├── PHASE-3-TRACK-B-AI-ML.md ──┼── (all run in parallel)
├── PHASE-3-TRACK-C-CLOUD.md ──┤
├── PHASE-3-TRACK-D-WINDOWS-AD.md┘
│   └── REFERENCE-TOOLS.md, REFERENCE-RESOURCES.md
├── PHASE-4-PORTFOLIO-JOB-HUNT.md
│   └── (pulls from all previous phases)
├── REFERENCE-TOOLS.md
├── REFERENCE-RESOURCES.md
└── CUSTOM-INSTRUCTIONS.md
```

---

## Quick-Reference: Exit Criteria Summary

### Phase 1 Exit
- OverTheWire Bandit 34 levels complete
- Explain OSI 7 layers with real attack examples
- Extract credentials from FTP/HTTP captures in Wireshark
- Explain MD5 password storage dangers with specific attack
- Produce STRIDE threat model for a simple application
- SecAudit CLI published on GitHub

### Phase 2 Exit
- Rooted Metasploitable 2 via 3+ attack paths
- PortSwigger: all SQLi, Authentication, XSS, Access Control labs
- Deployed and exploited crAPI locally
- 3 binary exploitation CTFs with published write-ups
- 3 crackme binaries reversed with Ghidra
- Manual code review on open-source app with report
- 5 custom Wazuh detection rules written
- Phase 2 capstone pentest report published

### Phase 3 Exit
- Track A: 1 competitive audit submitted + 1 self-directed protocol audit + SENTINEL extended
- Track B: Adversarial attack on SENTINEL documented + LLM red team suite published + full AI red team report
- Track C: Cloud misconfiguration lab published + cloud assessment report
- Track D: Complete AD attack chain zero-to-DA documented + hardening report

### Phase 4 Exit
- GitHub: 12+ months of consistent commits, 6 pinned repos
- All required portfolio pieces published
- 2+ technical blog posts
- Applications sent to target employers

---

*v2 — Local-first · Free · No KYC · No Subscriptions*
