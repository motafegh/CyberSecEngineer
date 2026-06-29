# Capstone Index

> Central index of all major hands-on deliverables across the roadmap. The detailed capstone spec for each phase lives in that phase's file (`PHASE-N-*.md` → search for "Capstone"). This index is the cross-phase checklist.

---

## Phase 0 — Secure Lab and Cyber Range

See `PHASE-0-SECURE-LAB.md` §15.

**Required components:**
- [ ] Host workstation safety plan
- [ ] Virtualization layer
- [ ] Linux attack/defense workstation
- [ ] Vulnerable target zone
- [ ] Telemetry/evidence zone
- [ ] Documentation system

**Required artifacts:**
- [ ] Architecture diagrams
- [ ] Lab threat model
- [ ] Connectivity matrix
- [ ] Asset inventory
- [ ] Snapshot/restore plan
- [ ] Safety rules
- [ ] First Architecture Decision Record
- [ ] Isolation verification report

> Domain-specific zones (Windows identity, container/Kubernetes, blockchain, AI) are deferred — added later via the Lab Extension Protocol immediately before the phase that requires them.

---

## Phase 1 — Deep Technical Foundations

See `PHASE-1-DEEP-FOUNDATIONS.md` §13.

**Required deliverables:**
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

## Phase 2 — Core Security Engineering

See `PHASE-2-CORE-SECURITY-ENGINEERING.md` §15.

**Required deliverables:**
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

## Phase 3 — Distributed, Cloud, and Zero Trust Systems

See `PHASE-3-DISTRIBUTED-CLOUD-ZEROTRUST.md` §12.

**Required system:**
- [ ] At least three services, preferably in Go
- [ ] Containerized deployment
- [ ] Local Kubernetes deployment
- [ ] Service identities
- [ ] mTLS or equivalent authenticated service communication
- [ ] Policy-as-code authorization
- [ ] Network restrictions
- [ ] Structured logs
- [ ] Metrics and traces
- [ ] Failure simulation
- [ ] Attack simulation

**Required artifacts:**
- [ ] System context diagram
- [ ] Component diagram
- [ ] Trust boundary diagram
- [ ] Threat model
- [ ] Risk register
- [ ] ADRs
- [ ] Attack/defense report

---

## Phase 4 — Blockchain and Web3 Security Architecture

See `PHASE-4-BLOCKCHAIN-WEB3-SECURITY-ARCHITECTURE.md` §14.

**Required technical work:**
- [ ] Go blockchain or peer-to-peer component
- [ ] Rust parser/validator or blockchain component
- [ ] Solidity exploit/fix library subset, with Slither/Foundry/Echidna tool output
- [ ] Oracle or bridge simulation
- [ ] Validator/key-management design
- [ ] MEV or governance risk simulation

**Required artifacts:**
- [ ] System context diagram
- [ ] Protocol/component diagram
- [ ] Trust boundary diagram
- [ ] Threat model
- [ ] Risk register
- [ ] Key management architecture
- [ ] Attack simulation report
- [ ] Detection/monitoring plan
- [ ] Architecture recommendations
- [ ] ADRs

---

## Phase 5 — AI Security and AI-Driven Defense

See `PHASE-5-AI-SECURITY-AI-DRIVEN-DEFENSE.md` §11.

**Required system:**
- [ ] Log ingestion
- [ ] Detection or anomaly logic
- [ ] LLM-assisted alert explanation
- [ ] Evidence links
- [ ] Human approval gate
- [ ] Guardrail policy
- [ ] Prompt/output/tool logs
- [ ] Evaluation set
- [ ] False positive/false negative tracking

**Required security assessment:**
- [ ] AI system architecture diagram
- [ ] Threat model
- [ ] Prompt injection tests
- [ ] RAG poisoning tests if RAG is used
- [ ] Model supply chain review
- [ ] Tool abuse tests if tools are used
- [ ] Privacy risk review
- [ ] Incident runbook
- [ ] ADRs

---

## Phase 6 — Principal Secure Architecture Synthesis

See `PHASE-6-PRINCIPAL-SECURE-ARCHITECTURE.md` §11.

**Required system capabilities:**
- [ ] Distributed services, preferably Go-based
- [ ] At least one Rust security-critical component or parser/validator
- [ ] Service identity with mTLS or equivalent
- [ ] Policy-as-code authorization
- [ ] Kubernetes or local cloud-native deployment
- [ ] Structured logs, metrics, and traces
- [ ] Blockchain-style auditability or blockchain integration
- [ ] AI-assisted detection or triage
- [ ] Human approval for high-impact AI-assisted actions
- [ ] Attack simulation paths
- [ ] Defensive controls
- [ ] Incident runbooks

**Required artifacts (full architecture package):**
- [ ] System context diagram
- [ ] Component diagram
- [ ] Trust boundary diagram
- [ ] Threat model
- [ ] Risk register
- [ ] ADRs
- [ ] Attack simulation report
- [ ] Executive summary
- [ ] Technical design review document

> This is the **anchor artifact** for principal-level applications. Every earlier portfolio item should reference back to it.

---

## Artifact Quality Rule

No capstone is complete unless it includes, where applicable:

- [ ] Working code or reproducible lab
- [ ] Security analysis
- [ ] Attack simulation or abuse case
- [ ] Defensive controls
- [ ] Detection/telemetry notes
- [ ] Architecture diagram
- [ ] Threat model
- [ ] Risk or residual risk statement
- [ ] Recall questions

Reading without artifact output is supporting work, not completion.
