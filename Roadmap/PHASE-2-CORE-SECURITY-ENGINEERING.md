# Phase 2 — Core Security Engineering

> Purpose: Learn how real systems fail, how attackers chain weaknesses, and how defenders design, detect, respond, and build securely.

---

## 1. Phase Goal

This phase turns foundations into practical security capability. The target is not only penetration testing and not only defense. The target is complete security engineering: understand the mechanism, exploit it safely in a lab, fix it, detect it, document it, and extract architecture lessons.

---

## 2. Prerequisites

- [ ] Phase 0 lab available.
- [ ] Phase 1 foundations substantially complete.
- [ ] Linux, networking, cryptography, Python, Go, Rust basics are usable.
- [ ] Basic threat modeling is understood.

---

## 3. Outcomes

By the end of this phase, you should be able to:

- [ ] Assess web applications and APIs.
- [ ] Explain and exploit common vulnerability classes in a lab.
- [ ] Patch or mitigate discovered vulnerabilities.
- [ ] Review code for security flaws.
- [ ] Understand authentication and authorization failures.
- [ ] Explain and attack enterprise Windows identity (Active Directory).
- [ ] Write basic detection logic and operate it through real SIEM/EDR tooling.
- [ ] Build incident timelines from logs and from forensic evidence.
- [ ] Understand software supply chain risk.
- [ ] Explain secure engineering practices and operate a real DevSecOps pipeline.
- [ ] Convert vulnerabilities into architecture improvements.

---

## 4. Module 2.1 — Web Application Security

### Why This Matters

Web applications are still one of the most common entry points into organizations, cloud platforms, AI apps, and blockchain dashboards.

### Mechanism

Web applications accept untrusted input, maintain sessions, access databases, render output, and enforce authorization. Vulnerabilities happen when trust boundaries are crossed without validation, encoding, or access control.

### Core Vulnerability Classes

- SQL injection
- Cross-site scripting
- Cross-site request forgery
- Insecure direct object references
- Broken access control
- Authentication failures
- Server-side request forgery
- Insecure deserialization
- Security misconfiguration
- File upload issues

**SQL — Structured Query Language:** a language used to query and modify relational databases.

**SSRF — Server-Side Request Forgery:** a vulnerability where an attacker makes a server send requests to unintended internal or external targets.

### Hands-On Exercises

For each important vulnerability class:

- [ ] Explain the mechanism.
- [ ] Exploit it in a local vulnerable lab.
- [ ] Capture evidence.
- [ ] Patch or configure a mitigation.
- [ ] Retest the attack.
- [ ] Identify logs or telemetry.
- [ ] Write one architecture lesson.

Specific exercises:

- [ ] SQL injection: exploit login bypass and fix with parameterized queries.
- [ ] Cross-site scripting: trigger reflected and stored script execution, then fix output encoding.
- [ ] Access control: access another user's object, then add object ownership checks.
- [ ] Authentication: test weak session handling and improve cookie settings.
- [ ] SSRF: reach a lab-internal service, then restrict outbound requests.
- [ ] File upload: upload dangerous content, then enforce type and storage controls.

### Defensive Controls

- Parameterized queries
- Output encoding
- Content Security Policy
- Secure cookies
- SameSite policy
- Server-side authorization
- Input validation
- Egress filtering
- Safe file handling
- Security headers

### Detection and Telemetry

- Web access logs
- Application errors
- Database query anomalies
- Repeated authorization failures
- Unexpected outbound requests
- Suspicious user agents

### Mini Project — Web Vulnerability Assessment Package

Assess a local vulnerable web app and produce:

- [ ] Findings table
- [ ] Proof-of-concept steps
- [ ] Root cause explanation
- [ ] Secure code/config fix
- [ ] Detection notes
- [ ] Architecture recommendations

### Recall Checks

- Why do parameterized queries stop SQL injection?
- Why is output encoding context-specific?
- Why is server-side authorization mandatory?
- Why does SSRF matter in cloud environments?

---

## 5. Module 2.2 — API Security

### Why This Matters

Distributed systems, mobile apps, blockchain services, AI systems, and cloud platforms communicate through APIs.

**API — Application Programming Interface:** a structured interface that lets software systems request data or actions from each other.

### Mechanism

APIs expose functions and data over network protocols. Security depends on authentication, authorization, input validation, rate limits, schema enforcement, and safe downstream trust.

### Core Concepts

- REST
- GraphQL
- gRPC
- Object-level authorization
- Function-level authorization
- Mass assignment
- Excessive data exposure
- Rate limiting
- API inventory
- Versioning and shadow APIs

### Hands-On Exercises

- [ ] Enumerate endpoints in a local API.
- [ ] Test missing authentication.
- [ ] Test broken object-level authorization.
- [ ] Test function-level authorization.
- [ ] Test mass assignment.
- [ ] Compare request fields and response fields for overexposure.
- [ ] Test rate limit behavior.
- [ ] Write an API authorization matrix.
- [ ] Log and alert on repeated failed access attempts.

### Defensive Controls

- Centralized authorization checks
- Object ownership validation
- Schema validation
- Least privilege tokens
- Rate limiting
- API gateway policy
- Version inventory
- Secure error responses

### Mini Project — API Authorization Tester

Build or extend a Python/Go tool that:

- [ ] Reads endpoint definitions.
- [ ] Tests object ID access with two users.
- [ ] Tests missing/invalid tokens.
- [ ] Tests role-based endpoint access.
- [ ] Produces JSON and human-readable reports.

### Architecture Exercise

- [ ] Design an API authorization model for users, admins, and services.
- [ ] Write an ADR deciding between embedded authorization and policy-as-code.

### Recall Checks

- What is Broken Object Level Authorization?
- Why is an API inventory a security control?
- Why is authorization not the same as authentication?

---

## 6. Module 2.3 — Authentication, Authorization, and Session Security Deepening

### Why This Matters

Identity is the backbone of Zero Trust. Most serious systems fail when authentication or authorization assumptions fail.

### Core Concepts

- Password storage
- Sessions
- Cookies
- JWTs
- OAuth 2.0 basics
- OpenID Connect basics
- API keys
- Service accounts
- Role-Based Access Control
- Attribute-Based Access Control
- Policy decision and enforcement points

**OAuth 2.0:** an authorization framework used to grant limited access to resources without sharing passwords.

**OIDC — OpenID Connect:** an identity layer on top of OAuth 2.0 used for login and identity claims.

### Hands-On Exercises

- [ ] Review secure and insecure password storage examples.
- [ ] Inspect cookie flags and session behavior.
- [ ] Decode and validate a JWT.
- [ ] Demonstrate missing JWT validation in a lab.
- [ ] Build an authorization matrix.
- [ ] Implement role checks.
- [ ] Implement attribute-based checks.
- [ ] Log policy decisions.

### Defensive Controls

- Password hashing with strong algorithms
- Secure session cookies
- Token expiry
- Audience and issuer validation
- Least privilege service accounts
- Deny-by-default policy
- Centralized policy where useful

### Detection and Telemetry

- Failed logins
- Token validation failures
- Privilege changes
- Denied authorization events
- Impossible travel or unusual access patterns

### Recall Checks

- What must be validated in a JWT?
- Why are long-lived tokens dangerous?
- What is the difference between RBAC and ABAC?

---

## 7. Module 2.3b — Windows Identity and Active Directory Attacks

### Why This Matters

Most enterprise environments run on Active Directory. Nearly every real-world internal penetration test or red team engagement ends in some form of domain compromise. A CyberSec Engineer who cannot reason about Kerberos, NTLM, and AD privilege escalation cannot operate in the majority of enterprise environments.

### Lab Setup Note

Before this module, apply the Lab Extension Protocol from Phase 0 (Section 6) to build an isolated Windows Identity zone: one domain controller, one or two domain-joined clients, fully isolated from the real local network, with snapshot/restore.

### Core Concepts

- Active Directory objects: users, groups, computers, OUs, GPOs
- Kerberos authentication flow (AS-REQ/AS-REP, TGT, TGS-REQ/TGS-REP)
- NTLM authentication and relay
- Pass-the-Hash
- Kerberoasting
- AS-REP Roasting
- DCSync
- Golden Ticket / Silver Ticket concepts
- BloodHound-style attack path analysis
- Lateral movement
- AD privilege escalation paths (ACL abuse, delegation abuse, GPO abuse)
- AD hardening fundamentals (tiering model, LAPS, protected groups)

### Hands-On Exercises

- [ ] Build the domain: create a domain controller, join one client, create test users/groups/service accounts.
- [ ] Capture and explain a full Kerberos authentication exchange in a packet capture.
- [ ] Demonstrate Pass-the-Hash against a domain-joined lab machine.
- [ ] Demonstrate Kerberoasting against a deliberately weak service account password.
- [ ] Demonstrate AS-REP Roasting against an account with Kerberos pre-authentication disabled.
- [ ] Run a BloodHound-style collection against the lab domain and identify at least one attack path to Domain Admin.
- [ ] Demonstrate DCSync against an account with replication rights misconfigured.
- [ ] Document one lateral movement path using captured credentials or tickets.
- [ ] Write an AD privilege escalation path report.

### Attack Surface

- Weak service account passwords (Kerberoasting)
- Accounts without Kerberos pre-authentication (AS-REP Roasting)
- Overprivileged users and nested group misconfiguration
- Excessive ACL delegation
- Unconstrained delegation
- Replication rights misconfiguration (DCSync)
- Legacy protocol support (NTLMv1, LM)
- Credential caching on workstations

### Defensive Controls

- Tiered administration model
- Long, unique service account passwords or group-managed service accounts
- Kerberos pre-authentication enforcement
- Restricting and auditing replication rights
- Constrained or no delegation by default
- Local Administrator Password Solution (LAPS) or equivalent
- Disabling legacy authentication protocols
- Protected Users group for privileged accounts

### Detection and Telemetry

- Windows Security Event Logs: 4768/4769 (Kerberos ticket requests), 4624/4625 (logons), 4662 (object access, relevant to DCSync)
- Unusual TGS requests for service accounts (Kerberoasting indicator)
- Replication requests from non-domain-controller sources
- BloodHound-style attack path review used proactively as a detection exercise
- Privileged group membership change alerts

### Mini Project — AD Attack Path Report

Deliver:

- [ ] Domain diagram with trust/privilege relationships
- [ ] Attack path from initial low-privilege user to Domain Admin
- [ ] Evidence for each step (packet capture, command output, or screenshot)
- [ ] Detection opportunities at each step
- [ ] Hardening recommendations mapped to each step
- [ ] Residual risk statement

### Recall Checks

- Why does Kerberoasting work even without compromising the domain controller?
- What does DCSync actually request, and why is replication a dangerous permission to hold?
- Why is a tiered administration model more effective than simply using strong passwords?
- Why is lateral movement often easier inside AD than the initial compromise?

### Exit Criteria

- [ ] Domain lab built and isolated per the Lab Extension Protocol.
- [ ] Pass-the-Hash, Kerberoasting, and DCSync each demonstrated and documented.
- [ ] At least one full attack path to Domain Admin documented.
- [ ] AD Attack Path Report completed.

---

## 8. Module 2.4 — Secure Code Review

### Why This Matters

Architects must recognize insecure patterns before deployment, not only after exploitation.

### Mechanism

Code review traces untrusted input from sources to sensitive sinks while checking authentication, authorization, validation, cryptography, secrets, and error handling.

### Core Concepts

- Sources and sinks
- Taint flow
- Trust boundaries in code
- Dangerous APIs
- Error handling
- Secret handling
- Dependency risk
- Security tests
- Static analysis

### Hands-On Exercises

- [ ] Review a small vulnerable app manually.
- [ ] Trace one input from request to database.
- [ ] Find one missing authorization check.
- [ ] Find one unsafe string concatenation.
- [ ] Find one secret handling issue.
- [ ] Run static analysis.
- [ ] Write a custom Semgrep rule.
- [ ] Fix the issue and add a regression test.

### Mini Project — Secure Code Review Report

Deliver:

- [ ] Scope and commit hash
- [ ] Methodology
- [ ] Findings
- [ ] Exploitability
- [ ] Fix recommendations
- [ ] Secure code diffs
- [ ] Tests
- [ ] Architecture lessons

### Recall Checks

- What is a source?
- What is a sink?
- Why do tools not replace manual review?

---

## 9. Module 2.5 — Software Supply Chain Security

### Why This Matters

Modern systems depend on packages, containers, build pipelines, models, infrastructure modules, and generated artifacts. Attackers increasingly target the supply chain.

### Core Concepts

- Dependency confusion
- Typosquatting
- Malicious packages
- Lockfiles
- Software Bill of Materials
- Artifact signing
- Container image risk
- Build secrets
- CI/CD permissions
- Provenance

**SBOM — Software Bill of Materials:** an inventory of software components, dependencies, and versions used in an application.

**CI/CD — Continuous Integration / Continuous Delivery:** automated processes that build, test, and deploy software changes.

### Hands-On Exercises

- [ ] Generate an SBOM for a small project.
- [ ] Scan dependencies for known vulnerabilities.
- [ ] Scan a container image.
- [ ] Identify secrets in a fake repository.
- [ ] Review a build pipeline for overprivilege.
- [ ] Demonstrate dependency pinning.
- [ ] Write a dependency update policy.

### Defensive Controls

- Lockfiles
- Dependency review
- SBOM generation
- Artifact signing
- Least privilege CI/CD tokens
- Secret scanning
- Container scanning
- Provenance checks

### Mini Project — Supply Chain Risk Report

Analyze one small project and produce:

- [ ] SBOM
- [ ] Dependency risk summary
- [ ] Container risk summary if applicable
- [ ] Secret scan result
- [ ] Build pipeline risk review
- [ ] Remediation plan

### Recall Checks

- Why is a lockfile security-relevant?
- What does an SBOM help answer during an incident?
- Why are CI/CD tokens dangerous?

---

## 10. Module 2.6 — Binary Exploitation and Memory Safety Fundamentals

### Why This Matters

Even architects who do not specialize in exploit development need to understand memory safety because Rust, C/C++, parsers, blockchain clients, cryptography libraries, and low-level infrastructure depend on it.

### Core Concepts

- Stack and heap
- Buffer overflow
- Use-after-free concept
- Integer overflow
- Control flow hijacking
- ASLR
- DEP/NX
- Stack canaries
- Fuzzing
- Memory-safe languages

**ASLR — Address Space Layout Randomization:** a mitigation that randomizes memory addresses to make exploitation harder.

### Hands-On Exercises

- [ ] Compile and run a tiny vulnerable C program in an isolated lab.
- [ ] Trigger a controlled crash.
- [ ] Inspect registers and stack state.
- [ ] Explain why the crash happened.
- [ ] Recompile with mitigations and compare behavior.
- [ ] Fuzz a small parser.
- [ ] Compare C parser risk with Rust parser behavior.

### Defensive Controls

- Memory-safe languages
- Compiler hardening
- Fuzzing
- Bounds checks
- Safer APIs
- Code review of unsafe code

### Recall Checks

- Why do buffer overflows happen?
- What does a stack canary detect?
- Why does Rust reduce many memory bugs?

---

## 11. Module 2.7 — Reverse Engineering Fundamentals

### Why This Matters

Reverse engineering helps understand unknown binaries, malware behavior, closed-source clients, vulnerable firmware, blockchain clients, and suspicious tools.

### Core Concepts

- Static analysis
- Dynamic analysis
- Strings
- Symbols
- Assembly basics
- Control flow
- Function calls
- Decompilation
- Safe malware handling principles

### Hands-On Exercises

- [ ] Analyze a harmless crackme or toy binary.
- [ ] Extract strings.
- [ ] Identify main function behavior.
- [ ] Rename functions in a disassembler.
- [ ] Patch or reason through a simple branch.
- [ ] Write a short reverse engineering note.

### Defensive Controls

- Run unknown binaries only in isolated labs.
- Preserve hashes.
- Record behavior.
- Avoid internet exposure during analysis.

### Recall Checks

- What is the difference between static and dynamic analysis?
- Why are strings useful but insufficient?
- Why must unknown binaries be isolated?

---

## 12. Module 2.8 — Detection Engineering and Incident Response

### Why This Matters

Security architecture is incomplete without knowing how attacks are detected and handled.

### Core Concepts

- Logs
- Events
- Alerts
- Indicators of compromise
- Detection logic
- False positives
- False negatives
- Triage
- Containment
- Eradication
- Recovery
- Lessons learned

**IOC — Indicator of Compromise:** an observable artifact suggesting possible malicious activity, such as an IP address, file hash, process, or log pattern.

### Hands-On Exercises

- [ ] Generate benign and malicious-looking lab events.
- [ ] Write a detection rule for failed logins.
- [ ] Write a detection rule for suspicious web requests.
- [ ] Build an incident timeline from logs.
- [ ] Identify false positives.
- [ ] Write a containment plan.
- [ ] Write an incident runbook.

### SIEM, EDR, and Detection-as-Code

The exercises above teach detection logic conceptually. This subsection grounds it in real tooling: log aggregation, correlation rules, and EDR-style behavioral detection.

Core concepts:

- Log aggregation and normalization
- Correlation rules in a real SIEM (ELK/Elastic Security or Wazuh)
- EDR behavioral detection concepts (process trees, parent/child anomalies)
- Sigma rule format for portable detection logic
- Alert tuning methodology (reducing false positives without losing coverage)
- Detection-as-code (version-controlled, tested detection rules)

Hands-On Exercises:

- [ ] Deploy a local ELK stack or Wazuh instance.
- [ ] Ingest logs from at least one lab Linux host and one lab web application.
- [ ] Write a correlation rule for repeated authentication failures followed by a success (brute-force-then-success pattern).
- [ ] Write a Sigma rule for one detection from this module and convert it to your SIEM's native query language.
- [ ] Tune one rule to reduce a demonstrated false positive without losing the true positive.
- [ ] Store detection rules in version control with a test case per rule.
- [ ] Document one EDR-style behavioral detection concept (e.g., a web server process spawning a shell) even without a full EDR agent deployed.

### Mini Project — Attack-to-Detection Report

For one lab attack:

- [ ] Perform attack in isolated lab.
- [ ] Capture logs.
- [ ] Write detection logic.
- [ ] Trigger detection.
- [ ] Investigate event.
- [ ] Write timeline.
- [ ] Recommend prevention.

### Recall Checks

- What makes an alert actionable?
- What is the difference between detection and prevention?
- Why do false positives matter operationally?
- Why does detection-as-code reduce drift between what a SIEM is supposed to detect and what it actually detects?
- Why is alert tuning a continuous process rather than a one-time task?

---

## 13. Module 2.8b — Digital Forensics and Incident Investigation Tooling

### Why This Matters

Module 2.8 teaches detection logic and incident response process, but a real investigation needs forensic tooling: memory analysis, disk/artifact analysis, and timeline construction. Without this, "incident response" stays theoretical.

### Core Concepts

- Memory forensics fundamentals (process listing, network connections, injected code indicators)
- Disk and artifact forensics fundamentals (file timestamps, deleted file recovery concepts, browser/system artifacts)
- Timeline construction (log2timeline/Plaso concepts)
- Chain of custody
- Evidence integrity (hashing, write-blocking concepts)
- Volatile vs non-volatile evidence

### Hands-On Exercises

- [ ] Capture a memory image from a lab virtual machine using a Volatility-compatible acquisition method.
- [ ] Analyze the memory image with Volatility: list processes, network connections, and loaded modules.
- [ ] Identify one suspicious process or connection in a deliberately "infected" lab snapshot.
- [ ] Perform basic disk artifact review: file timestamps, recently modified files, simple log artifacts.
- [ ] Build a timeline from multiple log sources (system logs, application logs, memory analysis output) using log2timeline/Plaso concepts or a manual timeline if tooling is unavailable.
- [ ] Hash all evidence files and record hashes before and after analysis.
- [ ] Write a chain-of-custody log for one simulated investigation.

### Attack Surface (Investigative Challenges)

- Anti-forensics techniques (log clearing, timestamp manipulation)
- Volatile evidence lost on reboot or shutdown
- Evidence contamination from improper handling
- Incomplete log retention
- Encrypted or obfuscated artifacts

### Defensive / Procedural Controls

- Memory acquisition before shutdown when investigating live compromise
- Hashing evidence immediately upon acquisition
- Maintaining a documented chain of custody
- Centralized, tamper-resistant log retention
- Read-only analysis environments

### Mini Project — DFIR Investigation Report

Deliver:

- [ ] Scenario description
- [ ] Evidence acquired (memory image, disk artifacts, logs) with hashes
- [ ] Timeline of events
- [ ] Indicators of compromise identified
- [ ] Chain-of-custody log
- [ ] Findings and recommended containment/remediation steps

### Recall Checks

- Why must memory be captured before a compromised system is powered off?
- What does a hash of an evidence file prove, and what does it not prove?
- Why does a timeline built from multiple log sources reveal more than any single log?
- What is the purpose of a chain-of-custody log even in a personal lab exercise?

### Exit Criteria

- [ ] Memory image captured and analyzed.
- [ ] Timeline built from at least two evidence sources.
- [ ] Chain-of-custody log completed.
- [ ] DFIR Investigation Report completed.

---

## 14. Module 2.9 — Secure Engineering, SSDLC, and DevSecOps Pipeline Engineering

### Why This Matters

Principal architects design systems and processes that prevent classes of bugs, not only individual findings.

**SSDLC — Secure Software Development Life Cycle:** integrating security into planning, design, coding, testing, deployment, and maintenance.

### Core Concepts

- Security requirements
- Threat modeling during design
- Secure coding standards
- Code review
- Security testing
- Dependency management
- Secrets management
- Deployment controls
- Monitoring requirements
- Security acceptance criteria

### Hands-On Exercises

- [ ] Write security requirements for a small app.
- [ ] Add security acceptance criteria to user stories.
- [ ] Write a pre-merge security checklist.
- [ ] Add a security test for an authorization bug.
- [ ] Write a deployment risk checklist.
- [ ] Create a secure design review template.

### Architecture Exercise

- [ ] Convert three vulnerabilities from this phase into architecture patterns that would prevent recurrence.

### DevSecOps Pipeline Toolchain

SSDLC concepts are necessary but not sufficient without real tooling integrated into a pipeline. This subsection builds a working, hands-on DevSecOps pipeline across every major control category.

**Secret scanning**

- [ ] Run truffleHog or git-secrets against a lab repository with a deliberately committed test secret.
- [ ] Add secret scanning as a pre-commit hook so the secret is caught before commit.

**Static Application Security Testing (SAST)**

- [ ] Run Semgrep against a lab codebase using existing rules plus one custom rule from Module 2.4.
- [ ] Run Bandit against a Python lab project and triage findings.

**Dynamic Application Security Testing (DAST)**

- [ ] Run OWASP ZAP against a local vulnerable web app in baseline scan mode.
- [ ] Run Nuclei against the same target with a curated template set.
- [ ] Compare DAST findings with the manual findings from Module 2.1.

**Container and Infrastructure-as-Code scanning**

- [ ] Scan a lab container image with Trivy.
- [ ] Scan lab Terraform code with Checkov and tfsec.
- [ ] Fix at least one finding from each scanner and rescan.

**Secrets management**

- [ ] Stand up a local Vault instance or equivalent.
- [ ] Migrate one hardcoded lab secret into Vault-backed secret injection.
- [ ] Document the access policy for who/what can read the secret.

**CI/CD secure configuration**

- [ ] Build a lab pipeline in GitHub Actions or GitLab CI.
- [ ] Apply least-privilege tokens/permissions to the pipeline.
- [ ] Demonstrate pipeline isolation (no shared runners with unrelated secrets).
- [ ] Add a security gate that fails the build on a high-severity SAST/secret-scan finding.

**Pre-commit hooks and security gate design**

- [ ] Combine secret scanning, linting, and a fast SAST check into a single pre-commit hook chain.
- [ ] Define gate vs guardrail for this pipeline (see Phase 6 Module 6.4 for the architecture-level distinction).

### Mini Project — DevSecOps Pipeline Build

Deliver:

- [ ] Working pipeline definition (YAML or equivalent) with each scanning stage
- [ ] Pre-commit hook configuration
- [ ] Vault or equivalent secrets management integration
- [ ] At least one fixed finding per tool category
- [ ] Pipeline permission/least-privilege review
- [ ] Security gate design document explaining what fails a build and why

### Recall Checks

- Why is threat modeling earlier cheaper than patching later?
- What belongs in security acceptance criteria?
- How does secure engineering reduce repeat findings?
- Why does a security gate need a clear owner and override process?
- Why is least privilege for CI/CD tokens as important as least privilege for users?

---

## 15. Phase 2 Capstone — Attack, Defend, Detect, Redesign

Pick or build a vulnerable web/API application and complete the full cycle.

Required deliverables:

- [ ] Architecture diagram
- [ ] Threat model
- [ ] Vulnerability assessment report
- [ ] Exploit proof-of-concepts in isolated lab
- [ ] Secure code/config fixes
- [ ] Regression tests
- [ ] Detection rules
- [ ] Incident timeline
- [ ] Architecture recommendations
- [ ] ADRs for major security decisions

---

## 16. Recall and Interleaving Plan

Before exiting this phase, mix concepts:

- [ ] SQL injection + code review + detection logs
- [ ] API authorization + Zero Trust identity preview
- [ ] SSRF + cloud metadata preview
- [ ] JWT validation + OIDC preview
- [ ] Active Directory privilege escalation + Zero Trust identity preview
- [ ] DFIR timeline construction + detection engineering
- [ ] Supply chain + AI model supply chain preview
- [ ] Memory safety + Rust/blockchain client preview

Teach-back prompts:

- [ ] Explain one vulnerability from root cause to architecture fix.
- [ ] Explain how you would detect the attack.
- [ ] Explain how SSDLC prevents repeat issues.
- [ ] Explain one Active Directory attack path end to end.

---

## 17. Phase 2 Exit Criteria

- [ ] Every important vulnerability class has hands-on evidence.
- [ ] Attack and defense are paired for each major topic.
- [ ] Detection evidence exists for at least three attacks.
- [ ] Active Directory attack path report completed.
- [ ] DFIR investigation report completed.
- [ ] Secure code review report completed.
- [ ] Supply chain risk report completed.
- [ ] DevSecOps pipeline build completed.
- [ ] Phase capstone completed.
- [ ] Recall checks passed without notes.
- [ ] Mistake log updated.

### Validation (External Calibration — Optional)

Not required to complete the phase, but a useful calibration checkpoint before moving on:

- [ ] HackTheBox Starting Point rooms and TryHackMe Linux/Networking/Web fundamentals paths (carried over from Phase 1).
- [ ] HackTheBox Web challenges.
- [ ] PentesterLab web vulnerability exercises.