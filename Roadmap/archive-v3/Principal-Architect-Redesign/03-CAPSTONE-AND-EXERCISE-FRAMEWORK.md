# Capstone and Exercise Framework

> This file defines how hands-on work is designed across the redesigned roadmap. Every important concept gets practice, and every major area gets integrated projects.

---

## 1. Exercise Principle

Every important concept must produce action.

No concept should remain only as:

- definition
- reading
- tool name
- passive note
- memorized fact

Each concept needs at least one exercise that forces the learner to use it.

---

## 2. Exercise Types

| Type | Purpose | Example |
|---|---|---|
| Micro exercise | Practice one small mechanism. | Decode a JSON Web Token and identify claims. |
| Trace exercise | Walk through a flow step by step. | Trace Transport Layer Security handshake messages in Wireshark. |
| Build exercise | Implement a small working component. | Write a Go TCP echo service with structured logs. |
| Break exercise | Demonstrate safe failure or abuse. | Exploit missing object authorization in a lab API. |
| Defend exercise | Implement prevention or hardening. | Add object ownership checks to the API. |
| Detect exercise | Identify telemetry or write detection. | Write a rule for repeated authorization failures. |
| Debug exercise | Diagnose root cause. | Find why mutual Transport Layer Security fails between two services. |
| Architecture exercise | Design or document. | Draw trust boundaries and write an Architecture Decision Record. |
| Recall exercise | Prevent forgetting. | Explain Kerberos ticket flow without notes. |
| Teach-back exercise | Prove understanding. | Teach consensus failure modes in plain language. |

---

## 3. Exercise Design Rules

Each exercise should include:

- [ ] Objective
- [ ] Prerequisites
- [ ] Setup
- [ ] Task
- [ ] Expected observation
- [ ] Why it works mechanically
- [ ] Security relevance
- [ ] Defensive counterpart
- [ ] Detection or telemetry note
- [ ] Recall question

If a command is included in a final roadmap exercise, it must be broken down into:

- [ ] Tool or binary
- [ ] Each flag
- [ ] Each argument
- [ ] Each operator
- [ ] Expected output

---

## 4. Project Scale

| Scale | Use Case | Output |
|---|---|---|
| Exercise | One concept or mechanism. | Short note, screenshot/output, recall answer. |
| Mini project | Small integrated skill cluster. | Small tool, lab, or report. |
| Module project | End of module integration. | Working system plus security notes. |
| Phase capstone | End of phase synthesis. | Code, report, architecture artifact, attack/defense evidence. |
| Final capstone | Principal-role proof. | Full architecture package and working distributed platform. |

---

## 5. Required Artifact Types

Across the roadmap, the learner should repeatedly produce:

- [ ] Source code
- [ ] Test cases
- [ ] Exploit proof-of-concepts for isolated labs
- [ ] Defensive configurations
- [ ] Detection rules
- [ ] Log analysis notes
- [ ] Threat models
- [ ] Architecture diagrams
- [ ] Architecture Decision Records
- [ ] Risk registers
- [ ] Incident response runbooks
- [ ] Executive summaries
- [ ] Technical reports

---

## 6. Phase-Level Capstone Expectations

## Phase 0 — Secure Lab and Cyber Range

Capstone idea:

> Build a local cyber range with isolated networks, vulnerable services, identity lab, Kubernetes lab, blockchain devnet, AI lab, and centralized logging.

Evidence:

- [ ] Network diagram
- [ ] Isolation proof
- [ ] Lab inventory
- [ ] Snapshot/restore plan
- [ ] Logging pipeline proof
- [ ] Safety rules

## Phase 1 — Deep Technical Foundations

Capstone idea:

> Build a foundation toolkit with Linux auditing, packet tracing, cryptography checks, and small Python/Go/Rust utilities.

Evidence:

- [ ] Python security script
- [ ] Go network service or scanner
- [ ] Rust parser or validation tool
- [ ] Packet analysis report
- [ ] Cryptography misuse report
- [ ] Threat model for one small system

## Phase 2 — Core Security Engineering

Capstone idea:

> Assess, exploit, defend, and monitor a vulnerable web/API application.

Evidence:

- [ ] Vulnerability report
- [ ] Exploit reproduction
- [ ] Secure code fixes
- [ ] Authorization design
- [ ] Detection rules
- [ ] Incident timeline
- [ ] Secure Software Development Life Cycle notes

## Phase 3 — Distributed, Cloud, and Zero Trust Systems

Capstone idea:

> Build a distributed microservice platform with identity-aware access, policy-as-code authorization, mutual Transport Layer Security, Kubernetes deployment, and distributed tracing.

Evidence:

- [ ] Go services
- [ ] Kubernetes manifests
- [ ] Policy-as-code rules
- [ ] Service identity proof
- [ ] Attack simulation
- [ ] Hardening report
- [ ] Zero Trust architecture diagram
- [ ] Architecture Decision Records

## Phase 4 — Blockchain and Web3 Security Architecture

Capstone idea:

> Build and assess a small blockchain or blockchain-integrated system using Go/Rust, then perform smart contract, node, validator, bridge, oracle, and key-management threat analysis.

Evidence:

- [ ] Go or Rust blockchain component
- [ ] Smart contract exploit/fix library
- [ ] Consensus or peer-to-peer failure simulation
- [ ] Validator hardening checklist
- [ ] Bridge threat model
- [ ] Protocol security review
- [ ] Key management architecture

## Phase 5 — AI Security and AI-Driven Defense

Capstone idea:

> Build a secure AI-assisted security operations prototype that ingests logs, detects anomalies, summarizes alerts, and enforces human-in-the-loop guardrails.

Evidence:

- [ ] Secure Retrieval-Augmented Generation or Large Language Model application
- [ ] Prompt injection tests
- [ ] Model supply chain checks
- [ ] Log anomaly pipeline
- [ ] Alert triage prototype
- [ ] Guardrail evaluation
- [ ] AI red team report
- [ ] False positive/false negative analysis

## Phase 6 — Principal Secure Architecture Synthesis

Capstone idea:

> Design and build a secure distributed trust platform combining Zero Trust service identity, blockchain-style auditability, AI-assisted detection, policy-as-code, telemetry, and incident response.

Evidence:

- [ ] Working distributed platform
- [ ] Infrastructure code
- [ ] Security architecture diagrams
- [ ] Threat model
- [ ] Risk register
- [ ] Architecture Decision Records
- [ ] Attack simulation report
- [ ] Detection and response runbooks
- [ ] Executive summary
- [ ] Technical design review

---

## 7. Exercise Quality Checklist

Before adding an exercise to a phase, verify:

- [ ] It teaches a specific important mechanism.
- [ ] It is safe and legal in a local or authorized environment.
- [ ] It includes attack and defense when security-relevant.
- [ ] It has an observable result.
- [ ] It can be repeated.
- [ ] It produces evidence.
- [ ] It includes recall prompts.
- [ ] It connects to later roadmap topics.

---

## 8. Anti-Busywork Rule

Hands-on does not mean random tasks.

Avoid exercises that:

- [ ] Do not teach a mechanism.
- [ ] Only copy-paste commands.
- [ ] Produce no evidence.
- [ ] Have no defensive or architectural lesson.
- [ ] Are disconnected from the final role.

Every exercise must earn its place.
