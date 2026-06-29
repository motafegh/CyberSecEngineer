# Phase 1 — Deep Technical Foundations

> Purpose: Build the technical substrate for secure distributed systems architecture: operating systems, networking, cryptography, programming, identity basics, threat modeling, and documentation discipline.

---

## 1. Phase Goal

This phase makes later security architecture possible. Do not rush it. The final role may say blockchain, Artificial Intelligence, and Zero Trust, but those domains depend on basic mechanisms: files, processes, packets, keys, memory, authentication, authorization, logs, and code.

**AI — Artificial Intelligence:** software systems that perform tasks normally requiring human reasoning, perception, or decision-making.

**Zero Trust:** a security model where no user, device, network, or workload is trusted by default; access is continuously verified.

---

## 2. Prerequisites

- [ ] Phase 0 secure lab exists or is actively being built.
- [ ] Lab notes and evidence directories exist.
- [ ] At least one Linux workstation is available.
- [ ] Basic snapshot/rebuild workflow is tested.

---

## 3. Outcomes

By the end of this phase, you should be able to:

- [ ] Explain operating system trust boundaries.
- [ ] Use Linux confidently for security work.
- [ ] Trace network traffic at packet level.
- [ ] Explain core cryptographic primitives and common misuse.
- [ ] Build small tools in Python, Go, and Rust.
- [ ] Understand memory safety at a practical level.
- [ ] Explain authentication and authorization basics.
- [ ] Produce a threat model for a small service.
- [ ] Produce diagrams and Architecture Decision Records.
- [ ] Recall core mechanisms without notes.

**ADR — Architecture Decision Record:** a short document explaining a design decision, options considered, tradeoffs, and final rationale.

---

## 4. Module 1.1 — Linux and Operating System Security

### Why This Matters

Every later lab touches operating systems. Linux also powers servers, containers, blockchain nodes, security tooling, and many AI workloads.

### Mechanism

An operating system controls processes, users, permissions, files, devices, networking, memory, logs, and services. Security failures often happen when permissions, process boundaries, or service configurations are wrong.

### Core Concepts

- Filesystem hierarchy
- Users and groups
- File permissions
- Special permissions: SUID, SGID, sticky bit
- Processes and signals
- Environment variables
- Services and systemd
- Package management
- Shell scripting
- Logs and audit trails

### Hands-On Exercises

- [ ] Navigate and map the Linux filesystem hierarchy.
- [ ] Create users, groups, and files with different permissions.
- [ ] Demonstrate read/write/execute permission failures.
- [ ] Find SUID and SGID binaries in a lab system.
- [ ] Start, stop, enable, and inspect a systemd service.
- [ ] Read authentication and system logs.
- [ ] Write a shell script that inventories users, groups, open ports, and services.
- [ ] Break a permission setting in a lab file, then fix it.
- [ ] Write a one-page Linux trust-boundary note.

### Attack Surface

- Overprivileged users
- Weak file permissions
- SUID/SGID abuse
- Writable service files
- Leaked secrets in environment variables
- Insecure cron jobs
- Poor log visibility

### Defensive Controls

- Least privilege users
- Correct file ownership
- Service hardening
- Sudo policy review
- Secret hygiene
- Log review
- Patch management

### Detection and Telemetry

- `/var/log/auth.log`
- `/var/log/syslog`
- `journalctl`
- process listings
- service status
- file integrity checks

### Mini Project — Linux System Auditor

Build a script that reports:

- [ ] Users and groups
- [ ] Sudo-capable users
- [ ] SUID/SGID files
- [ ] World-writable paths
- [ ] Listening ports
- [ ] Running services
- [ ] Recent authentication failures
- [ ] Risk summary

### Recall Checks

- Why is SUID dangerous?
- What is the difference between user, group, and other permissions?
- How does systemd change the attack surface?
- Which logs help investigate failed login attempts?

### Exit Criteria

- [ ] Linux auditor works on a lab machine.
- [ ] Permission exercises are documented.
- [ ] Linux logs can be explained from memory.

---

## 5. Module 1.2 — Networking and Packet Analysis

### Why This Matters

Distributed systems fail and get attacked across networks. Blockchain nodes, Kubernetes services, APIs, identity providers, and AI services all communicate over networks.

### Mechanism

Networking moves data between systems through layers: link, network, transport, and application. Security depends on understanding addressing, routing, sessions, encryption, and protocol behavior.

### Core Concepts

- OSI and TCP/IP models
- Ethernet and MAC addresses
- ARP
- IP addressing and subnetting
- Routing
- TCP handshake and teardown
- UDP
- DNS
- DHCP
- HTTP and HTTPS
- TLS handshake
- NAT
- VLANs and segmentation

**TLS — Transport Layer Security:** the protocol that protects most HTTPS traffic by authenticating servers and encrypting data in transit.

### Hands-On Exercises

- [ ] Draw the path of a request from client to server.
- [ ] Capture an ARP exchange.
- [ ] Capture a DNS query and response.
- [ ] Capture a TCP three-way handshake.
- [ ] Capture a TLS ClientHello and ServerHello.
- [ ] Compare TCP and UDP behavior.
- [ ] Build a small packet-filtering cheat sheet.
- [ ] Misconfigure a route in a lab and debug the failure.
- [ ] Document one packet capture as evidence.

### Attack Surface

- Cleartext protocols
- DNS spoofing
- ARP spoofing
- Weak segmentation
- Exposed services
- Metadata endpoints
- Misconfigured firewalls

### Defensive Controls

- Encryption in transit
- Network segmentation
- Firewall rules
- DNS hardening
- Service exposure review
- Packet capture during incidents

### Detection and Telemetry

- Packet captures
- Firewall logs
- DNS logs
- Web server access logs
- Flow logs

### Mini Project — Go Network Mapper

Build a Go tool that:

- [ ] Accepts a lab subnet.
- [ ] Identifies live hosts.
- [ ] Checks selected TCP ports.
- [ ] Captures simple service banners.
- [ ] Outputs JSON.
- [ ] Includes clear limitations.

### Recall Checks

- What happens in a TCP three-way handshake?
- Why does DNS create security risk?
- What does TLS protect and not protect?
- Why is segmentation important for Zero Trust?

### Exit Criteria

- [ ] Packet captures are saved and explained.
- [ ] Go network mapper works in the lab.
- [ ] Network trust boundaries are diagrammed.

---

## 6. Module 1.3 — Cryptography and Key Management

### Why This Matters

Cryptography protects identity, blockchain transactions, TLS, passwords, secrets, signatures, tokens, and software supply chains. Misuse is common and severe.

### Mechanism

Cryptography uses mathematical primitives to provide confidentiality, integrity, authenticity, and non-repudiation. Architecture depends on correct primitive choice and secure key handling.

### Core Concepts

- Encoding vs hashing vs encryption
- Symmetric encryption
- Asymmetric encryption
- Digital signatures
- Message authentication codes
- Key derivation
- Password hashing
- Public Key Infrastructure
- Certificate chains
- Randomness and entropy
- Key rotation and revocation

**PKI — Public Key Infrastructure:** a system of certificates, certificate authorities, and trust chains used to bind public keys to identities.

### Hands-On Exercises

- [ ] Encode and decode data with Base64 and hex.
- [ ] Hash files and verify integrity.
- [ ] Compare fast hashes with password hashes.
- [ ] Encrypt and decrypt a file with a symmetric key.
- [ ] Generate an asymmetric key pair.
- [ ] Sign and verify a message.
- [ ] Inspect a TLS certificate chain.
- [ ] Demonstrate why hardcoded keys are dangerous.
- [ ] Write a key lifecycle diagram.

### Attack Surface

- Weak password hashing
- Hardcoded keys
- Reused keys
- Poor randomness
- Expired or misissued certificates
- Missing certificate validation
- Private key leakage

### Defensive Controls

- Strong password hashing
- Key separation by purpose
- Secret management
- Certificate validation
- Rotation and revocation plans
- Hardware-backed keys where appropriate

### Detection and Telemetry

- Certificate transparency logs
- Secret scanning
- Key usage logs
- Failed certificate validation events
- Unexpected signature failures

### Mini Project — Crypto Misuse Checker

Build a Python or Rust tool that scans sample config/code files for:

- [ ] Hardcoded private keys
- [ ] Weak hash usage
- [ ] Disabled TLS verification
- [ ] Insecure random number usage
- [ ] Plaintext secrets
- [ ] Risk-rated findings

### Recall Checks

- What is the difference between hashing and encryption?
- Why is password hashing different from file hashing?
- What does a digital signature prove?
- What happens if a private key leaks?

### Exit Criteria

- [ ] Crypto exercises are documented.
- [ ] Crypto misuse checker works on test files.
- [ ] Key lifecycle can be explained from memory.

---

## 7. Module 1.4 — Python for Security Automation

### Why This Matters

Python is ideal for fast security tooling, log parsing, exploit proof-of-concepts in labs, AI workflows, and orchestration scripts.

### Mechanism

Python lets you quickly interact with files, sockets, APIs, JSON, logs, subprocesses, and security tools.

### Hands-On Exercises

- [ ] Parse a log file and extract suspicious events.
- [ ] Make HTTP requests and inspect headers.
- [ ] Build a small command-line tool.
- [ ] Read and write JSON reports.
- [ ] Use sockets to connect to a lab service.
- [ ] Handle errors safely.
- [ ] Add tests for one utility function.

### Security Focus

- Input validation
- Safe subprocess handling
- Dependency management
- Secrets in environment variables
- Logging without leaking sensitive data

### Mini Project — Security Evidence Collector

Build a Python tool that collects:

- [ ] System info
- [ ] Open ports
- [ ] Recent logs
- [ ] Hashes of selected files
- [ ] JSON report output
- [ ] Redaction for sensitive values

### Recall Checks

- Why is unsafe subprocess usage dangerous?
- Why should tools output structured data?
- How can logs accidentally leak secrets?

### Exit Criteria

- [ ] Python evidence collector works.
- [ ] Tool has README and sample output.

---

## 8. Module 1.5 — Go for Networked and Distributed Services

### Why This Matters

Go is widely used in cloud-native infrastructure, Kubernetes tooling, distributed services, blockchain clients, and security tooling.

### Mechanism

Go provides simple concurrency, strong standard networking libraries, static binaries, and practical systems programming ergonomics.

### Core Concepts

- Packages and modules
- Interfaces
- Error handling
- Goroutines
- Channels
- Context cancellation
- HTTP servers and clients
- JSON APIs
- Structured logging
- Testing

### Hands-On Exercises

- [ ] Write a TCP echo server.
- [ ] Write an HTTP health-check endpoint.
- [ ] Add structured logs.
- [ ] Add graceful shutdown.
- [ ] Add request timeout handling.
- [ ] Use goroutines safely.
- [ ] Write tests for one handler.
- [ ] Simulate a slow client and observe behavior.

### Security Focus

- Timeouts
- Input limits
- Error handling
- Safe logging
- Dependency review
- Race conditions

### Mini Project — Go Service Probe

Build a Go tool that:

- [ ] Reads targets from a file.
- [ ] Probes HTTP services.
- [ ] Records status, headers, TLS certificate info, and latency.
- [ ] Handles timeouts.
- [ ] Outputs JSON.

### Recall Checks

- Why are timeouts security-relevant?
- How can concurrency create bugs?
- Why is Go important for distributed systems?

### Exit Criteria

- [ ] Go service probe works.
- [ ] Timeout and logging behavior are documented.

---

## 9. Module 1.6 — Rust for Secure Systems Programming

### Why This Matters

Rust is central for secure systems programming, memory safety, cryptography-adjacent tooling, Solana-style blockchain ecosystems, and high-assurance components.

### Mechanism

Rust uses ownership, borrowing, lifetimes, and strong typing to prevent many memory safety bugs at compile time.

### Core Concepts

- Ownership
- Borrowing
- Lifetimes
- Result and Option
- Pattern matching
- Error handling
- Traits
- Modules and crates
- Testing
- Fuzzing introduction
- Safe vs unsafe Rust

### Hands-On Exercises

- [ ] Write small ownership and borrowing examples.
- [ ] Parse structured input safely.
- [ ] Handle malformed input without panic.
- [ ] Write unit tests.
- [ ] Write property-style tests for a parser.
- [ ] Compare safe parsing with unsafe assumptions.
- [ ] Document where `unsafe` would be risky.

### Security Focus

- Memory safety
- Panic handling
- Input validation
- Dependency review
- Unsafe code review
- Fuzzing

### Mini Project — Rust Safe Config Parser

Build a Rust parser for a small config format that:

- [ ] Accepts valid input.
- [ ] Rejects malformed input.
- [ ] Has tests for edge cases.
- [ ] Handles large input safely.
- [ ] Documents security assumptions.

### Recall Checks

- What does ownership prevent?
- What is the difference between panic and recoverable error?
- Why does Rust matter for blockchain security?
- Why is unsafe Rust special during code review?

### Exit Criteria

- [ ] Rust parser works.
- [ ] Malformed input tests exist.
- [ ] Memory safety concepts can be explained from memory.

---

## 10. Module 1.7 — Authentication, Authorization, and Identity Basics

### Why This Matters

Zero Trust and secure distributed systems depend on identity. Authentication proves who/what something is. Authorization decides what it can do.

### Mechanism

Systems issue, verify, and use identities through passwords, keys, certificates, tokens, sessions, and policies.

### Core Concepts

- Authentication vs authorization
- Sessions
- Cookies
- Tokens
- API keys
- Password storage
- Multi-factor authentication
- Service accounts
- Least privilege
- Deny by default

### Hands-On Exercises

- [ ] Build a tiny login/session demo.
- [ ] Identify session cookie attributes.
- [ ] Decode a JSON Web Token in a lab.
- [ ] Compare API key and session token risks.
- [ ] Write an authorization matrix for a small app.
- [ ] Implement a deny-by-default check in sample code.
- [ ] Log authorization failures.

**JWT — JSON Web Token:** a compact token format often used to carry signed claims between systems.

### Attack Surface

- Weak passwords
- Token theft
- Missing authorization checks
- Overprivileged service accounts
- Session fixation
- Insecure cookie settings

### Defensive Controls

- Strong password hashing
- Secure cookie flags
- Short-lived tokens
- Least privilege
- Central authorization policy
- Logging and alerting

### Recall Checks

- What is the difference between authentication and authorization?
- Why is missing authorization worse than weak UI hiding?
- Why should service accounts be least privilege?

### Exit Criteria

- [ ] Authorization matrix exists.
- [ ] Session/token exercises are documented.

---

## 11. Module 1.8 — Threat Modeling Fundamentals

### Why This Matters

Principal architecture requires predicting failure before deployment.

### Mechanism

Threat modeling identifies assets, actors, entry points, trust boundaries, threats, controls, and residual risk.

### Core Concepts

- Assets
- Actors
- Entry points
- Trust boundaries
- STRIDE
- Attack trees
- Risk severity
- Controls
- Residual risk

**STRIDE:** a threat modeling framework covering Spoofing, Tampering, Repudiation, Information disclosure, Denial of service, and Elevation of privilege.

### Hands-On Exercises

- [ ] Threat model a simple login system.
- [ ] Threat model a small API.
- [ ] Draw trust boundaries for a local service.
- [ ] Create an attack tree for credential theft.
- [ ] Map one control to each major threat.
- [ ] Write residual risk statements.

### Mini Project — Small System Threat Model

Pick a small service from this phase and produce:

- [ ] System diagram
- [ ] Assets
- [ ] Trust boundaries
- [ ] STRIDE table
- [ ] Top risks
- [ ] Controls
- [ ] Residual risk
- [ ] One Architecture Decision Record

### Recall Checks

- What is a trust boundary?
- Why does residual risk remain after controls?
- How does threat modeling connect to architecture?

### Exit Criteria

- [ ] Threat model package completed.
- [ ] One ADR written.

---

## 12. Phase 1 Capstone — Foundation Security Toolkit

Build a small toolkit and documentation set proving core foundations.

Required deliverables:

- [ ] Linux system auditor
- [ ] Go network mapper or service probe
- [ ] Rust safe parser
- [ ] Python evidence collector or crypto misuse checker
- [ ] Packet analysis report
- [ ] Cryptography exercise report
- [ ] Threat model for one small system
- [ ] Architecture Decision Record
- [ ] Recall checklist and mistake log

---

## 13. Recall and Neuroscience Plan

### Retrieval Before Review

Before reviewing notes, answer:

- [ ] How does Linux enforce file access?
- [ ] What happens during TCP connection setup?
- [ ] What does TLS authenticate?
- [ ] What does a digital signature prove?
- [ ] Why do timeouts matter in Go services?
- [ ] What memory bugs does Rust reduce?
- [ ] What is the difference between authentication and authorization?

### Interleaving

Mix topics:

- Linux permissions + service hardening
- Networking + TLS + certificates
- Go services + timeouts + denial of service
- Rust parsing + input validation + fuzzing
- Authentication + authorization + threat modeling

### Teach-Back

Without notes, explain:

- [ ] A packet path from browser to service.
- [ ] A key lifecycle.
- [ ] A trust boundary diagram.
- [ ] A simple authorization design.

---

## 14. Phase 1 Exit Criteria

- [ ] All core modules completed to quality gate.
- [ ] Every important concept has hands-on evidence.
- [ ] Phase 1 capstone deliverables completed.
- [ ] Recall checks passed without notes.
- [ ] Mistake log and misconceptions updated.
- [ ] Deferred items logged with reasons.
