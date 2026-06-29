# Portfolio Strategy

> Defines which capstone outputs are portfolio artifacts, how to prepare them for public exposure, and how to frame them for different audiences and hiring contexts.

---

## 1. Portfolio Artifacts by Phase

Not every capstone deliverable belongs on a public portfolio. The criteria for inclusion: the artifact demonstrates a distinct skill at a level that differentiates you, can be sanitized without gutting its technical content, and tells a coherent story when read alone.

### Phase 1 — Foundation Security Toolkit

**Include:**
- Linux System Auditor (Go or Python): demonstrates practical OS security tooling and structured output.
- Go Network Mapper or Service Probe: demonstrates networked tooling, timeout handling, and structured JSON output.
- Rust Safe Config Parser: demonstrates memory-safe parsing, malformed input handling, and fuzz testing discipline.
- Small System Threat Model: demonstrates threat modeling methodology applied to a real system.

**Framing:** These are foundational tools, not research. Present them as evidence of engineering discipline: clean code, tests, documented security assumptions. Avoid overselling scope.

---

### Phase 2 — Core Security Engineering

**Include:**
- Secure Code Review Report: a professional finding document is a direct signal for security engineer roles.
- Attack-to-Detection Report: demonstrates the full attack/defense/detect cycle. This is rare in junior portfolios.
- Web Vulnerability Assessment Package: include only if the findings write-up is professional quality, not a tool output dump.

**Exclude from public GitHub:**
- Raw exploit proof-of-concept code against real-looking targets. Abstract to lab-only contexts with clear synthetic labels.

**Framing:** These demonstrate the security engineering mindset: not just finding bugs but understanding root cause, writing fixes, and building detection. The write-up quality matters as much as the technical content.

---

### Phase 3 — Distributed Zero Trust Platform

**Include:**
- Zero Trust Microservices Lab: the full lab with mTLS, policy-as-code, attack simulation, and blast-radius analysis is a strong differentiator.
- Kubernetes Attack and Hardening Lab: include the diff between vulnerable and hardened configs plus the detection note.
- ADR set: publish three to five ADRs from the capstone as a standalone document. Architecture decision reasoning is a direct principal-level signal.

**Framing:** Frame these around the architecture problem, not the tool. "I built a Zero Trust service mesh" is weaker than "I designed a minimal-blast-radius authorization architecture for three services, chose policy-as-code over embedded checks for this reason, and demonstrated what an attacker can and cannot do after gaining one service credential."

---

### Phase 4 — Blockchain and Web3 Security

**Include:**
- Smart Contract Exploit/Fix Library: a structured library of vulnerable contracts, exploit tests, fixed versions, and audit notes is a direct auditor portfolio artifact.
- Bridge Threat Model: a complete bridge threat model with trust assumptions, attack paths, and controls is uncommon public work.
- Competitive Audit Report (from Module 4.5b): a submitted Code4rena or Sherlock finding — or a shadow audit written in competition report format — is the highest-signal artifact for the smart contract auditor path.

**Framing for audit roles:** The competitive audit report or shadow audit is the primary hiring signal, not the lab exercises. Labs demonstrate you understand the mechanisms. A report demonstrates you can find real issues in production code and communicate findings professionally.

---

### Phase 5 — AI Security

**Include:**
- LLM Red Team Suite: a structured test suite with payloads, results, and a findings report demonstrates methodology, not just tool use.
- Secure RAG Assessment: threat model plus hands-on attack results is uncommon public work.
- AI Security Triage Assistant prototype: demonstrates integration of AI tooling into a security workflow with appropriate guardrails. Strong differentiator for roles at the intersection of AI and security.

**Exclude:**
- Adversarial ML experiments that reproduce well-known attacks without adding analysis. Only include if you have a non-trivial finding or design decision to explain.

**Framing:** AI security is crowded with surface-level prompt injection demos. Differentiate by showing guardrail design, evaluation methodology, and explicit human-in-the-loop decisions. Frame around what you chose not to automate and why.

---

### Phase 6 — Final Capstone

**Include entire package:**
- Final architecture package (context diagram, component diagram, trust boundary diagram, threat model, risk register, ADR set).
- Attack simulation report.
- Executive summary and technical design review as separate documents.

**This is your anchor artifact.** Every other portfolio item can reference it. Job applications for senior or principal roles should link this directly.

---

## 2. How to Sanitize Lab Work for Public GitHub

**Remove entirely:** real IP addresses, real domain names that could be confused for targets, API keys or credentials even if test-only, any content derived from real production systems.

**Replace with synthetic labels:** `target.lab`, `192.168.100.x`, `test-user@example.com`, `TEST_API_KEY_PLACEHOLDER`.

**Add a lab disclaimer to each README:** One sentence stating the system is an intentional lab environment built for security learning. This protects you and makes the purpose clear.

**Keep:** actual exploit code in lab exercises is fine to publish when clearly labeled as synthetic lab targets. Proof-of-concept code that exploits a specific named CVE against a named product is borderline — publish the analysis and the detection logic, not a ready-to-run exploit against production systems.

---

## 3. Document Types and When to Use Each

**Technical write-up:** A walkthrough of what you built, how you attacked it, what you found, and what the architecture lesson is. Audience is a senior engineer. Length: 500-1500 words. Used for: lab capstones, CTF writeups, individual vulnerability explanations.

**Audit report:** A professional finding document structured as: scope, methodology, findings (each with title, severity, description, proof of concept, recommendation), and conclusion. Audience is a client or development team. Used for: smart contract audit work, competitive audit submissions, shadow audits.

**Security architecture document:** A complete design package with diagrams, threat model, ADRs, and risk register. Audience is a technical architect or principal engineer. Used for: Phase 6 capstone, reference architectures, design reviews.

**Executive summary:** One page, no jargon. States what system was reviewed, what the top three risks are, and what the recommended priority actions are. Audience is a non-technical decision-maker. Used for: Phase 6 communication exercises, as a cover document for any architecture package.

---

## 4. Professional README Structure for Portfolio Repositories

Every public portfolio repository should have a README with this structure:

```markdown
# [Project Name]

## What this is
One sentence. No jargon.

## What it demonstrates
Two to four bullet points. Each bullet names a specific skill or decision.

## Architecture
One paragraph. Reference the diagram if it exists.

## Security decisions
The two or three most interesting security choices made, with brief rationale.

## How to run
Prerequisites. Steps. Expected output.

## Lab disclaimer
This system is an intentional lab environment built for security learning and research.
```

---

## 5. How Competitive Audit Reports Function as Portfolio Pieces

Code4rena and Sherlock publish audit competition findings publicly after judging. A submitted finding — valid or not — is a public artifact with your handle attached to the report. High-severity valid findings are direct hiring signals for smart contract auditor roles.

If you are not yet submitting to competitions, shadow audits work: take a protocol that has had a public audit, audit it yourself before reading the report, write your findings in competition report format, then compare against the real report. Publish the shadow audit with a note that it is a learning exercise.

The value of either artifact: it demonstrates that you can find vulnerabilities in code you did not write, under realistic constraints, and communicate findings in a format that clients and judges evaluate professionally. No lab exercise replicates this signal.

---

## 6. Framing for Hiring Contexts

**CyberSec Engineer roles:** Emphasize Phase 2 and Phase 3 artifacts. Detection logic, secure code review, and Zero Trust lab work are directly relevant. The threat model and ADR set demonstrate architecture thinking above the typical engineer level.

**DevSec Engineer roles:** Emphasize Phase 2 Module 2.9 (DevSecOps pipeline work), supply chain artifacts, and the policy-as-code and IaC scanning work from Phase 3. Show working pipeline integrations, not just concepts.

**Smart Contract Auditor roles:** The competitive audit report or shadow audit is the primary artifact. Supplement with the exploit/fix library and bridge threat model. Show the full attack-to-detection cycle, not just bug-finding.

**Principal Security Architect roles:** The Phase 6 final capstone package is the primary artifact. Supplemented by ADR sets from earlier phases and the reference architecture set. Domain depth across AI/ML security, blockchain, and distributed systems is itself a differentiator — frame it as cross-domain architectural judgment, not a list of topics covered.
