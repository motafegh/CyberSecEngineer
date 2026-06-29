# Progress Tracker

> Master status across the current roadmap. Currently only Phase 1 is in flight; new phase trackers will be added as those phases are entered.
> Roadmap source of truth: `Roadmap/ROADMAP-INDEX.md`
> ✅ = Done | 🔄 = In Progress | ⏳ = Planned | ⏸️ = Postponed (with note)

---

## Module 1.1 — Linux and Operating System Security

| Topic | Status | Notes |
|---|---|---|
| Filesystem hierarchy (FHS) | ✅ | `01-linux-foundations-complete.md` |
| Users and groups | ✅ | `01-linux-foundations-complete.md` |
| File permissions (rwx, umask) | ✅ | `01-linux-foundations-complete.md` |
| SUID, SGID, sticky bit | ✅ | `02-suid-sgid-deep-dive.md` |
| Processes and signals (ps, top, kill) | ✅ | `03-processes-complete.md` |
| Environment variables | ⏳ | |
| Services and systemd | ⏳ | |
| Package management | ⏳ | |
| Shell scripting (bash) | ⏳ | Thin outline exists — `session-03-linux-bash-scripting.md` |
| Logs and audit trails (auth.log, journalctl) | ✅ | `01-linux-foundations-complete.md` |
| Trust-boundary note (user/kernel, root/user, user/user) | ⏳ | Exercise 1.1.8 |
| **Mini-project: System Auditor script** | ⏳ | Portfolio piece |

---

## Module 1.2 — Networking and Packet Analysis

| Topic | Status | Notes |
|---|---|---|
| OSI and TCP/IP models | ⏸️ | Needs Kali VM for captures |
| Ethernet, MAC, ARP | ⏳ | |
| IP addressing and subnetting | ⏳ | |
| TCP handshake/teardown, UDP | ⏳ | |
| DNS, DHCP | ⏳ | |
| HTTP/HTTPS, TLS handshake | ⏳ | |
| NAT, VLANs, segmentation | ⏳ | |
| **Mini-project: Go Network Mapper** | ⏳ | Introduces Go |

---

## Module 1.3 — Cryptography and Key Management

| Topic | Status | Notes |
|---|---|---|
| Encoding vs hashing vs encryption | ⏸️ | Background knowledge already strong |
| Symmetric/asymmetric encryption | ⏸️ | |
| Digital signatures, MACs | ⏳ | |
| Key derivation, password hashing | ⏳ | |
| PKI, certificate chains | ⏳ | |
| Randomness and entropy | ⏳ | |
| Key rotation and revocation | ⏳ | |
| **Mini-project: Crypto Misuse Checker** | ⏳ | Python or Rust |

---

## Module 1.4 — Python for Security Automation

| Topic | Status | Notes |
|---|---|---|
| Log parsing, HTTP requests, JSON | ⏸️ | Python skill already strong — skip basics |
| CLI tooling, safe subprocess handling | ⏳ | |
| **Mini-project: Security Evidence Collector** | ⏳ | Replaces old SecAudit CLI concept |

---

## Module 1.5 — Go for Networked and Distributed Services

| Topic | Status | Notes |
|---|---|---|
| Packages, modules, interfaces | ⏳ | New language — start from scratch |
| Error handling, goroutines, channels | ⏳ | |
| HTTP servers/clients, JSON APIs | ⏳ | |
| Structured logging, testing | ⏳ | |
| **Mini-project: Go Service Probe** | ⏳ | Probes HTTP services, outputs JSON |

---

## Module 1.6 — Rust for Secure Systems Programming

| Topic | Status | Notes |
|---|---|---|
| Ownership, borrowing, lifetimes | ⏳ | New language — start from scratch |
| Result/Option, pattern matching | ⏳ | |
| Traits, crates, testing | ⏳ | |
| Safe vs unsafe Rust, fuzzing intro | ⏳ | |
| **Mini-project: Rust Safe Config Parser** | ⏳ | Parsing with safety guarantees |

---

## Module 1.7 — Authentication, Authorization, and Identity Basics

| Topic | Status | Notes |
|---|---|---|
| AuthN vs AuthZ, sessions, cookies | ⏳ | |
| Tokens, JWTs, API keys | ⏳ | |
| Password storage, MFA | ⏳ | |
| Service accounts, least privilege, deny-by-default | ⏳ | |

---

## Module 1.8 — Threat Modeling Fundamentals

| Topic | Status | Notes |
|---|---|---|
| Assets, actors, entry points, trust boundaries | ⏳ | Thin outline exists — `session-05-threat-modeling.md` |
| STRIDE framework | ⏳ | |
| Attack trees, risk severity | ⏳ | |
| Controls, residual risk | ⏳ | |
| **Mini-project: Small System Threat Model** | ⏳ | With ADR |

---

## Phase 1 Capstone — Foundation Security Toolkit

| Deliverable | Status |
|---|---|
| Linux system auditor script | ⏳ |
| Go network mapper or service probe | ⏳ |
| Rust safe config parser | ⏳ |
| Python evidence collector or crypto misuse checker | ⏳ |
| Packet analysis report | ⏳ |
| Cryptography exercise report | ⏳ |
| Threat model for one small system | ⏳ |
| Architecture Decision Record (ADR) | ⏳ |
| Recall checklist and mistake log | ⏳ |

---

## Cross-Phase Status

| Phase | Status | Notes |
|---|---|---|
| Phase 0 — Secure Lab and Cyber Range | ⏳ | Lab setup notes in `learning/phases/phase-0-secure-lab/notes/`; not yet at exit criteria |
| Phase 1 — Deep Technical Foundations | 🔄 | Active; see module table below |
| Phase 2 — Core Security Engineering | ⏳ | Not started |
| Phase 3 — Distributed, Cloud, Zero Trust | ⏳ | Not started |
| Phase 4 — Blockchain and Web3 Security | ⏳ | Not started |
| Phase 5 — AI Security and AI-Driven Defense | ⏳ | Not started |
| Phase 6 — Principal Secure Architecture | ⏳ | Not started |

---

## Legend

| Symbol | Meaning |
|---|---|
| ✅ | Done — notes written, concept understood |
| 🔄 | In progress — currently working on this |
| ⏳ | Planned — scheduled for an upcoming session |
| ⏸️ | Postponed — intentionally skipped for now |
