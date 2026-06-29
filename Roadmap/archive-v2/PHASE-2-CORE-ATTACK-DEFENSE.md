# Phase 2 — Core Attack & Defense (Months 3–7)

> **The shared foundation across all specializations. Every track in Phase 3 builds on this.**  
> **Prerequisites:** [PHASE-1-FOUNDATIONS.md](PHASE-1-FOUNDATIONS.md) complete  
> **Timeline:** ~16 weeks total  

---

## Table of Contents

- [2.1 Web Application Security (~4 weeks)](#21-web-application-security--4-weeks)
- [2.2 API Security (~2 weeks)](#22-api-security--2-weeks)
- [2.3 Network Penetration Testing (~3 weeks)](#23-network-penetration-testing--3-weeks)
- [2.4 Exploitation Fundamentals (~3 weeks)](#24-exploitation-fundamentals--3-weeks)
- [2.5 Binary Exploitation Intro (~3 weeks)](#25-binary-exploitation-intro--3-weeks)
- [2.6 Reverse Engineering Intro (~2 weeks)](#26-reverse-engineering-intro--2-weeks)
- [2.7 Secure Code Review & Threat Modeling Applied (~2 weeks)](#27-secure-code-review--threat-modeling-applied--2-weeks)
- [2.8 Defensive Security & Blue Team (~2 weeks)](#28-defensive-security--blue-team--2-weeks)
- [Phase 2 Capstone](#phase-2-capstone--full-penetration-test-report)
- [Phase 2 Exit Criteria](#phase-2-exit-criteria)

---

## 2.1 Web Application Security (~4 weeks)

### Concepts

HTTP methods & status codes, cookies & session management, same-origin policy, CORS policy, authentication vs authorization, input validation & sanitization, encoding (URL, HTML, base64), browser security model, Content Security Policy (CSP).

### Vulnerability Classes — Master in This Order

#### 1. SQL Injection
- Classic (error-based)
- Blind boolean-based
- Blind time-based
- Union-based (data extraction)
- Out-of-band (DNS/HTTP exfiltration)

#### 2. Cross-Site Scripting (XSS)
- Reflected (single request)
- Stored (persisted in database)
- DOM-based (client-side JavaScript)

#### 3. Broken Access Control
- IDOR (Insecure Direct Object Reference)
- Horizontal privilege escalation
- Vertical privilege escalation
- Path traversal

#### 4. Authentication Failures
- Brute force attacks
- Credential stuffing
- Weak tokens / predictable sessions
- Session fixation
- Password reset logic flaws

#### 5. CSRF (Cross-Site Request Forgery)
- How and when it applies
- SameSite cookie defense (Lax, Strict, None)

#### 6. Security Misconfiguration
- Default credentials
- Verbose error messages
- Directory listing enabled
- Open admin panels

#### 7. Insecure Deserialization
- PHP object injection
- Java deserialization
- Python pickle deserialization

#### 8. XXE (XML External Entity)
- Classic file read
- Blind XXE via out-of-band

#### 9. SSRF (Server-Side Request Forgery)
- Internal service access
- Cloud metadata endpoints (169.254.169.254)
- Protocol smuggling (gopher, file)

#### 10. JWT Attacks
- `alg:none` algorithm stripping
- Algorithm confusion (RS256 → HS256)
- Weak secret brute force

### Skills
- Intercept and modify HTTP requests
- Fuzz parameters systematically
- Chain multiple vulnerabilities
- Identify encoding and bypass filters
- Manual exploitation without automated tools first

### Tools
```
Burp Suite Community, sqlmap, gobuster, feroxbuster, nikto,
curl, jwt_tool
```

### Practice Platforms

| Platform | Setup | Account |
|---|---|---|
| **OWASP WebGoat** | `docker run webgoat/webgoat` | None |
| **DVWA** | `docker run vulnerables/web-dvwa` | None |
| **OWASP Juice Shop** | `docker run bkimminich/juice-shop` | None |
| **PortSwigger Web Academy** | Web-based | Email only |

### Completion Targets
- PortSwigger: **All SQLi labs** completed
- PortSwigger: **All Authentication labs** completed
- PortSwigger: **All XSS labs** completed
- PortSwigger: All Access Control labs completed
- DVWA: All vulnerability types exploited manually
- Juice Shop: At least 50% of challenges

### Mini Project — Web Vulnerability Scanner

```python
# web_vuln_scanner.py
# Given a URL, the tool should:
# 1. Crawl the application (find all pages, forms, parameters)
# 2. Identify all input points (forms, URL params, headers)
# 3. Test each input for: reflected XSS, basic SQLi patterns
# 4. Check HTTP security headers (CSP, HSTS, X-Frame-Options, X-Content-Type-Options)
# 5. Check for common misconfigurations:
#    - Directory listing
#    - Backup files (.bak, .old, .zip)
#    - Default paths (/admin, /phpmyadmin, etc.)
# 6. Output findings with severity rating (Critical/High/Medium/Low/Info)
```

> **Not a replacement for Burp — a learning exercise.**

---

## 2.2 API Security (~2 weeks)

### Concepts

REST vs GraphQL vs gRPC attack surfaces, API authentication methods (API keys, OAuth2, JWT, Basic Auth), API versioning and why old versions persist, rate limiting and bypass techniques, mass assignment, excessive data exposure.

### OWASP API Security Top 10

| # | Vulnerability | Description |
|---|---|---|
| API1 | BOLA | Broken Object Level Authorization — API's IDOR |
| API2 | Broken Authentication | Weak API key handling, token leakage |
| API3 | Broken Object Property Level Authorization | Mass assignment, over-exposure |
| API4 | Unrestricted Resource Consumption | Rate limit bypass, cost amplification |
| API5 | BFLA | Broken Function Level Authorization — accessing admin endpoints |
| API6 | Unrestricted Access to Sensitive Business Flows | |
| API7 | SSRF via API | |
| API8 | Security Misconfiguration | CORS, verbose errors, unnecessary HTTP methods |
| API9 | Improper Inventory Management | Shadow APIs, deprecated versions |
| API10 | Unsafe Consumption of APIs | Trusting third-party API responses |

### Skills
- API enumeration and mapping
- Authentication bypass techniques
- Fuzzing API endpoints
- GraphQL introspection abuse
- Manipulating request parameters for BOLA

### Tools
```
Burp Suite, Postman (local), curl, ffuf (API fuzzing),
graphql-cop, kiterunner (API wordlist discovery)
```

### Practice

| Platform | Setup | Account |
|---|---|---|
| **crAPI** | `docker run crapi/crapi-all` | None |
| **vAPI** | `docker run -p 8080:80 marcopinont/vapi` | None |
| **DVWS** | `docker run -p 8080:80 inter NUMA/dvws` | None |

### Targets
- Discover all endpoints via wordlist + HTTP method fuzzing
- Test each endpoint for BOLA by iterating object IDs
- Check for excessive data exposure (compare request fields vs response fields)
- Test authentication bypass with missing/invalid/modified tokens

### Mini Project — API Security Tester

```python
# api_security_tester.py
# Given an API base URL:
# 1. Discover endpoints via wordlist + HTTP method fuzzing
# 2. Test each endpoint for BOLA (iterate object IDs)
# 3. Check for excessive data exposure
# 4. Test auth bypass (missing/invalid/modified tokens)
# 5. Generate API surface map with risk annotations
# 6. Output: structured JSON report
```

---

## 2.3 Network Penetration Testing (~3 weeks)

### Concepts

Penetration testing methodology, enumeration depth principle, attack surface documentation, CVE research process, exploit reliability vs noise, lateral movement concepts, pivoting between networks.

### Penetration Testing Methodology

```
Recon → Scan → Enumerate → Research → Exploit → Post-Exploit → Document
```

> **Rule:** Never exploit before thorough enumeration. Every missed service is a missed opportunity.

### Skills

- Structured and thorough enumeration before exploitation
- Service-specific enumeration for each open port
- CVE identification from version numbers
- Exploit selection and modification
- Documenting every step for reproducibility

### Tools

```
nmap (deep: NSE scripts, -sV, -sC, -O, -A),
masscan (high-speed scanning),
enum4linux-ng (SMB/RPC), smbclient, rpcclient,
snmpwalk, onesixtyone,
hydra, medusa (brute force),
searchsploit (local exploitdb),
netcat
```

### Deep nmap Usage

```bash
# Full port scan with scripts
nmap -p- -sV -sC -O --script vuln -oA full_scan <target>

# Quick UDP top ports
nmap -sU --top-ports 100 -oA udp_scan <target>

# SMB enumeration
nmap -p445 --script smb-enum-shares,smb-enum-users <target>

# HTTP enumeration
nmap -p80,443 --script http-enum,http-title,http-methods <target>
```

### Practice

Complete **5+ VulnHub machines** with full write-ups:

| Machine Series | Difficulty | Focus |
|---|---|---|
| **Kioptrix 1–5** | Beginner | Classic privesc paths |
| **Mr. Robot** | Beginner | WordPress, CTF-style |
| **DC-1 to DC-9** | Beginner–Intermediate | Linux, various techniques |
| **Stapler** | Intermediate | Multi-service enumeration |
| **Brainpan** | Intermediate | Buffer overflow intro |

**Requirement:** One complete write-up per machine. Template:
1. Recon findings
2. Enumeration steps and output
3. Exploitation path
4. Privilege escalation
5. Lessons learned

### Mini Project — Automated Enumeration Pipeline

```bash
#!/bin/bash
# auto_enum.sh <target_ip>
# Pipeline:
# 1. Run nmap full scan → parse XML output
# 2. For each open port, launch service-specific enum:
#    - SMB (445) → enum4linux-ng, smbclient -L
#    - FTP (21) → anonymous login test, dir listing
#    - HTTP (80/443) → gobuster + nikto + curl headers
#    - SSH (22) → ssh-audit
#    - SNMP (161) → snmpwalk with public/community
# 3. Save everything to structured per-target directory:
#    targets/<ip>/nmap/
#    targets/<ip>/smb/
#    targets/<ip>/http/
#    targets/<ip>/ssh/
#    targets/<ip>/report.md
```

---

## 2.4 Exploitation Fundamentals (~3 weeks)

### Concepts

Exploit types (remote, local, web, physical), shellcode concepts, staged vs stageless payloads, reverse vs bind shells, meterpreter vs shell sessions, post-exploitation objectives, living off the land (LOLBins), persistence mechanisms.

### Linux Privilege Escalation Paths — Master All

| Path | How It Works | Detection |
|---|---|---|
| **SUID/SGID binary abuse** | Run program as file owner | `find / -perm -4000 2>/dev/null`, GTFOBins |
| **Sudo misconfigurations** | `sudo -l` shows allowed commands | `sudo -l`, sudoers file |
| **Cron job abuse** | World-writable script executed by root | `crontab -l`, `/etc/crontab` |
| **Writable /etc/passwd** | Add root user entry | `ls -la /etc/passwd` |
| **Kernel exploits** | Exploit kernel vulnerability | `uname -r`, searchsploit |
| **Path hijacking** | $PATH manipulation for sudo commands | `echo $PATH` |
| **Weak file permissions** | Read SSH keys, shadow file | `find / -readable -perm -o+r` |
| **NFS no_root_squash** | Mount NFS as root locally | `showmount -e <target>` |
| **Docker group membership** | Escape container via mounted socket | `groups`, `docker ps` |

### Skills
- Exploit framework usage (Metasploit)
- Manual exploitation without frameworks
- Shell stabilization and upgrade (tty → full PTY)
- Privilege escalation enumeration
- Persistence without detection

### Tools
```
Metasploit (msfconsole, msfvenom), searchsploit, pwntools (intro),
linpeas, linenum, GTFOBins (reference), netcat
```

### Mini Project — Privilege Escalation Chainer

Pick 3 VulnHub machines. On each:

1. Achieve initial access
2. **Enumerate for privilege escalation vectors manually first** (before running linpeas)
3. Document every path found with its risk level and remediation
4. Run linpeas and compare — what did you miss?
5. Write a comparison: manual vs automated enumeration accuracy

**Deliverable:** 3 detailed write-ups + comparison report. Publish on GitHub.

---

## 2.5 Binary Exploitation Intro (~3 weeks)

### Concepts

Memory layout (stack, heap, text, data, BSS segments), stack frames & function calls, calling conventions (x86 cdecl, x64 System V AMD64 ABI), buffer overflows (stack-based), return address overwrite, NOP sleds, shellcode injection.

### Mitigations to Understand

| Mitigation | What It Does | Bypass Approach |
|---|---|---|
| **Stack Canaries** | Detects stack buffer overflow via cookie | Leak the canary value |
| **ASLR** | Randomizes memory addresses | Info leak, partial overwrite |
| **NX/DEP** | Stack is non-executable | Return-oriented programming (ROP) |
| **PIE** | Binary loaded at random address | Partial overwrite, leak base |
| **RELRO** | Protects GOT from overwrite | Other techniques |
| **Fortify Source** | Compile-time buffer checks | Find unprotected function |

### Skills
- Reading x86/x64 assembly at a basic level
- Using GDB + pwndbg to trace execution
- Finding buffer overflow offsets (cyclic patterns)
- Controlling the instruction pointer (RIP/EIP)
- Bypassing basic mitigations

### Tools
```
GDB + pwndbg (or peda), pwntools, objdump, strace, ltrace,
checksec, rabin2 (from radare2)
```

### Practice

| Platform | Focus | Account |
|---|---|---|
| **pwn.college** | Exploit mitigations module | Email only |
| **Protostar** | Stack-based overflows (VulnHub VM) | None |
| **exploit.education** | Phoenix/Fusion VMs | None |
| **PicoCTF** | Beginner-friendly binary challenges | None |

### Mini Project — CTF Binary Challenge Write-ups

Solve 3 binary exploitation CTF challenges. For each write-up:

1. `checksec` output (list all mitigations)
2. Your analysis process (disassembly, decompilation)
3. The exact vulnerability
4. Your exploit approach (step-by-step)
5. Working pwntools exploit script

**Publish all three write-ups on GitHub.**

---

## 2.6 Reverse Engineering Intro (~2 weeks)

### Concepts

Compiled vs interpreted code, ELF and PE file formats, static vs dynamic analysis, disassembly vs decompilation, common assembly patterns (loops, conditionals, function calls), string extraction, import/export tables, obfuscation basics, packing.

### Skills
- Navigate a binary in a disassembler
- Identify key logic (authentication checks, string comparisons, crypto routines)
- Rename functions and variables for clarity
- Understand what a binary does without source code

### Tools
```
Ghidra (free, open source), radare2, strings, file, binwalk,
objdump, ltrace, strace
```

### Practice

| Platform | Focus | Account |
|---|---|---|
| **crackmes.one** | Beginner reverse engineering | Email only |
| **PicoCTF** | Reverse engineering challenges | None |

### Mini Project — Crack 3 Crackme Binaries

Pick 3 crackme challenges of increasing difficulty. For each:

1. Identify the correct input using **Ghidra static analysis only** (no running the binary)
2. Write a detailed explanation of the authentication logic reversed
3. Include annotated Ghidra screenshots showing key decompilation

**This demonstrates reverse engineering ability to employers.**

---

## 2.7 Secure Code Review & Threat Modeling Applied (~2 weeks)

### Concepts

Difference between code review for quality vs security, taint analysis (tracing untrusted input through a codebase), sink functions (dangerous functions to look for), source-to-sink tracing, common patterns per language.

### What to Look For in Code Review

| Category | Patterns |
|---|---|
| **Injection** | Unsanitized input reaching SQL/command/HTML sinks |
| **Auth** | Missing or incorrect authentication/authorization checks |
| **Crypto** | Hardcoded keys, weak algorithms, improper implementation |
| **Secrets** | Credentials hardcoded or in environment variables |
| **Deserialization** | Unsafe pickle, ObjectInputStream, unserialize() |
| **Logic** | Race conditions, logic errors in access control |
| **Input Validation** | Missing validation on edge cases |

### Language-Specific Sinks

**Python:** `eval()`, `exec()`, `pickle.loads()`, `subprocess.call(shell=True)`, `os.system()`, raw SQL in `cursor.execute()`

**JavaScript:** `eval()`, `innerHTML`, `child_process.exec()`, `vm.runInContext()`

**Solidity:** `call.value()`, `delegatecall()`, `selfdestruct()`, assembly blocks

### Skills
- Read unfamiliar codebases efficiently
- Identify dangerous patterns quickly
- Prioritize findings by exploitability
- Write a code review report with file:line references

### Tools
```
Semgrep (local, free), bandit (Python), eslint-plugin-security (JS),
grep patterns for manual taint tracing, trufflehog (secrets),
gitleaks (secrets in git history)
```

### Mini Project — Audit an Open Source App

Pick a small open-source web application (Python/Flask or Node.js):

1. Run Semgrep and Bandit
2. Scan git history with gitleaks
3. Perform manual code review tracing 3 input points through to their sinks
4. Write a findings report with:
   - Vulnerability name
   - File:line reference
   - Severity (Critical/High/Medium/Low)
   - Proof of concept (local test)
   - Remediation with code fix

**Publish the report on GitHub** (pick something already well-audited or a known vulnerable app for responsible learning).

---

## 2.8 Defensive Security & Blue Team (~2 weeks)

### Concepts

SIEM architecture, log sources and normalization, detection rule logic, alert triage process, true positive vs false positive vs false negative, incident response lifecycle (PICERL), threat hunting basics, IOC vs TTP, MITRE ATT&CK framework.

### Incident Response Lifecycle (PICERL)

| Phase | Actions |
|---|---|
| **Preparation** | Tools, playbooks, training |
| **Identification** | Detect and confirm the incident |
| **Containment** | Limit damage (short-term + long-term) |
| **Eradication** | Remove threat from environment |
| **Recovery** | Restore systems to normal |
| **Lessons Learned** | Post-incident review, improve defenses |

### Skills
- Write detection rules (Wazuh, Sigma)
- Read and prioritize alerts
- Correlate events across multiple log sources
- Perform basic incident investigation
- Write an incident report
- Map attacker behavior to ATT&CK tactics

### Tools
```
Wazuh (self-hosted SIEM/EDR), Elastic Stack,
auditd (Linux syscall auditing), fail2ban,
suricata (network IDS), MITRE ATT&CK Navigator
```

### Practice

Run all your Phase 2 attacks against your lab VMs while Wazuh monitors them:

1. Run Metasploit exploit → check Wazuh alerts
2. Run SQLmap → check detection
3. Run hydra brute force → check detection
4. Run nmap scan → check detection
5. Investigate: what got detected, what didn't, and why

Write a **detection gap analysis** document.

### Mini Project — Detection Rule Library

Write 5 custom Wazuh detection rules for techniques you used:

For each rule, document:
1. The MITRE ATT&CK technique ID it detects
2. The log source it monitors
3. The rule logic (XML/rule syntax)
4. Expected alert output
5. One evasion technique an attacker might use

**This is exactly what blue team engineers do daily.**

---

## Phase 2 Capstone — Full Penetration Test Report

### What It Is
A professional-grade penetration test report on a VulnHub machine, written as if delivered to a real client.

### Report Structure

```
1. EXECUTIVE SUMMARY
   → Non-technical, risk-focused, business impact

2. SCOPE AND METHODOLOGY
   → What was tested, what wasn't, testing approach

3. ATTACK NARRATIVE
   → Chronological: what you did and why at each step

4. FINDINGS TABLE
   → Vulnerability | Severity | CVSS Score | Evidence

5. PER-FINDING DETAIL (repeat for each)
   → Description
   → Proof of exploitation (screenshots + steps)
   → Business impact
   → Remediation recommendation

6. REMEDIATION PRIORITY ROADMAP
   → Ordered by risk, with timeline estimates
```

### Standard to Meet

Compare against public reports from:
- **Trail of Bits** (https://github.com/trailofbits/publications)
- **Cure53** (https://cure53.de/#publications)

### Where It Goes

GitHub as a PDF. This is your **single most important Phase 2 portfolio piece.**

---

## Phase 2 Exit Criteria

Before moving to Phase 3, complete **all** of the following:

- [ ] Rooted Metasploitable 2 via 3+ different attack paths, all documented
- [ ] Completed PortSwigger: all SQLi, Authentication, XSS, Access Control labs
- [ ] Deployed and exploited crAPI locally (BOLA, authentication bypass, rate limit)
- [ ] Solved 3 binary exploitation CTF challenges with published write-ups
- [ ] Reversed 3 crackme binaries using Ghidra only, documented
- [ ] Performed manual code review on open-source app with published report
- [ ] Written 5 custom Wazuh detection rules for techniques you used
- [ ] Phase 2 capstone penetration test report published on GitHub
- [ ] 5+ VulnHub machines completed with write-ups
- [ ] All notes committed to notes repository

---

**Prerequisites:** [PHASE-1-FOUNDATIONS.md](PHASE-1-FOUNDATIONS.md)  
**Next → Phase 3 Tracks (run in parallel):**
- **[PHASE-3-TRACK-A-WEB3.md](PHASE-3-TRACK-A-WEB3.md)**
- **[PHASE-3-TRACK-B-AI-ML.md](PHASE-3-TRACK-B-AI-ML.md)**
- **[PHASE-3-TRACK-C-CLOUD.md](PHASE-3-TRACK-C-CLOUD.md)**
- **[PHASE-3-TRACK-D-WINDOWS-AD.md](PHASE-3-TRACK-D-WINDOWS-AD.md)**

---

*v2 — Local-first · Free · No KYC · No Subscriptions*
