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

Each exercise must be performed on your lab Linux workstation or a target VM. Save evidence (command output, screenshots, logs) in your lab evidence directory.

---

#### Exercise 1.1.1 — Map the filesystem hierarchy

**Objective:** Understand where system binaries, configs, logs, user data, and temporary files live.

```bash
# 1. List the root directory
ls -la /
# -l: long format (permissions, owner, size, date)
# -a: include hidden entries (. and ..)

# 2. Identify the purpose of each top-level directory
ls -la /bin        # Essential user binaries (available in single-user mode)
ls -la /sbin       # System binaries (usually root-only)
ls -la /etc        # Configuration files
ls -la /var        # Variable data (logs, databases, spool)
ls -la /var/log    # Log files
ls -la /tmp        # Temporary files (world-writable)
ls -la /home       # User home directories
ls -la /root       # Root user's home
ls -la /usr        # User system resources (binaries, libraries, docs)
ls -la /proc       # Virtual filesystem for process/kernel information

# 3. Expected observation
# /tmp is world-writable (drwxrwxrwt) — any user can write there.
# This makes it a common attack staging ground.
```

**Why /tmp matters for security:** it is often used for privilege escalation or staging malicious files because permissions are open. Restrict or audit /tmp usage on production systems.

**Evidence to save:** command output showing /tmp permissions.

---

#### Exercise 1.1.2 — Users, groups, and permissions

**Objective:** Create users and groups, then observe how file permissions control access.

```bash
# 1. Create two test users
sudo useradd -m -s /bin/bash user_alice
echo "user_alice:password123" | sudo chpasswd

sudo useradd -m -s /bin/bash user_bob
echo "user_bob:password123" | sudo chpasswd
```

```
Flags used:
- useradd -m : create home directory
- useradd -s : set login shell
- chpasswd  : set password (reads username:password from stdin)
```

```bash
# 2. Create a shared group
sudo groupadd group_demo
sudo usermod -aG group_demo user_alice
sudo usermod -aG group_demo user_bob
```

```
- usermod -aG : append user to a supplementary group (-a = append, -G = secondary group)
```

```bash
# 3. Switch to user_alice and create a file
sudo -i -u user_alice
cd /tmp
echo "secret data" > file_alice.txt
ls -la file_alice.txt
exit

# Expected: -rw-rw-r-- user_alice user_alice
# user_alice can read/write, group can read/write, others can read
```

```bash
# 4. Switch to user_bob and try to read the file
sudo -i -u user_bob
cat /tmp/file_alice.txt
# Expected: works (others have read permission)
chmod o-r /tmp/file_alice.txt
# Exit user_bob, become user_alice, apply restrictive permissions, retest
exit
```

**Security lesson:** By default, many systems create files with broad permissions. Remove world-readable/writable where not needed.

---

#### Exercise 1.1.3 — Permission denial demonstration

```bash
# 1. Create a file accessible only to owner
sudo -i -u user_alice
cd /tmp
echo "my secret" > file_private.txt
chmod 600 file_private.txt
# 600 = rw------- (owner read+write, group nothing, others nothing)
exit

# 2. Try to read as user_bob
sudo -i -u user_bob
cat /tmp/file_private.txt
# Expected: Permission denied
```

**Attack relevance:** A common privilege escalation path is finding world-readable sensitive files (configs with passwords) or world-writable scripts (inject malicious code).

---

#### Exercise 1.1.4 — Find SUID and SGID binaries

SUID binaries run with the file owner's permissions, not the calling user's. This is a common privilege escalation vector.

```bash
# Find all SUID binaries (owner permission with 's' instead of 'x')
find / -perm -4000 -type f 2>/dev/null
```

```
- find /       : start from root
- -perm -4000  : SUID bit set (4000 octal)
- -type f      : only regular files (not directories)
- 2>/dev/null  : redirect permission-denied errors to /dev/null (hide them)
```

```bash
# Find all SGID binaries (group permission with 's')
find / -perm -2000 -type f 2>/dev/null

# Combined: SUID or SGID
find / \( -perm -4000 -o -perm -2000 \) -type f 2>/dev/null
```

```
- \( ... \)    : group conditions together
- -o           : logical OR
```

**Expected observation:** You will see binaries like `/usr/bin/sudo`, `/usr/bin/passwd`, `/bin/ping`. These are intentionally SUID for legitimate functionality.

**Attack relevance:** A misconfigured SUID binary (or one that can be replaced by a writable path) allows privilege escalation.

**Detection:** Monitor new SUID files with auditd or file integrity tools.

---

#### Exercise 1.1.5 — Systemd service inspection

```bash
# List all running services
systemctl list-units --type=service --state=running
```

```
- systemctl list-units : list loaded units
- --type=service       : show only service units
- --state=running      : show only running services
```

```bash
# Inspect a specific service (pick one from the list)
systemctl status sshd
# Expected: shows status, main PID, memory, recent log lines

# Check if a service is enabled (starts on boot)
systemctl is-enabled sshd

# View the service unit file
systemctl cat sshd
# Expected: shows [Unit], [Service], [Install] sections
```

```bash
# Start/stop a test service safely (never on production)
sudo systemctl stop cron
echo "Cron status:" && systemctl is-active cron
sudo systemctl start cron
```

**Security relevance:** Misconfigured service unit files can allow privilege escalation (e.g., writable ExecStart path, insecure environment variables).

---

#### Exercise 1.1.6 — Read authentication and system logs

```bash
# View authentication log (Debian/Ubuntu)
sudo cat /var/log/auth.log | tail -20
# head -20 : show last 20 lines (newest events)

# Look for failed login attempts
sudo grep "Failed password" /var/log/auth.log
```

```bash
# View system log
sudo cat /var/log/syslog | tail -20

# Use journalctl (modern alternative)
sudo journalctl -xe | tail -30
# -x : add explanatory text where available
# -e : jump to end
```

**Expected observation:** You will see failed login attempts, sudo usage, service starts/stops.

**Attack relevance:** An attacker who deletes or modifies logs can hide their activity. Log integrity monitoring is a critical control.

---

#### Exercise 1.1.7 — Permission break-and-fix

```bash
# 1. Find a world-writable file or create one for testing
# BE CAREFUL: do not modify system files on your host
cd /tmp
touch test_break.txt
chmod 777 test_break.txt
# 777 = rwxrwxrwx (anyone can read/write/execute)

# 2. Verify
ls -la test_break.txt
# Expected: -rwxrwxrwx

# 3. Fix: remove world-writable
chmod 755 test_break.txt
# 755 = rwxr-xr-x (owner all, group read+execute, others read+execute)

# Verify
ls -la test_break.txt
# Expected: -rwxr-xr-x
```

**Real scenario:** World-writable configuration or script files are a high-severity finding. Attackers can inject malicious commands.

---

#### Exercise 1.1.8 — Write a Linux trust-boundary note

Produce a one-page document that:

- [ ] Identifies the trust boundary between user mode and kernel mode.
- [ ] Identifies the trust boundary between root and non-root users.
- [ ] Identifies the trust boundary between processes under different users.
- [ ] Identifies which logs cross each boundary.
- [ ] Identifies which controls enforce each boundary (permissions, capabilities, namespaces).
- [ ] Lists one attack path that crosses each boundary.

**Format:** Markdown file saved in your documentation directory.

**Why this matters:** Trust boundaries are the foundation of threat modeling. If you cannot identify them in an operating system, you cannot identify them in a distributed architecture.

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

**Goal:** Build a shell script that inventories security-relevant Linux configuration.

The script should report:

| Check | Command | Risk if misconfigured |
|-------|---------|----------------------|
| Users with UID 0 | `awk -F: '$3 == 0' /etc/passwd` | Extra root users = full control |
| Sudo-capable users | `grep -r '^[^#].*ALL' /etc/sudoers /etc/sudoers.d/ 2>/dev/null` | Overprivileged sudo access |
| SUID/SGID binaries | `find / -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null` | Privilege escalation vectors |
| World-writable paths | `find / -xdev -type d -perm -0002 -print 2>/dev/null` | Staging grounds for attacker files |
| Listening ports | `ss -tulnp` | Unexpected services exposing attack surface |
| Running services | `systemctl list-units --type=service --state=running --no-pager` | Unnecessary services increase attack surface |
| Recent failed logins | `lastb \| head -20` | Brute-force indicator |
| Users without passwords | `awk -F: '$2 == "" || $2 == "!" || $2 == "*"' /etc/shadow` | Accounts with disabled/insecure login |

**Deliverable:**

- [ ] The script runs without errors on the lab Linux machine.
- [ ] Output is structured (plain text sections or JSON).
- [ ] Each finding includes a one-line risk assessment.
- [ ] A sample output file is saved as evidence.
- [ ] The script has a comment header explaining its purpose and limitations.

**Example snippet:**

```bash
#!/bin/bash
# linux-auditor.sh - Security inventory for Linux systems
# Usage: ./linux-auditor.sh
# Output: structured report with risk annotations

echo "=== SUID/SGID Binaries ==="
find / -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null

echo ""
echo "=== World-Writable Directories (first 20) ==="
find / -xdev -type d -perm -0002 -print 2>/dev/null | head -20

echo ""
echo "=== Listening Ports ==="
ss -tulnp
```

---

### Recall Checks

Answer without notes:

- **Why is SUID dangerous?** It executes as the file owner. If a root-owned SUID binary has a flaw, any user can escalate to root.
- **What is the difference between user, group, and other permissions?** User = file owner. Group = members of the file's group. Other = everyone else.
- **How does systemd change the attack surface?** It manages services declaratively. Misconfigured unit files can grant excessive privileges, expose environment variables with secrets, or allow unauthorized start/stop.
- **Which logs help investigate failed login attempts?** `/var/log/auth.log` (Debian/Ubuntu), `/var/log/secure` (RHEL/CentOS), or `journalctl -u sshd`.
- **Why is /tmp a common attack vector?** It is world-writable by default. Attackers stage files there or exploit race conditions on temporary file creation.

---

### Exit Criteria

- [ ] Exercises 1.1.1 through 1.1.8 are completed and documented.
- [ ] Linux system auditor script runs on the lab machine and produces structured output.
- [ ] Permission exercises produced evidence (command outputs, observations).
- [ ] Trust-boundary note is written and saved in the documentation directory.
- [ ] Recall checks can be answered without notes.
- [ ] Common mistakes are documented in the error log.

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
