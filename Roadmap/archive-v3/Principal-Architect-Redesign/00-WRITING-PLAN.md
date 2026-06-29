# Roadmap Redesign Writing Plan

> Purpose: This file is the governing plan for redesigning the roadmap toward **Principal Secure Distributed Systems Architect**, focusing on blockchain, Artificial Intelligence-driven security, and Zero Trust networks. It exists so we do not forget the design principles while writing or modifying the roadmap.

---

## 0. Acronym and Term Baseline

Use these definitions the first time they appear in each roadmap/session file.

| Term | Meaning |
|---|---|
| **AI — Artificial Intelligence** | Software systems that perform tasks normally requiring human reasoning, perception, or decision-making. |
| **ML — Machine Learning** | A subset of AI where models learn patterns from data instead of being directly programmed for every rule. |
| **LLM — Large Language Model** | A large AI model trained on text/code that predicts and generates language-like output. |
| **Zero Trust** | Security model where no user, device, network, or workload is trusted by default; access is continuously verified. |
| **Distributed system** | A system made of multiple networked components that must coordinate despite latency, partial failure, and inconsistent views. |
| **Blockchain** | A distributed ledger where participants agree on ordered state transitions through consensus and cryptographic verification. |
| **ADR — Architecture Decision Record** | A short document explaining a design decision, options considered, tradeoffs, and final rationale. |
| **IAM — Identity and Access Management** | Controls for who/what can access which resources, under what conditions. |
| **mTLS — mutual Transport Layer Security** | TLS where both client and server authenticate each other, commonly used for service-to-service trust. |
| **OPA — Open Policy Agent** | A policy-as-code engine used to make authorization and compliance decisions consistently. |
| **IaC — Infrastructure as Code** | Defining infrastructure using version-controlled code instead of manual configuration. |
| **SBOM — Software Bill of Materials** | Inventory of software components, dependencies, and versions used in an application. |
| **SSDLC — Secure Software Development Life Cycle** | Integrating security into software planning, design, coding, testing, deployment, and maintenance. |
| **RAG — Retrieval-Augmented Generation** | LLM pattern where external documents are retrieved and inserted into model context before answering. |
| **MEV — Maximal Extractable Value** | Value extracted by reordering, inserting, or censoring blockchain transactions. |

---

## 1. Final Target Role

**Principal Secure Distributed Systems Architect**

Focus areas:

- Blockchain systems and protocol security
- AI-driven security systems and AI system security
- Zero Trust network and identity architecture
- Cloud-native and distributed platform security
- Security architecture leadership and tradeoff reasoning

One-sentence target definition:

> Design, break, defend, operate, and explain secure distributed platforms where blockchain trust, AI-driven defense, and Zero Trust identity controls work together under real operational constraints.

---

## 2. Non-Negotiable Design Rules

### 2.1 Redesign, Do Not Patch

- [x] Treat the existing roadmap as source material, not as automatically sufficient.
- [ ] Audit every existing roadmap file before deciding whether to keep, expand, move, or replace it.
- [ ] Rewrite weak sections instead of adding superficial paragraphs.
- [ ] Preserve useful existing work where it is strong.
- [ ] Avoid claiming coverage unless the roadmap includes mechanisms, hands-on work, defensive controls, and quality gates.

### 2.2 Security Is the Dominant Lens

Every technical area must include:

- [ ] How the system works internally
- [ ] How it fails
- [ ] How attackers exploit it
- [ ] How defenders prevent it
- [ ] How defenders detect abuse
- [ ] How responders contain and recover
- [ ] How architects design it safely from the beginning
- [ ] How operators monitor and maintain it under real-world constraints

Security must not be a separate afterthought. It must shape every phase.

### 2.3 Every Important Concept Gets Hands-On Work

Not only major modules — every important concept, even if small or apparently trivial, must have at least one practical exercise.

Each important concept should have one or more of:

- [ ] Micro exercise — focused task for one mechanism
- [ ] Attack exercise — demonstrate failure or abuse
- [ ] Defense exercise — implement prevention, detection, or hardening
- [ ] Build exercise — create a small working component
- [ ] Debug exercise — inspect failure state and explain root cause
- [ ] Architecture exercise — diagram, threat model, or ADR
- [ ] Teach-back exercise — explain the mechanism without notes

### 2.4 Quality Gates Replace Timelines

The redesigned roadmap must avoid fixed deadlines and calendar promises.

Use:

- [ ] Prerequisites
- [ ] Learning outcomes
- [ ] Required mechanisms
- [ ] Hands-on exercises
- [ ] Mini projects
- [ ] Capstones
- [ ] Architecture artifacts
- [ ] Exit criteria
- [ ] Recall checks

Avoid:

- [ ] Artificial month/week estimates as success criteria
- [ ] Job-hunt deadlines as roadmap structure
- [ ] Rushing foundational concepts because they are not directly in the final title

### 2.5 Rust and Go Are First-Class Languages

Blockchain and distributed systems programming must primarily use:

- [ ] **Rust** for secure systems programming, cryptography-adjacent code, high-assurance components, Solana/Substrate-style ecosystems, and memory-safety reasoning.
- [ ] **Go** for distributed services, peer-to-peer networking, cloud-native infrastructure, Kubernetes-adjacent tooling, and Cosmos/Ethereum-client-style systems.

Supporting languages:

- [ ] Python for security automation, AI workflows, testing, exploit proof-of-concepts, and tooling.
- [ ] Solidity for Ethereum smart contract security and Decentralized Finance security literacy.
- [ ] TypeScript where needed for Web3 tooling, wallet interfaces, and modern application attack surfaces.

### 2.6 Foundations Must Be Direct but Not Narrow

The roadmap must stay direct, but it must not skip or downweight important context just because it is not named in the final position.

Do not skip:

- [ ] Operating systems
- [ ] Linux internals and permissions
- [ ] Windows and Active Directory identity concepts
- [ ] Networking and packet analysis
- [ ] Cryptography and key management
- [ ] Web and API security
- [ ] Authentication and authorization
- [ ] Secure coding and code review
- [ ] Binary exploitation and memory safety fundamentals
- [ ] Reverse engineering fundamentals
- [ ] Detection engineering
- [ ] Incident response
- [ ] Software supply chain security
- [ ] Cloud and Kubernetes fundamentals

These are not distractions. They are the substrate for principal-level architecture.

---

## 3. Neuroscience-Informed Learning Design

The roadmap must be designed for retention, transfer, and usable skill — not passive reading.

### 3.1 Retrieval Before Review

Before reviewing a previous concept, ask the learner to recall it first.

Pattern:

1. Close notes.
2. Explain the concept from memory.
3. Draw the mechanism or attack path.
4. Compare against notes.
5. Correct gaps.

### 3.2 Spaced Recall

Important concepts must reappear after delay and in new contexts.

Use flexible spacing instead of strict dates:

- [ ] Same learning unit: immediate recall after the chunk
- [ ] Next related unit: quick dependency recall
- [ ] Several units later: mixed recall
- [ ] Phase exit: cumulative recall
- [ ] Later phase: just-in-time recall before dependent material

### 3.3 Interleaving

Do not isolate topics forever. Mix related concepts so transfer improves.

Examples:

- [ ] Networking + Transport Layer Security + packet capture
- [ ] Identity + API authorization + Zero Trust
- [ ] Rust memory safety + binary exploitation concepts
- [ ] Blockchain consensus + distributed systems failure modes
- [ ] RAG security + data poisoning + access control

### 3.4 Generation Effect

Learner should attempt before seeing the final answer.

Examples:

- [ ] Predict the packet sequence before opening Wireshark.
- [ ] Draft a threat model before reading a reference model.
- [ ] Write an authorization policy before comparing to a secure version.
- [ ] Sketch a blockchain bridge trust model before studying real bridge failures.

### 3.5 Elaboration and Mechanism Linking

Every new idea should connect to prior knowledge and future use.

For each learning unit:

- [ ] What problem does this solve?
- [ ] Where does it sit in the attack/defense surface?
- [ ] What are the moving parts?
- [ ] What breaks if one part is misconfigured?
- [ ] What prior concept does it depend on?
- [ ] What later topic will reuse it?

### 3.6 Desirable Difficulty

Exercises should gradually increase difficulty, not remain toy-level.

Progression:

1. Guided exercise
2. Fill-in-the-gap exercise
3. Independent reproduction
4. Variant scenario
5. Adversarial scenario
6. Architecture/design scenario
7. Teach-back without notes

### 3.7 Error Log and Misconception Tracking

Mistakes are learning data.

Each phase should maintain:

- [ ] Common mistakes
- [ ] Personal mistake log
- [ ] Misconception corrections
- [ ] Recall gaps
- [ ] Remediation exercises

### 3.8 Dual Coding

Use text plus visual structure.

Required visuals where useful:

- [ ] Packet flow diagrams
- [ ] Trust boundary diagrams
- [ ] Attack chain diagrams
- [ ] Identity flow diagrams
- [ ] Blockchain consensus diagrams
- [ ] AI pipeline diagrams
- [ ] Zero Trust architecture diagrams

---

## 4. Standard Unit Template

Every important roadmap unit should follow this template.

```markdown
## Unit Name

### Why This Matters

### Mechanism

### Attack Surface

### Defensive Controls

### Detection and Telemetry

### Hands-On Exercises
- [ ] Micro exercise
- [ ] Attack exercise
- [ ] Defense exercise
- [ ] Architecture exercise

### Mini Project, If Applicable

### Recall Checks

### Exit Criteria
```

This template may be shortened for tiny units, but no important concept should be left as passive reading only.

---

## 5. Standard Phase Template

Each phase should include:

```markdown
# Phase N — Name

## Purpose

## Prerequisites

## Outcomes

## Modules

## Hands-On Exercise Index

## Mini Projects

## Capstone

## Architecture Artifacts

## Recall and Review Plan

## Exit Criteria

## Common Failure Modes

## Links to Related Phases
```

---

## 6. Proposed New Roadmap Architecture

The redesigned roadmap should move from time-based tracks to quality-gated capability phases.

```text
ROADMAP-INDEX.md
├── PHASE-0-SECURE-LAB.md
├── PHASE-1-FOUNDATIONS.md
├── PHASE-2-CORE-SECURITY.md
├── PHASE-3-DISTRIBUTED-CLOUD-ZEROTRUST.md
├── PHASE-4-BLOCKCHAIN-WEB3-ARCHITECTURE.md
├── PHASE-5-AI-SECURITY-AI-DRIVEN-DEFENSE.md
├── PHASE-6-PRINCIPAL-SECURE-ARCHITECT.md
├── ARCHITECTURE-SPINE.md
├── CAPSTONE-INDEX.md
├── QUALITY-GATES.md
├── REFERENCE-TOOLS.md
├── REFERENCE-RESOURCES.md
└── REFERENCE-ARCHITECTURES.md
```

The current Phase 4 job-hunt file should be reduced or converted into an evidence-quality file, not used as a deadline driver.

---

## 7. Existing Roadmap Audit Method

Each existing file must be reviewed with this status:

| Decision | Meaning |
|---|---|
| **Keep** | Strong and aligned; minor edits only. |
| **Expand** | Correct but too shallow for the new target. |
| **Move** | Useful content, wrong location/order. |
| **Replace** | Too narrow, outdated, or insufficient. |

Audit checklist:

- [ ] Does it teach mechanism, not just tool use?
- [ ] Does it pair attack and defense?
- [ ] Does it include hands-on exercises for every important concept?
- [ ] Does it include detection and operational response?
- [ ] Does it include architecture artifacts where appropriate?
- [ ] Does it use quality gates instead of time pressure?
- [ ] Does it support the final target role?
- [ ] Does it preserve important adjacent foundations?

---

## 8. Writing Order

### Stage 1 — Design Guardrails

- [x] Create redesign folder.
- [x] Write this governing plan.
- [ ] Write target-role capability map.
- [ ] Write quality gates framework.
- [ ] Write capstone/project framework.

### Stage 2 — Master Structure

- [ ] Draft new roadmap index.
- [ ] Draft architecture spine.
- [ ] Draft phase dependency map.
- [ ] Draft exercise taxonomy.

### Stage 3 — Phase Drafts

- [ ] Draft Phase 0 — Secure Lab.
- [ ] Draft Phase 1 — Foundations.
- [ ] Draft Phase 2 — Core Security.
- [ ] Draft Phase 3 — Distributed, Cloud, and Zero Trust.
- [ ] Draft Phase 4 — Blockchain and Web3 Architecture.
- [ ] Draft Phase 5 — AI Security and AI-Driven Defense.
- [ ] Draft Phase 6 — Principal Secure Architecture.

### Stage 4 — Reference Files

- [ ] Rewrite tools reference.
- [ ] Rewrite resources reference.
- [ ] Add reference architectures.
- [ ] Add reading and lab selection criteria.

### Stage 5 — Integration Back Into Main Roadmap

- [ ] Compare new files against old files.
- [ ] Decide what to replace in `Roadmap/`.
- [ ] Preserve old content only where still valuable.
- [ ] Update links.
- [ ] Run final consistency pass.

---

## 9. Quality Bar

A section is not complete unless it answers:

- [ ] What does the learner need to understand?
- [ ] What can go wrong?
- [ ] How can it be attacked?
- [ ] How can it be defended?
- [ ] How can it be detected?
- [ ] How can it be designed correctly?
- [ ] What hands-on exercise proves the concept?
- [ ] What recall check prevents forgetting?
- [ ] What artifact proves real capability?

---

## 10. Things We Must Not Do

- [ ] Do not merely append new topics to old files and call it complete.
- [ ] Do not make the roadmap mostly passive reading.
- [ ] Do not reduce foundations just because they are not in the role title.
- [ ] Do not use fixed time estimates as success criteria.
- [ ] Do not make blockchain equal only Solidity.
- [ ] Do not make AI security equal only prompt injection.
- [ ] Do not make Zero Trust equal only network segmentation.
- [ ] Do not skip detection, logging, response, and operations.
- [ ] Do not skip architecture writing and tradeoff reasoning.
- [ ] Do not forget recall, spaced review, and misconception correction.

---

## 11. Current Status

- [x] Direction agreed: full redesign toward Principal Secure Distributed Systems Architect.
- [x] Security given higher weight across the entire roadmap.
- [x] Rust and Go selected as primary blockchain/distributed-system programming languages.
- [x] Timelines and deadline pressure reduced in favor of quality gates.
- [x] Hands-on work required for every important concept.
- [x] Neuroscience-informed recall and retention methods required.
- [x] Foundations protected from being skipped or downweighted.
- [ ] Full roadmap structure drafted.
- [ ] Phase files written.
- [ ] Existing roadmap audited and integrated.
