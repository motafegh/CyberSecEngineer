# Session 002 — Phase 1: Foundations (Theory & Concepts)

**Date:** 2026-06-25  
**Mentor:** Perplexity AI (Security Architecture Mentor)  
**Student:** Ali (ML Engineer & Solidity Dev)  
**Session Type:** Theory & Conceptual Learning (No Lab Access)  
**Constraint:** No laptop — no hands-on lab work this session  

---

## Roadmap Reference

- 📌 **[PHASE-1-DEEP-FOUNDATIONS.md](../../Roadmap/PHASE-1-DEEP-FOUNDATIONS.md)** — Active phase file (the older session plan referenced `PHASE-1-FOUNDATIONS.md`; the v3 file is `PHASE-1-DEEP-FOUNDATIONS.md`)
- 📌 **[ROADMAP-INDEX.md](../../Roadmap/ROADMAP-INDEX.md)** — Master index
- 🔗 **Previous session:** [SESSION-001.md](SESSION-001.md)

**Current Phase:** Phase 1 — Foundations (Months 1–3, ~10 weeks total)

---

## Session Goals

> These goals are achievable with zero lab access — pure theory, mental models, and conceptual depth.

- [ ] Deeply understand the Linux security permission model (SUID, SGID, sticky bit)
- [ ] Map all 7 OSI layers to real attack examples — from memory
- [ ] Understand hashing vs encryption vs encoding — and why it matters for security
- [ ] Understand STRIDE threat modeling framework end-to-end
- [ ] Understand the TCP/IP 3-way handshake and why it matters for attacks
- [ ] Connect existing ML/Solidity knowledge to upcoming security modules

---

## What We Will Cover

### Module 1.1 — Linux Security Model (Theory)

No terminal needed — these are mental models to internalize:

| Concept | What to Understand |
|---|---|
| FHS (Filesystem Hierarchy) | Why `/etc`, `/var`, `/tmp`, `/proc` matter to attackers |
| Permission bits (rwx) | Octal notation, user/group/other, what each means |
| SUID bit | Why a binary owned by root + SUID = privesc vector |
| SGID bit | Directory vs file behavior differences |
| Sticky bit | Why `/tmp` needs it, what happens without it |
| `/etc/passwd` vs `/etc/shadow` | History, what each stores, why shadow was created |
| Processes & signals | SIGKILL vs SIGTERM, why signals matter in exploitation |
| Cron & persistence | How attackers use cron jobs for persistence |

**Exit check for this module:**  
Can you answer: *"You find a binary with SUID set owned by root. What is the attacker’s opportunity and why?"*

---

### Module 1.2 — Networking & OSI (Theory)

Memorise this table — it comes up in every interview and every CTF:

| Layer | Name | Real Protocol | Attack Example |
|---|---|---|---|
| 7 | Application | HTTP, DNS, SSH, SMTP | SQL injection, directory traversal |
| 6 | Presentation | TLS/SSL, encoding | POODLE (SSLv3 downgrade), BEAST |
| 5 | Session | Cookies, session tokens | Session fixation, session hijacking |
| 4 | Transport | TCP, UDP | SYN flood, RST injection, port scanning |
| 3 | Network | IP, ICMP, routing | IP spoofing, BGP hijacking |
| 2 | Data Link | Ethernet, ARP, MAC | ARP poisoning (MITM) |
| 1 | Physical | Cables, Wi-Fi, signals | Evil twin AP, signal jamming |

**Key flows to understand conceptually (no Wireshark needed yet):**
- TCP 3-way handshake: `SYN → SYN-ACK → ACK` and why SYN floods work
- DNS resolution chain: browser → OS cache → recursive resolver → authoritative — and why DNS poisoning targets the cache
- TLS handshake: what ClientHello/ServerHello actually negotiate, why certificate pinning exists
- Why HTTP is dangerous at Layer 5 (session tokens in cleartext)

**Exit check:** Describe a man-in-the-middle attack at the ARP layer — which OSI layers are affected and how?

---

### Module 1.3 — Cryptography (Concepts)

**The most important table in security:**

| Operation | Reversible? | Key Needed? | Example | Security Goal |
|---|---|---|---|---|
| Encoding | ✅ Yes | ❌ No | Base64, hex, URL-encode | Representation only |
| Encryption | ✅ Yes | ✅ Yes | AES-GCM, RSA | Confidentiality |
| Hashing | ❌ No | ❌ No | SHA-256, bcrypt | Integrity |
| HMAC | ❌ No | ✅ Yes | HMAC-SHA256 | Integrity + Authentication |

**Key concepts to internalize this session:**
- **Why MD5/SHA1 are dangerous for passwords** — rainbow tables, speed of GPU cracking
- **Why bcrypt/argon2 are safe** — cost factor, salting, slow by design
- **AES-ECB flaw** — identical plaintext blocks = identical ciphertext blocks (the penguin diagram)
- **Why ECDSA on secp256k1 matters to you** — this is the same curve Ethereum uses for wallet signatures
- **TLS certificate chain** — Root CA → Intermediate CA → Leaf cert; what a MITM attack breaks
- **Key derivation functions (KDF)** — PBKDF2, bcrypt, scrypt, argon2 and why password storage != encryption

**Your Solidity shortcut:** You already understand private/public key pairs from Ethereum. ECDSA + secp256k1 in the crypto module is the same math underpinning `msg.sender`.

**Exit check:** Explain why storing passwords as `MD5(password)` is catastrophically insecure in 3 sentences.

---

### Module 1.5 — Threat Modeling (Theory-first, high value)

This module requires no lab — it is pure thinking and documentation. It is also **directly tested in security engineering interviews**.

#### STRIDE Framework

| Letter | Threat Category | Question to Ask | Example |
|---|---|---|---|
| **S** | Spoofing | Can an attacker pretend to be someone else? | Fake login page, ARP spoofing |
| **T** | Tampering | Can data be modified in transit or at rest? | Modify API request body, corrupt DB records |
| **R** | Repudiation | Can an actor deny they performed an action? | Delete audit logs, no logging at all |
| **I** | Information Disclosure | Can sensitive data leak unintentionally? | SQLi exposing rows, verbose error messages |
| **D** | Denial of Service | Can the system be made unavailable? | SYN flood, memory exhaustion |
| **E** | Elevation of Privilege | Can an attacker gain more access than allowed? | SUID abuse, JWT `alg:none` trick |

#### DREAD Scoring (use to prioritise)

| Factor | Question | Score 1–10 |
|---|---|---|
| **D** amage | How bad is the worst-case impact? | |
| **R** eproducibility | Can it be reliably repeated? | |
| **E** xploitability | How much skill/effort to exploit? (invert: easy=high score) | |
| **A** ffected Users | How many users/systems impacted? | |
| **D** iscoverability | How easy to find this vulnerability? | |

> Score ≥ 25 = Critical. Score ≥ 15 = High.

#### Mental exercise for this session:

Apply STRIDE to a simple **3-tier web app** (no diagram needed yet, just think through it):
```
User Browser  →  [Trust Boundary]  →  Web API  →  [Trust Boundary]  →  Database
```
For each arrow and each component, ask all 6 STRIDE questions. This is exactly what you’ll build as a formal deliverable when back on the laptop.

---

## How Your Background Connects

| Your Existing Skill | Phase 1 Connection | Why It Helps |
|---|---|---|
| Solidity & EVM | Cryptography module (ECDSA, secp256k1, keccak256) | You already use these daily |
| Python | Python for Security module (1.4) | No language barrier at all |
| ML / Deep Learning | Threat Modeling (data pipelines as attack surfaces) | Model poisoning starts here |
| LLM knowledge | STRIDE applied to LLM systems | Prompt injection = Elevation of Privilege |

---

## What Gets Built (Lab Sessions - Future)

These require a laptop — planned for upcoming lab sessions:

| Build | Module | Language |
|---|---|---|
| System Auditor Script | 1.1 Linux | bash |
| Network Discovery Tool | 1.2 Networking | Python (raw sockets) |
| Password Audit Tool | 1.3 Cryptography | Python + hashcat |
| SecAudit CLI (Capstone) | 1.4 Python for Security | Python modular CLI |
| Threat Model Document | 1.5 Threat Modeling | Markdown |

---

## Session Agenda (Today — No Laptop)

1. **Linux permission model deep dive** — SUID/SGID/sticky bit attack implications
2. **OSI layers × attacks table** — memorise all 7 with attack examples
3. **Crypto mental models** — hashing vs encryption vs encoding, password storage
4. **STRIDE walkthrough** — apply to a real example together
5. **TCP/IP & DNS flows** — understand without Wireshark
6. **Q&A** — anything unclear becomes a future lab target

---

## Phase 1 Exit Criteria (Checklist)

- [ ] OverTheWire Bandit: all 34 levels complete
- [ ] Can explain all 7 OSI layers with a real attack at each layer
- [ ] Can extract creds from FTP/HTTP capture in Wireshark
- [ ] Can explain MD5 password storage risk with specific attack vector
- [ ] STRIDE threat model document produced for a simple app
- [ ] SecAudit CLI published on GitHub with professional README
- [ ] System auditor bash script working on Kali VM
- [ ] Network discovery tool tested on lab subnet
- [ ] Password audit tool tested against weak hashes
- [ ] All notes committed to notes repository

---

## Notes

> Add your own notes, key insights, and questions here during/after the session.

---

*Local-first · Free · No KYC · No Subscriptions*
