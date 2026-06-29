# Phase 1 — Plan: Deep Technical Foundations

> Roadmap source: `Roadmap/PHASE-1-DEEP-FOUNDATIONS.md`
> Status: see `learning/progress-tracker.md`
> Mistakes: `learning/mistakes/phase-1.md`
> Target role: Principal Secure Distributed Systems Architect
> Quality-gated, not timeline-gated

---

## Structure

Each session follows this pattern:
1. **Concept** — What we're learning and why it matters for architecture
2. **Hands-on** — Terminal, code, or lab
3. **Write-up** — Note into the relevant file
4. **Quiz** — Verify before advancing

---

## Completed Sessions

### Session 0 — Lab Setup
- Docker Kali lab, network isolation, snapshots
- File: `session-00-lab-setup.md`

### Session 1 — Linux Foundations
- FHS, permissions (rwx), users/groups, hidden files, logs
- Files: `01-linux-foundations-complete.md`, `01-session-1-linux-foundations.md`

### Session 2 — Linux Deep Dive
- SUID/SGID deep dive, processes/signals, cron
- Files: `02-suid-sgid-deep-dive.md`, `03-processes-complete.md`

---

## Upcoming Sessions

### Module 1.1 — Linux and Operating System Security (cont.)

#### Session 3 — Services, SSH, and Environment
| Topic | Security Relevance |
|---|---|
| systemd services (systemctl, unit files) | Misconfigured services = privilege escalation |
| SSH key auth (authorized_keys, keygen) | Weak/no key auth = unauthorized access |
| Environment variables | Secrets leaked in env = credential theft |

**Mini-task:** Inspect 3 running services, check unit files for writable paths.
**Exit:** You can audit service configs and SSH auth setup.

#### Session 4 — Shell Scripting → System Auditor
| Topic | Security Relevance |
|---|---|
| Variables, conditionals, loops | Automate security audits |
| Exit codes, error handling | Reliable tooling |
| find -exec, grep, awk in scripts | Parse logs, find anomalies |

**Mini-project:** Build the **System Auditor** script:
- SUID/SGID binaries, world-writable paths, listening ports
- Running services, recent failed logins, users UID 0
- Structured output (text sections + risk annotations)

**Exit:** Script runs on lab machine, produces structured report.

#### Session 5 — Trust-Boundary Note + Linux Wrap-up
**Exercise 1.1.8:** Write a one-page document identifying:
- User/kernel-mode boundary
- Root/non-root boundary
- Inter-process boundary (different users)
- Logs and controls that cross each boundary
- One attack path per boundary

**Exit:** Trust-boundary note saved, all Module 1.1 exit criteria met.

---

### Module 1.2 — Networking and Packet Analysis

#### Session 6 — Network Fundamentals
| Topic | Security Relevance |
|---|---|
| OSI model, TCP/IP stack | Understand where attacks live (layer 2, 3, 4, 7) |
| Ethernet, MAC, ARP | ARP spoofing = MITM |
| IP addressing, subnetting | Segmentation, CIDR for firewall rules |
| TCP handshake/teardown, UDP | Port scanning, SYN floods, UDP amplification |

**Hands-on:** Capture ARP exchange, TCP handshake with tcpdump/Wireshark.
**Exit:** You can trace a packet from client to server.

#### Session 7 — DNS, HTTP/HTTPS, TLS
| Topic | Security Relevance |
|---|---|
| DNS resolution, record types | DNS spoofing, tunneling |
| HTTP request/response, methods | Web attack surface |
| TLS handshake, ciphersuites | What TLS protects (and doesn't) |
| Certificates, chain validation | MITM via bad cert validation |

**Hands-on:** Capture DNS query, TLS ClientHello/ServerHello in Wireshark.
**Mini-project:** Build packet-filtering cheat sheet.
**Exit:** Packet captures saved and explained.

---

### Module 1.3 — Cryptography and Key Management

#### Session 8 — Crypto Primitives
| Topic | Security Relevance |
|---|---|
| Encoding vs hashing vs encryption | Common confusion → misused crypto |
| Symmetric (AES) vs asymmetric (RSA, ECC) | Key management complexity |
| Digital signatures, HMAC | Non-repudiation, integrity |
| Password hashing (bcrypt, argon2) | Why fast hashes fail for passwords |

**Hands-on:** Encode/decode base64, hash files, encrypt/decrypt with OpenSSL.
**Exit:** You can explain the difference between each primitive.

#### Session 9 — PKI, Certificates, Key Management
| Topic | Security Relevance |
|---|---|
| PKI, CAs, certificate chains | Trust anchors — compromise = total loss |
| TLS certificate inspection | Expired/misissued certs = risk signal |
| Key generation, rotation, revocation | Hardcoded keys = instant breach |
| Randomness and entropy | Weak RNG = predictable keys |

**Hands-on:** Generate key pair, sign/verify message, inspect TLS cert chain.
**Exit:** Key lifecycle can be explained from memory.

#### Session 10 — Crypto Misuse Checker
**Mini-project:** Build a Python or Rust tool scanning configs/code for:
- Hardcoded private keys
- Weak hash usage (MD5, SHA1 for passwords)
- Disabled TLS verification
- Insecure random usage
- Plaintext secrets
- Risk-rated findings

**Exit:** Tool works on sample test files.

---

### Module 1.4 — Python for Security Automation

#### Session 11 — Security Evidence Collector
| Topic | Security Relevance |
|---|---|
| Log parsing (structured output) | Extract IOC's from logs |
| HTTP requests, JSON APIs | Interact with security tools |
| Safe subprocess handling | RCE via shell injection |
| Structured reporting (JSON) | Machine-parseable evidence |

**Mini-project:** Build **Security Evidence Collector** that gathers:
- System info, open ports, recent logs
- File hashes (SHA256 for integrity)
- JSON report with redacted secrets

**Exit:** Tool works with README and sample output.

---

### Module 1.5 — Go for Networked and Distributed Services

#### Session 12 — Go Fundamentals
| Topic | Security Relevance |
|---|---|
| Packages, modules, toolchain | Build reliable security tools |
| Types, structs, interfaces | Type-safe API design |
| Error handling (no exceptions) | Predictable failure handling |
| Testing (go test) | Verify security behavior |

**Hands-on:** Write a TCP echo server, HTTP health-check endpoint.
**Exit:** Working Go service with tests.

#### Session 13 — Concurrency and Go Service Probe
| Topic | Security Relevance |
|---|---|
| Goroutines and channels | Concurrent port scanning |
| Context and cancellation | Timeouts prevent resource exhaustion |
| HTTP clients with timeouts | Slowloris, DoS resilience |
| Structured logging | Audit trail |

**Mini-project:** Build **Go Service Probe** that:
- Reads targets from a file
- Probes HTTP services (status, headers, TLS cert info, latency)
- Handles timeouts gracefully
- Outputs JSON

**Exit:** Probe works on lab targets, timeout behavior documented.

---

### Module 1.6 — Rust for Secure Systems Programming

#### Session 14 — Rust Fundamentals
| Topic | Security Relevance |
|---|---|
| Ownership, borrowing, lifetimes | Memory safety without GC |
| Result and Option | No null, no unchecked errors |
| Pattern matching | Exhaustive handling of all cases |
| Modules and crates | Dependency management |

**Hands-on:** Ownership examples, parse structured input safely.
**Exit:** Memory safety concepts explained from memory.

#### Session 15 — Safe Parsing and the Config Parser
| Topic | Security Relevance |
|---|---|
| Error handling (panic vs Result) | No crash on malformed input |
| Traits and generics | Reusable, testable parsers |
| Property-based testing | Find edge cases automatically |
| Safe vs unsafe | What unsafe Rust means for code review |

**Mini-project:** Build **Rust Safe Config Parser** that:
- Accepts valid input, rejects malformed
- Tests for edge cases (empty, huge, special chars)
- Documents security assumptions

**Exit:** Parser works, malformed input tests exist.

---

### Module 1.7 — Authentication, Authorization, and Identity Basics

#### Session 16 — AuthN/AuthZ Deep Dive
| Topic | Security Relevance |
|---|---|
| Authentication vs authorization | Confusing them = security holes |
| Sessions and cookies | Session hijacking, fixation |
| JWTs (structure, signing, verification) | JWT none-algorithm attack |
| API keys vs tokens | Leaked keys in URLs/git |
| Password storage (bcrypt, argon2) | Storing plaintext = instant breach |
| MFA, service accounts, least privilege | Defense in depth |

**Hands-on:** Decode JWT, identify cookie attributes, write authorization matrix.
**Exit:** Authorization matrix exists, session/token exercises documented.

---

### Module 1.8 — Threat Modeling Fundamentals

#### Session 17 — STRIDE and Attack Trees
| Topic | Security Relevance |
|---|---|
| Assets, actors, entry points | Systematic threat identification |
| Trust boundaries | Where controls must go |
| STRIDE per element | Spoofing, Tampering, Repudiation, Info Disclosure, DoS, EoP |
| Attack trees | Visualize attack paths |

**Hands-on:** Threat model a login system and a small API.
**Exit:** STRIDE table for at least one system.

#### Session 18 — Threat Model Mini-Project
Pick a small service from this phase (or the SimpleStorage contract) and produce:
- System diagram with trust boundaries
- Asset inventory
- STRIDE table per trust boundary
- Top risks with severity
- Controls mapped to threats
- Residual risk statements
- One Architecture Decision Record (ADR)

**Exit:** Complete threat model package + ADR on GitHub.

---

### Capstone Integration

#### Session 19 — Foundation Security Toolkit
- Combine all mini-projects into one repo
- Verify each tool works (system auditor, Go probe, Rust parser, Python collector, threat model)
- Write README explaining the toolkit
- Publish on GitHub

**Exit:** Toolkit repo live, all exit criteria met.

---

## Material From Old Structure (Not in v3)

| Old Topic | Disposition |
|---|---|
| OverTheWire Bandit 0-34 | Optional practice — do if we need Linux reps |
| SecAudit CLI (old capstone) | Superseded by per-module mini-projects |
| FTP/HTTP credential extraction in Wireshark | Part of Module 1.2 |
| MD5 danger with rainbow tables | Part of Module 1.3 |
| Network discovery tool | Superseded by Go Network Mapper |
