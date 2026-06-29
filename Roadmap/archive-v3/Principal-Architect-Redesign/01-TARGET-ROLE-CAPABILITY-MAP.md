# Target Role Capability Map

> This file starts the redesign by defining the capabilities required for **Principal Secure Distributed Systems Architect** and mapping them backward into roadmap phases, projects, and evidence.

---

## 1. Target Role Definition

**Principal Secure Distributed Systems Architect**

Focus:

- Secure distributed systems
- Blockchain and Web3 architecture
- Artificial Intelligence-driven security
- Artificial Intelligence system security
- Zero Trust networks and identity architecture
- Cloud-native platform security
- Security architecture leadership

Working definition:

> A principal-level architect who can design, build, attack, defend, monitor, and explain distributed platforms where trust is enforced through cryptography, identity, policy, telemetry, and resilient system design.

---

## 2. Capability Depth Model

Every major capability should progress through seven depth levels.

| Level | Capability | Proof |
|---|---|---|
| 1 | **Explain** | Can define terms and describe the mechanism without notes. |
| 2 | **Trace** | Can walk through packet flows, identity flows, state transitions, or attack paths step by step. |
| 3 | **Build** | Can implement a small working version or lab. |
| 4 | **Break** | Can exploit or abuse the mechanism in a controlled environment. |
| 5 | **Defend** | Can harden, patch, constrain, or redesign the mechanism. |
| 6 | **Detect/Operate** | Can log, monitor, alert, investigate, and recover. |
| 7 | **Architect** | Can choose patterns, document tradeoffs, write Architecture Decision Records, and design safely under constraints. |

No important topic is complete at only Level 1 or Level 2.

---

## 3. Primary Capability Domains

## 3.1 Security Foundations

Purpose:

> Build the substrate for every later topic.

Required capabilities:

- Linux security model
- Windows identity basics
- Networking and packet analysis
- Cryptography and key management
- Authentication and authorization
- Threat modeling
- Secure coding basics
- Scripting and automation
- Logs and operational visibility

Required hands-on evidence:

- [ ] Linux permission and process exercises
- [ ] Packet capture and protocol tracing exercises
- [ ] Transport Layer Security handshake walkthrough
- [ ] Hashing/encryption/signature exercises
- [ ] Authentication bypass and fix exercises
- [ ] Authorization policy exercises
- [ ] Threat model for a small service
- [ ] Log analysis exercise

## 3.2 Programming for Secure Systems

Purpose:

> Gain enough implementation depth to build and audit real systems, not just discuss architecture abstractly.

Primary languages:

- Rust
- Go
- Python

Supporting languages:

- Solidity
- TypeScript

Required capabilities:

- Python security automation
- Go network services and concurrency
- Rust ownership, borrowing, memory safety, error handling, and secure parsing
- Solidity smart contract literacy
- Testing, fuzzing, and static analysis
- Secure dependency handling

Required hands-on evidence:

- [ ] Python scanner or audit tool
- [ ] Go concurrent network service
- [ ] Go peer-to-peer communication exercise
- [ ] Rust parser with malicious input tests
- [ ] Rust cryptography-adjacent safe wrapper exercise
- [ ] Solidity vulnerability/fix exercise
- [ ] Dependency scanning and Software Bill of Materials exercise

## 3.3 Core Offensive and Defensive Security

Purpose:

> Understand how attackers chain flaws and how defenders design controls that survive real pressure.

Required capabilities:

- Web application security
- API security
- Secure code review
- Identity and access control failures
- Software supply chain attacks
- Binary exploitation fundamentals
- Reverse engineering fundamentals
- Detection engineering
- Incident response fundamentals

Required hands-on evidence:

- [ ] Web vulnerability exploitation and patching exercises
- [ ] API authorization testing exercises
- [ ] Secure code review report
- [ ] Custom Semgrep rule exercise
- [ ] Supply chain compromise simulation
- [ ] Basic memory corruption exercise
- [ ] Reverse engineering small binary exercise
- [ ] Detection rule written for an attack performed in lab
- [ ] Incident timeline reconstructed from logs

## 3.4 Distributed Systems Architecture

Purpose:

> Understand the failure, trust, and coordination problems that appear when systems span multiple machines and services.

Required capabilities:

- Service decomposition
- Remote procedure calls and message queues
- Replication
- Consistency models
- Consensus
- Leader election
- Partial failure
- Idempotency
- Retries and backoff
- Distributed tracing
- Resilience and chaos testing
- Secure service-to-service communication

Required hands-on evidence:

- [ ] Build a multi-service Go system
- [ ] Add retries and observe failure behavior
- [ ] Simulate partial network failure
- [ ] Implement basic leader election or consensus toy model
- [ ] Add distributed tracing
- [ ] Add mutual Transport Layer Security between services
- [ ] Write threat model for the distributed system
- [ ] Write Architecture Decision Record for consistency/security tradeoff

## 3.5 Cloud-Native and Platform Security

Purpose:

> Secure the infrastructure patterns used by modern distributed systems.

Required capabilities:

- Containers
- Kubernetes
- Infrastructure as Code
- Secrets management
- Workload identity
- Admission control
- Policy-as-code
- Service mesh
- Network policies
- Observability
- Software supply chain controls

Required hands-on evidence:

- [ ] Container hardening exercise
- [ ] Kubernetes Role-Based Access Control exercise
- [ ] Service account token abuse and mitigation exercise
- [ ] Infrastructure as Code misconfiguration exercise
- [ ] Open Policy Agent policy exercise
- [ ] Admission controller policy exercise
- [ ] Service mesh identity exercise
- [ ] Secure deployment pipeline exercise

## 3.6 Zero Trust Architecture

Purpose:

> Replace implicit trust with identity, policy, device/workload posture, continuous verification, and least privilege.

Required capabilities:

- Identity-first access
- Strong authentication
- Authorization policy design
- Workload identity
- Device posture concepts
- Microsegmentation
- Just-in-time access
- Continuous verification
- Logging and policy decision telemetry
- Zero Trust migration planning

Required hands-on evidence:

- [ ] Deny-by-default network exercise
- [ ] Identity-aware service access exercise
- [ ] Policy-based authorization exercise
- [ ] Mutual Transport Layer Security service identity exercise
- [ ] Microsegmentation lab
- [ ] Access decision logging exercise
- [ ] Zero Trust architecture diagram
- [ ] Zero Trust migration Architecture Decision Record

## 3.7 Blockchain and Web3 Security Architecture

Purpose:

> Move beyond smart contract auditing into secure blockchain protocol and distributed trust architecture.

Required capabilities:

- Blockchain data structures
- Peer-to-peer networking
- Consensus mechanisms
- Validator and node security
- Rust blockchain development
- Go blockchain development
- Smart contract security
- Bridge and cross-chain trust models
- Wallet and custody architecture
- Oracle security
- Maximal Extractable Value and mempool security
- Rollup and Layer 2 security
- Governance and cryptoeconomic attacks
- Formal verification fundamentals

Required hands-on evidence:

- [ ] Build a simple blockchain in Go
- [ ] Build or extend a blockchain component in Rust
- [ ] Peer-to-peer gossip simulation
- [ ] Consensus failure simulation
- [ ] Validator hardening exercise
- [ ] Smart contract exploit/fix exercise
- [ ] Oracle manipulation exercise
- [ ] Bridge threat model
- [ ] Wallet/key-management architecture exercise
- [ ] Protocol security review report

## 3.8 AI Security

Purpose:

> Secure systems that use machine learning models, large language models, agents, and retrieval pipelines.

Required capabilities:

- Adversarial machine learning
- Data poisoning
- Model extraction
- Model inversion
- Membership inference
- Model supply chain security
- Large Language Model prompt injection
- Retrieval-Augmented Generation security
- Tool/function-calling security
- AI agent safety boundaries
- Model privacy and governance

Required hands-on evidence:

- [ ] Adversarial example exercise
- [ ] Data poisoning exercise
- [ ] Model extraction exercise
- [ ] Malicious model file analysis exercise
- [ ] Prompt injection lab
- [ ] Retrieval-Augmented Generation poisoning lab
- [ ] Tool-calling abuse exercise
- [ ] Secure AI application threat model
- [ ] AI red team report

## 3.9 AI-Driven Security Engineering

Purpose:

> Use AI safely and measurably to improve security operations without creating blind trust in model output.

Required capabilities:

- Log ingestion and enrichment
- Anomaly detection
- Alert triage
- Large Language Model-assisted investigation
- Human-in-the-loop security automation
- Security Orchestration, Automation, and Response concepts
- False positive and false negative evaluation
- Guardrails and action boundaries
- Privacy-preserving telemetry handling

Required hands-on evidence:

- [ ] Log anomaly detection exercise
- [ ] Alert summarization exercise
- [ ] Large Language Model-assisted triage prototype
- [ ] Human approval workflow exercise
- [ ] False positive/false negative evaluation
- [ ] Guardrailed security agent lab
- [ ] AI-driven incident report generator
- [ ] Risk assessment for AI in security operations

## 3.10 Identity and Enterprise Security

Purpose:

> Understand enterprise identity because Zero Trust depends on identity more than network location.

Required capabilities:

- Active Directory fundamentals
- Kerberos
- NTLM
- OAuth 2.0
- OpenID Connect
- Security Assertion Markup Language
- Single Sign-On
- Multi-factor authentication
- Privileged Access Management
- Conditional access
- Identity governance

Required hands-on evidence:

- [ ] Kerberos ticket flow exercise
- [ ] NTLM relay concept lab in isolated environment
- [ ] OAuth 2.0 authorization flow exercise
- [ ] OpenID Connect login flow exercise
- [ ] Security Assertion Markup Language assertion review exercise
- [ ] Privileged access review exercise
- [ ] Conditional access policy design exercise
- [ ] Identity threat model

## 3.11 Architecture Leadership

Purpose:

> Prove principal-level thinking through decision quality, communication, and cross-domain synthesis.

Required capabilities:

- Architecture diagrams
- Threat modeling at system scale
- Risk registers
- Architecture Decision Records
- Tradeoff analysis
- Security roadmap design
- Executive summaries
- Technical deep dives
- Incident-ready architecture
- Resilience and recovery planning

Required hands-on evidence:

- [ ] Architecture diagram portfolio
- [ ] Threat model portfolio
- [ ] Architecture Decision Record set
- [ ] Risk register for a distributed platform
- [ ] Executive security memo
- [ ] Technical design review
- [ ] Capstone architecture package

---

## 4. Proposed Phase Mapping

| Phase | Name | Main Purpose |
|---|---|---|
| 0 | Secure Lab and Cyber Range | Build the local environment for all exercises and capstones. |
| 1 | Deep Technical Foundations | Build mechanisms: operating systems, networking, cryptography, programming, and threat modeling. |
| 2 | Core Security Engineering | Learn attack, defense, secure engineering, detection, and response. |
| 3 | Distributed, Cloud, and Zero Trust Systems | Build secure distributed platforms with identity, policy, telemetry, and cloud-native controls. |
| 4 | Blockchain and Web3 Security Architecture | Secure blockchain systems using Rust, Go, Solidity, protocol analysis, and cryptoeconomic reasoning. |
| 5 | AI Security and AI-Driven Defense | Secure AI systems and build safe AI-assisted security operations. |
| 6 | Principal Secure Architecture Synthesis | Integrate all domains into reference architectures, capstones, and principal-level artifacts. |

---

## 5. Cross-Cutting Architecture Spine

The architecture spine must appear in every phase.

For every system studied, ask:

- [ ] What are the trust boundaries?
- [ ] What identities exist?
- [ ] What secrets exist?
- [ ] What policies authorize actions?
- [ ] What data is sensitive?
- [ ] What assumptions can fail?
- [ ] What would an attacker try first?
- [ ] What telemetry proves what happened?
- [ ] What controls reduce blast radius?
- [ ] What design decision created or reduced risk?

---

## 6. Capstone Direction

The final capstone should combine:

- Distributed microservices
- Zero Trust service identity
- Blockchain-style auditability or blockchain integration
- AI-assisted detection or triage
- Policy-as-code authorization
- Cloud-native deployment
- Telemetry and incident response
- Architecture documentation

Possible capstone title:

> Secure Distributed Trust Platform

Required artifacts:

- [ ] Source code
- [ ] Infrastructure code
- [ ] Threat model
- [ ] Architecture diagrams
- [ ] Attack simulation report
- [ ] Detection logic
- [ ] Incident response runbook
- [ ] Architecture Decision Records
- [ ] Risk register
- [ ] Executive summary
- [ ] Technical design deep dive

---

## 7. Existing Roadmap Impact

Initial assessment:

| Existing Area | Likely Action | Reason |
|---|---|---|
| Phase 0 lab setup | Expand | Needs cyber range, Kubernetes, blockchain, identity, AI, telemetry. |
| Phase 1 foundations | Expand | Needs Go, Rust, stronger key management, stronger recall/exercise structure. |
| Phase 2 core attack/defense | Expand/rewrite | Needs defense, detection, supply chain, secure engineering, identity depth. |
| Web3 track | Replace/expand | Too focused on Solidity auditing; needs blockchain protocol architecture. |
| AI/ML track | Expand | Needs AI-driven security operations in addition to AI security. |
| Cloud track | Expand/merge | Needs Zero Trust, service mesh, workload identity, platform security. |
| Windows/Active Directory track | Move/expand | Should become enterprise identity and Zero Trust identity foundation. |
| Portfolio/job hunt | Reduce/refocus | Should become evidence quality, not deadline pressure. |
| References | Rewrite | Needs modern distributed systems, Rust, Go, Zero Trust, service mesh, AI security operations. |

---

## 8. Immediate Next Files to Write

- [ ] `02-QUALITY-GATES.md`
- [ ] `03-CAPSTONE-AND-EXERCISE-FRAMEWORK.md`
- [ ] `04-NEW-ROADMAP-INDEX-DRAFT.md`
- [ ] `ARCHITECTURE-SPINE.md`

After these guardrail files, write the phase files in order.
