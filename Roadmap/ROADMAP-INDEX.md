# Cybersecurity Career Roadmap v3 — Principal Secure Distributed Systems Architect

> **Target Role:** Principal Secure Distributed Systems Architect  
> **Focus Areas:** Blockchain and Web3 Security Architecture · AI-Driven Security and AI System Security · Zero Trust Networks · Cloud-Native and Distributed Platform Security · Secure Architecture Leadership
>
> This roadmap is quality-gated, security-centered, hands-on, and designed for long-term retention. Fixed timelines are replaced by evidence-based exit criteria.

---

## Design Principles

- **Security is the dominant lens** across all phases — every topic includes attack, defense, detection, and architecture.
- **Every important concept gets hands-on practice** — no topic is left as passive reading.
- **Rust and Go are first-class languages** for blockchain and distributed systems. Python remains core for security automation and AI workflows. Solidity matters for Ethereum smart contract security, but blockchain is not reduced to Solidity.
- **Foundations are protected** from being skipped or downweighted even when they are not directly in the final role title.
- **Neuroscience-informed learning** — retrieval, spacing, interleaving, generation, teach-back, and error tracking are built into every phase.
- **Quality gates replace timelines** — progress is measured by capability evidence, not calendar months.
- **Job-hunt material** becomes evidence-quality guidance without deadline pressure.

---

## Roadmap Overview

```text
Phase 0   Secure Lab and Cyber Range         Build the local environment
Phase 1   Deep Technical Foundations          OS, networking, crypto, programming, threat modeling
Phase 2   Core Security Engineering           Web, API, code review, supply chain, detection, IR
Phase 3   Distributed, Cloud, Zero Trust      Services, K8s, mTLS, policy-as-code, observability
Phase 4   Blockchain and Web3 Architecture    Protocols, consensus, bridges, smart contracts
Phase 5   AI Security and AI-Driven Defense   Adversarial ML, LLM security, AI security operations
Phase 6   Principal Secure Architecture       Reference architectures, synthesis, leadership
```

---

## Phase Files

| Phase | File | Purpose |
|---|---|---|
| 0 | [PHASE-0-SECURE-LAB.md](PHASE-0-SECURE-LAB.md) | Build a secure, isolated, reproducible local cyber range. |
| 1 | [PHASE-1-DEEP-FOUNDATIONS.md](PHASE-1-DEEP-FOUNDATIONS.md) | Deep foundations: Linux, networking, crypto, Python, Go, Rust, threat modeling. |
| 2 | [PHASE-2-CORE-SECURITY-ENGINEERING.md](PHASE-2-CORE-SECURITY-ENGINEERING.md) | Web/API security, code review, supply chain, binary exploitation, detection, SSDLC. |
| 3 | [PHASE-3-DISTRIBUTED-CLOUD-ZEROTRUST.md](PHASE-3-DISTRIBUTED-CLOUD-ZEROTRUST.md) | Distributed systems, containers, Kubernetes, mTLS, policy-as-code, Zero Trust, observability. |
| 4 | [PHASE-4-BLOCKCHAIN-WEB3-SECURITY-ARCHITECTURE.md](PHASE-4-BLOCKCHAIN-WEB3-SECURITY-ARCHITECTURE.md) | Blockchain protocols, consensus, validators, bridges, wallets, governance, MEV. |
| 5 | [PHASE-5-AI-SECURITY-AI-DRIVEN-DEFENSE.md](PHASE-5-AI-SECURITY-AI-DRIVEN-DEFENSE.md) | Adversarial ML, LLM security, RAG, model supply chain, AI-driven detection and triage. |
| 6 | [PHASE-6-PRINCIPAL-SECURE-ARCHITECTURE.md](PHASE-6-PRINCIPAL-SECURE-ARCHITECTURE.md) | Reference architectures, advanced threat modeling, governance, incident-ready architecture, leadership communication. |

---

## Cross-Cutting Files

| File | Purpose |
|---|---|
| [ARCHITECTURE-SPINE.md](ARCHITECTURE-SPINE.md) | Architecture reasoning framework applied in every phase. |
| [CAPSTONE-INDEX.md](CAPSTONE-INDEX.md) | Central index of all major hands-on deliverables across phases. |
| [MISTAKE-LOG-SYSTEM.md](MISTAKE-LOG-SYSTEM.md) | How misconception tracking works; source of truth for the `mistakes/` directory. |
| [PORTFOLIO-STRATEGY.md](PORTFOLIO-STRATEGY.md) | Which capstones become public portfolio pieces and how to frame them. |
| [REFERENCE-TOOLS.md](REFERENCE-TOOLS.md) | Tool categories with usage documentation rules. |
| [REFERENCE-RESOURCES.md](REFERENCE-RESOURCES.md) | Free, local-first resource library. |
| [REFERENCE-ARCHITECTURES.md](REFERENCE-ARCHITECTURES.md) | Architecture patterns to build, attack, defend, and adapt. |

---

## File Dependency Map

```text
ROADMAP-INDEX.md
├── ARCHITECTURE-SPINE.md
├── CAPSTONE-INDEX.md
├── MISTAKE-LOG-SYSTEM.md
├── PORTFOLIO-STRATEGY.md
├── PHASE-0-SECURE-LAB.md
│   └── required by all later phases
├── PHASE-1-DEEP-FOUNDATIONS.md
│   └── required by Phase 2
├── PHASE-2-CORE-SECURITY-ENGINEERING.md
│   └── required by Phases 3–6
├── PHASE-3-DISTRIBUTED-CLOUD-ZEROTRUST.md
│   └── required by Phases 4–6
├── PHASE-4-BLOCKCHAIN-WEB3-SECURITY-ARCHITECTURE.md
│   └── required by Phase 6
├── PHASE-5-AI-SECURITY-AI-DRIVEN-DEFENSE.md
│   └── required by Phase 6
├── PHASE-6-PRINCIPAL-SECURE-ARCHITECTURE.md
├── REFERENCE-TOOLS.md
├── REFERENCE-RESOURCES.md
└── REFERENCE-ARCHITECTURES.md
```

---

## Quality Gate Summary

Each phase requires:

| Evidence Type | Required |
|---|---|
| Hands-on exercises for every important concept | Yes |
| Attack/defense pairing for security topics | Yes |
| Detection and telemetry artifacts | Yes |
| Architecture diagrams and trust boundaries | Yes |
| Architecture Decision Records | Yes |
| Threat models | Yes |
| Recall checks without notes | Yes |
| Mistake log and misconception tracking | Yes |

No concept is complete after reading alone.

---

## Old Roadmap Archive

Earlier roadmap versions are preserved for reference at [archive-v2/](archive-v2/) and [archive-v3/](archive-v3/). The current roadmap above supersedes them.
---


