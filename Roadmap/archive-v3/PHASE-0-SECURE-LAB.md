# Phase 0 — Secure Lab and Cyber Range

> Purpose: Build a safe, local, repeatable environment for every later exercise: offensive labs, defensive labs, distributed systems, blockchain, Artificial Intelligence security, Zero Trust identity, cloud-native security, and architecture experiments.

---

## 1. Phase Goal

By the end of this phase, you should have a local cyber range that lets you safely:

- Build systems
- Break intentionally vulnerable systems
- Defend and harden systems
- Capture logs and traces
- Restore failed or compromised environments
- Run isolated blockchain, Artificial Intelligence, Kubernetes, Windows identity, and web/API labs
- Produce architecture diagrams and safety documentation

**AI — Artificial Intelligence:** software systems that perform tasks normally requiring human reasoning, perception, or decision-making.

**API — Application Programming Interface:** a structured way for software systems to communicate.

---

## 2. Prerequisites

None.

This phase is the prerequisite for all later phases.

---

## 3. Core Principle

A security lab must be designed like a real system:

- Isolate dangerous components.
- Make trust boundaries explicit.
- Know what can reach the internet.
- Know what can reach your home/local network.
- Keep vulnerable targets away from real devices.
- Preserve evidence.
- Restore clean states quickly.
- Document every design decision.

This phase is not just installation. It is the first architecture exercise.

---

## 4. Required Outcomes

- [ ] You can explain the lab network architecture without looking at notes.
- [ ] You can identify every trust boundary in the lab.
- [ ] You can prove vulnerable machines cannot reach your real local network.
- [ ] You can restore important machines from snapshots or rebuild scripts.
- [ ] You can run Linux, Windows identity, web/API, Kubernetes, blockchain, and Artificial Intelligence labs locally.
- [ ] You can collect basic logs from lab systems.
- [ ] You can document lab risks and safety controls.
- [ ] You can explain why each lab component exists.

---

## 5. Lab Zones

The cyber range should be divided into zones.

| Zone | Purpose | Internet Access | Can Reach Real Local Network? | Security Rule |
|---|---|---:|---:|---|
| Host workstation | Daily work and code editing | Yes | Yes | Never run intentionally vulnerable targets directly here. |
| Attack workstation | Security testing tools | Limited/controlled | No | Can reach lab targets only. |
| Vulnerable target zone | Intentionally weak systems | No by default | No | Fully isolated. Assume compromise. |
| Identity zone | Windows/Active Directory and identity experiments | No by default | No | Snapshot before every major change. |
| Cloud-native zone | Containers and Kubernetes | Limited/controlled | No | Restrict privileged containers. |
| Blockchain zone | Local blockchain/devnet experiments | Limited/controlled | No | Use test keys only. Never real funds. |
| Artificial Intelligence zone | Local model and AI security experiments | Limited/controlled | No | No private/sensitive data in prompts or datasets. |
| Telemetry zone | Logs, metrics, traces, alerts | Limited/controlled | No | Treat logs as sensitive data. |

**Active Directory:** Microsoft’s enterprise identity and directory system used for users, computers, groups, and policy.

**Kubernetes:** a container orchestration platform that schedules, networks, and manages containerized workloads.

---

## 6. Architecture Diagram Requirement

Create a diagram before building.

Required diagram elements:

- [ ] Host workstation
- [ ] Virtualization layer
- [ ] Attack workstation
- [ ] Vulnerable target zone
- [ ] Identity zone
- [ ] Cloud-native zone
- [ ] Blockchain zone
- [ ] Artificial Intelligence zone
- [ ] Telemetry zone
- [ ] Internet boundary
- [ ] Real local network boundary
- [ ] Allowed flows
- [ ] Denied flows

Exercise:

- [ ] Draw the first version of the lab architecture.
- [ ] Mark trusted and untrusted zones.
- [ ] Mark which systems are allowed to access the internet.
- [ ] Mark which systems must never access the real local network.
- [ ] Write one paragraph explaining the highest-risk mistake in the design.

Attack/defense pairing:

- Attack risk: a vulnerable machine on a bridged network could expose your real local devices to attack traffic.
- Defense: use isolated host-only or internal networks for targets and avoid bridged networking unless there is a specific, documented reason.
- Detection: verify routing and connectivity from inside each virtual machine.

---

## 7. Module 0.1 — Host Workstation Safety

### Why This Matters

Your host workstation is the root of the lab. If it is compromised, every lab boundary becomes weaker.

### Mechanism

The host runs virtualization, code editors, repositories, and possibly local secrets. Lab systems should be treated as untrusted guests.

### Hands-On Exercises

- [ ] Inventory host operating system, CPU, memory, disk, virtualization support, and available storage.
- [ ] Create a dedicated lab directory structure.
- [ ] Create a separate location for notes, diagrams, reports, and lab code.
- [ ] Verify that no real secrets, wallets, private keys, or production credentials are stored inside lab directories.
- [ ] Write a host safety checklist.

### Attack Surface

- Malicious virtual machine images
- Dangerous copy/paste between host and guest
- Shared folders exposing sensitive host files
- Accidentally running exploit code on the host
- Real credentials used inside labs

### Defensive Controls

- Use only test credentials.
- Disable unnecessary shared folders.
- Keep exploit code inside lab directories.
- Use snapshots before risky work.
- Keep real wallets and secrets outside the lab.

### Recall Checks

- What makes the host workstation more trusted than lab guests?
- Why are shared folders risky?
- Why should real credentials never appear in a lab?

### Exit Criteria

- [ ] Host safety checklist exists.
- [ ] Lab directory structure exists.
- [ ] Sensitive data exclusion rule is documented.

---

## 8. Module 0.2 — Virtualization and Isolation

### Why This Matters

Virtualization lets you run dangerous targets safely, but misconfigured virtualization can leak risk into real networks.

### Mechanism

A virtual machine is an isolated guest operating system running on a host. Network adapters decide what the guest can communicate with.

### Important Concepts

- Network Address Translation
- Host-only network
- Internal network
- Bridged network
- Snapshot
- Clone
- Shared folder

**Network Address Translation:** a network mode where the guest reaches external networks through the host, while external systems do not directly reach the guest.

### Hands-On Exercises

- [ ] Create one test virtual machine.
- [ ] Configure one adapter for internet access only where needed.
- [ ] Configure one isolated lab-only adapter.
- [ ] Prove the machine can reach allowed targets.
- [ ] Prove the machine cannot reach disallowed networks.
- [ ] Take a snapshot and restore it.
- [ ] Clone the test machine and explain the difference between clone and snapshot.

### Attack Surface

- Bridged adapters exposing vulnerable targets
- Shared clipboard leaking commands or secrets
- Shared folders exposing host files
- Old vulnerable guest additions/tools
- Snapshot confusion leading to contaminated state

### Defensive Controls

- Default to isolated networks for vulnerable systems.
- Use internet access only for update/download machines.
- Disable shared folders unless needed.
- Name snapshots clearly.
- Document every adapter on every machine.

### Detection and Verification

- Connectivity tests from guest to allowed targets
- Connectivity tests from guest to blocked targets
- Route table review
- Host firewall review where appropriate

### Recall Checks

- What is the difference between host-only and bridged networking?
- Why is bridged networking dangerous for vulnerable targets?
- What does a snapshot protect you from, and what does it not protect you from?

### Exit Criteria

- [ ] Virtualization platform selected.
- [ ] Isolated network created.
- [ ] Snapshot/restore tested.
- [ ] Network adapter rules documented.

---

## 9. Module 0.3 — Linux Attack and Defense Workstation

### Why This Matters

Linux is the main environment for security tooling, scripting, packet analysis, and later infrastructure work.

### Mechanism

The Linux attack workstation is allowed to interact with lab targets. It should not be trusted with real secrets.

### Hands-On Exercises

- [ ] Install or import a Linux security workstation.
- [ ] Create a non-root daily user if not already present.
- [ ] Verify package update workflow.
- [ ] Create directories for tools, payloads, reports, captures, and notes.
- [ ] Capture one harmless packet trace from a lab-only network.
- [ ] Write a workstation usage policy.

### Attack Surface

- Downloaded tools from untrusted sources
- Running unknown exploit code
- Storing credentials in shell history
- Overusing root privileges
- Mixing real work and lab work

### Defensive Controls

- Prefer package manager or trusted source builds.
- Keep tools versioned and documented.
- Use test credentials only.
- Keep packet captures and logs organized.
- Use least privilege where possible.

### Detection and Telemetry

- Shell history review
- System logs
- Network capture inventory
- Tool version inventory

### Recall Checks

- Why should exploit code stay inside lab directories?
- Why is root overuse dangerous even in a lab?
- What evidence should be saved from an experiment?

### Exit Criteria

- [ ] Linux workstation ready.
- [ ] Tool/report/capture structure created.
- [ ] First packet capture saved and described.

---

## 10. Module 0.4 — Vulnerable Target Zone

### Why This Matters

You need intentionally vulnerable systems to learn exploitation safely and legally.

### Mechanism

Targets are isolated machines or containers with known weaknesses. They are assumed compromised during exercises.

### Hands-On Exercises

- [ ] Add at least one vulnerable Linux target.
- [ ] Add at least one vulnerable web/API target.
- [ ] Verify targets are reachable only from the lab attack workstation.
- [ ] Verify targets cannot reach your real local network.
- [ ] Take clean snapshots or create rebuild instructions.
- [ ] Write a target inventory with purpose and risk.

### Attack Surface

- Default credentials
- Exposed services
- Outdated software
- Insecure web applications
- Weak network segmentation

### Defensive Controls

- Keep targets isolated.
- Never expose vulnerable targets to the internet.
- Snapshot before exploitation.
- Reset after compromise.

### Detection and Telemetry

- Service inventory
- Network flow checks
- Target logs where available
- Attack workstation packet captures

### Recall Checks

- Why are vulnerable targets considered untrusted?
- What is the danger of exposing a target to the internet?
- Why should a target have a clean restore point?

### Exit Criteria

- [ ] Vulnerable target zone exists.
- [ ] Target inventory exists.
- [ ] Isolation proof exists.

---

## 11. Module 0.5 — Windows Identity Zone

### Why This Matters

Zero Trust depends heavily on identity. Enterprise identity systems are also one of the most attacked parts of real organizations.

### Mechanism

A Windows identity lab lets you study users, groups, authentication, authorization, directory policy, and identity-based attacks/defenses.

### Hands-On Exercises

- [ ] Build or prepare a Windows Server evaluation machine.
- [ ] Build or prepare a Windows client machine.
- [ ] Create an isolated identity network.
- [ ] Create test users, groups, and service accounts.
- [ ] Document the domain structure.
- [ ] Snapshot clean identity state.
- [ ] Draw an identity trust diagram.

### Attack Surface

- Weak passwords
- Overprivileged users
- Misconfigured service accounts
- Legacy protocols
- Weak group policy
- Credential exposure

### Defensive Controls

- Strong test password policy
- Least privilege groups
- Separate admin and standard users
- Logging enabled
- Snapshot before risky identity changes

### Detection and Telemetry

- Authentication logs
- Group membership changes
- Failed login attempts
- Privilege changes

### Recall Checks

- Why is identity central to Zero Trust?
- Why should admin and normal users be separated?
- What is the risk of overprivileged service accounts?

### Exit Criteria

- [ ] Identity lab exists.
- [ ] Domain/users/groups documented.
- [ ] Clean snapshot exists.
- [ ] Identity trust diagram exists.

---

## 12. Module 0.6 — Container and Kubernetes Zone

### Why This Matters

Modern distributed systems often run in containers and Kubernetes. Misconfigurations here can become full platform compromise.

### Mechanism

Containers isolate processes using operating system features. Kubernetes schedules and manages containers across a cluster.

### Hands-On Exercises

- [ ] Install or prepare a local container runtime.
- [ ] Run a harmless test container.
- [ ] Build one simple local container image.
- [ ] Start a local Kubernetes cluster.
- [ ] Deploy one simple service.
- [ ] Expose the service only inside the lab.
- [ ] Document cluster boundaries and trust assumptions.

### Attack Surface

- Privileged containers
- Mounted host paths
- Mounted container runtime socket
- Weak Kubernetes Role-Based Access Control
- Exposed service account tokens
- Public dashboards

**RBAC — Role-Based Access Control:** permissions are assigned to roles, and users or services receive permissions by being assigned those roles.

### Defensive Controls

- Least privilege containers
- No privileged mode unless a lab specifically requires it
- Restricted service accounts
- Network policies
- Image scanning
- Admission policies in later phases

### Detection and Telemetry

- Container logs
- Kubernetes events
- Audit logs where available
- Resource usage metrics

### Recall Checks

- Why is a privileged container dangerous?
- What is a service account token?
- How can Kubernetes become a lateral movement platform?

### Exit Criteria

- [ ] Container runtime works.
- [ ] Local Kubernetes cluster works.
- [ ] First service deployed.
- [ ] Cluster trust boundaries documented.

---

## 13. Module 0.7 — Blockchain Development Zone

### Why This Matters

The final role requires blockchain architecture, not only smart contract syntax. The lab must support Rust, Go, and Solidity work.

### Mechanism

A local blockchain zone allows experimentation with nodes, test chains, wallets, smart contracts, peer-to-peer networking, consensus simulations, and transaction flows without real funds.

### Hands-On Exercises

- [ ] Create a dedicated blockchain lab directory.
- [ ] Prepare Rust development tooling.
- [ ] Prepare Go development tooling.
- [ ] Prepare Solidity development tooling.
- [ ] Run or prepare at least one local development chain.
- [ ] Create test-only keys and label them clearly.
- [ ] Document the rule: no real seed phrases, no real funds, no production keys.
- [ ] Draw the lifecycle of a test transaction from signing to inclusion.

### Attack Surface

- Private key leakage
- Malicious dependencies
- Unsafe wallet habits
- Confusing test keys with real keys
- Exposed local Remote Procedure Call endpoints
- Insecure smart contracts

**Remote Procedure Call:** a way for one program to request actions or data from another program over a network or local interface.

### Defensive Controls

- Test-only keys
- Separate directories
- Dependency review
- Local-only endpoints
- No real wallet imports
- Clear environment labels

### Detection and Telemetry

- Node logs
- Transaction traces
- Dependency scan output
- Local endpoint inventory

### Recall Checks

- Why must real wallets never be used in the lab?
- What is the risk of exposing a blockchain node endpoint?
- Why are Rust and Go important for blockchain architecture?

### Exit Criteria

- [ ] Rust tooling ready.
- [ ] Go tooling ready.
- [ ] Solidity tooling ready.
- [ ] Local chain/devnet path selected.
- [ ] Test key safety policy documented.

---

## 14. Module 0.8 — Artificial Intelligence Security Zone

### Why This Matters

AI security labs require local models, test datasets, prompt experiments, Retrieval-Augmented Generation pipelines, and logging. This must be isolated from private data.

**RAG — Retrieval-Augmented Generation:** a Large Language Model pattern where external documents are retrieved and inserted into model context before answering.

### Mechanism

A local AI zone runs models and AI applications in a controlled environment so prompt injection, model abuse, data leakage, and AI-driven security workflows can be tested safely.

### Hands-On Exercises

- [ ] Prepare a local model runtime or document the selected runtime.
- [ ] Create a test-only dataset directory.
- [ ] Create a prompt experiment log.
- [ ] Run a harmless local inference test.
- [ ] Document the rule: no private documents, credentials, keys, or personal sensitive data in prompts or datasets.
- [ ] Draw a basic AI application trust boundary diagram.

### Attack Surface

- Sensitive data in prompts
- Prompt injection
- Malicious retrieved documents
- Unsafe tool/function calling
- Model supply chain risk
- Unreviewed downloaded model files

### Defensive Controls

- Local-only testing where possible
- Test-only datasets
- Prompt/output logging with care
- Model provenance tracking
- Human approval before tool actions
- No secrets in prompts

### Detection and Telemetry

- Prompt logs
- Model output logs
- Tool call logs
- Retrieval logs
- Safety evaluation results

### Recall Checks

- Why is prompt data security important?
- What is the risk of a malicious retrieved document?
- Why should AI tool actions require guardrails?

### Exit Criteria

- [ ] Local AI test path selected.
- [ ] Test dataset policy documented.
- [ ] AI trust boundary diagram created.

---

## 15. Module 0.9 — Telemetry and Evidence Zone

### Why This Matters

Security without telemetry becomes guessing. Architecture without evidence becomes opinion.

### Mechanism

Telemetry includes logs, metrics, traces, alerts, packet captures, and reports that show what systems did.

### Hands-On Exercises

- [ ] Create a central folder or system for logs and evidence.
- [ ] Collect logs from at least one Linux system.
- [ ] Collect logs from at least one container or application.
- [ ] Save one packet capture and explain it.
- [ ] Create an evidence naming convention.
- [ ] Write an evidence handling rule.

### Attack Surface

- Logs containing secrets
- Tampered logs
- Missing timestamps
- Unstructured evidence
- Overcollection of sensitive data

### Defensive Controls

- Treat logs as sensitive.
- Avoid logging secrets.
- Use consistent timestamps.
- Preserve raw evidence.
- Keep notes tied to evidence files.

### Detection and Telemetry

This module is itself about detection and telemetry.

Required evidence types:

- [ ] System logs
- [ ] Application logs
- [ ] Network captures
- [ ] Screenshots where useful
- [ ] Tool output
- [ ] Architecture diagrams
- [ ] Reports

### Recall Checks

- Why are logs sensitive?
- What makes evidence useful during incident response?
- Why are timestamps important?

### Exit Criteria

- [ ] Evidence structure exists.
- [ ] First Linux log sample saved.
- [ ] First application/container log saved.
- [ ] First packet capture saved.
- [ ] Evidence naming convention documented.

---

## 16. Module 0.10 — Documentation System

### Why This Matters

A principal architect must communicate clearly. Documentation starts on day one.

### Mechanism

The documentation system should hold notes, diagrams, decisions, threat models, reports, exercises, and recall gaps.

### Hands-On Exercises

- [ ] Create directories for notes, diagrams, reports, Architecture Decision Records, threat models, and recall gaps.
- [ ] Write the first Architecture Decision Record: why this lab architecture was chosen.
- [ ] Write the first threat model: lab environment threat model.
- [ ] Write the first recall checklist for Phase 0.
- [ ] Create a diagram template.

### Attack Surface

- Documentation with secrets
- Incorrect diagrams causing false confidence
- Lost notes
- Untracked changes
- No decision history

### Defensive Controls

- No secrets in notes.
- Version control where appropriate.
- Update diagrams after architecture changes.
- Use Architecture Decision Records for major changes.
- Record assumptions and revisit triggers.

### Recall Checks

- Why is documentation a security control?
- What belongs in an Architecture Decision Record?
- Why should diagrams include trust boundaries?

### Exit Criteria

- [ ] Documentation structure exists.
- [ ] First Architecture Decision Record written.
- [ ] First lab threat model written.
- [ ] First recall checklist written.

---

## 17. Phase 0 Mini Projects

## 17.1 Lab Architecture Package

Deliverables:

- [ ] System context diagram
- [ ] Network zone diagram
- [ ] Trust boundary diagram
- [ ] Lab asset inventory
- [ ] Connectivity matrix
- [ ] Safety rules
- [ ] Snapshot/restore plan
- [ ] First Architecture Decision Record

## 17.2 Isolation Verification Report

Deliverables:

- [ ] Allowed network flow tests
- [ ] Blocked network flow tests
- [ ] Explanation of results
- [ ] Risk findings
- [ ] Fixes applied
- [ ] Final isolation statement

## 17.3 Evidence Pipeline Starter

Deliverables:

- [ ] Log collection structure
- [ ] Packet capture sample
- [ ] Application/container log sample
- [ ] Evidence naming convention
- [ ] Sensitive log handling rule

---

## 18. Phase 0 Capstone — Local Secure Cyber Range

Build and document the full local lab.

Required components:

- [ ] Host workstation safety plan
- [ ] Virtualization layer
- [ ] Linux attack/defense workstation
- [ ] Vulnerable target zone
- [ ] Windows identity zone
- [ ] Container and Kubernetes zone
- [ ] Blockchain development zone
- [ ] Artificial Intelligence security zone
- [ ] Telemetry/evidence zone
- [ ] Documentation system

Required artifacts:

- [ ] Architecture diagrams
- [ ] Lab threat model
- [ ] Connectivity matrix
- [ ] Asset inventory
- [ ] Snapshot/restore plan
- [ ] Safety rules
- [ ] First Architecture Decision Record
- [ ] Isolation verification report

---

## 19. Neuroscience Learning Plan

Use these recall and retention steps.

### Immediate Recall

After each module:

- [ ] Explain the purpose of the component.
- [ ] Explain the main risk.
- [ ] Explain the main control.
- [ ] Identify one log or evidence source.

### Interleaving

Mix Phase 0 topics with later relevance:

- Virtual networks → later network attacks and Zero Trust.
- Snapshots → later malware/exploit lab safety.
- Identity lab → later Active Directory and Zero Trust identity.
- Kubernetes lab → later cloud-native platform security.
- Blockchain lab → later validator and smart contract security.
- AI lab → later prompt injection, model supply chain, and AI-driven defense.

### Generation Before Review

Before reading a tool guide or setup reference:

- [ ] Predict what network access the component needs.
- [ ] Predict what logs it should generate.
- [ ] Predict what could go wrong.

### Teach-Back

Without notes, explain:

- [ ] Why the lab is divided into zones.
- [ ] Why vulnerable targets must not use bridged networking.
- [ ] Why real keys and credentials never enter the lab.
- [ ] Why telemetry is part of the lab architecture.

---

## 20. Phase 0 Exit Criteria

Phase 0 is complete only when:

- [ ] Every lab zone is either built or intentionally deferred with reason.
- [ ] Network isolation is verified.
- [ ] Vulnerable systems cannot reach real local devices.
- [ ] Clean snapshots or rebuild paths exist.
- [ ] Documentation system exists.
- [ ] Evidence handling process exists.
- [ ] Architecture diagrams exist.
- [ ] Lab threat model exists.
- [ ] Safety rules are written.
- [ ] You can explain the full lab architecture without notes.

---

## 21. Common Failure Modes

- [ ] Building before drawing the architecture.
- [ ] Using bridged networking by default.
- [ ] Mixing real credentials with lab credentials.
- [ ] Forgetting snapshots.
- [ ] Keeping no evidence.
- [ ] Treating logs as harmless.
- [ ] Installing tools without provenance.
- [ ] Running exploit code on the host.
- [ ] Creating a lab that cannot be rebuilt.
- [ ] Skipping documentation because setup feels "basic."

---

## 22. Links to Later Phases

- Phase 1 uses this lab for Linux, networking, cryptography, Go, Rust, Python, and threat modeling.
- Phase 2 uses this lab for web/API attack and defense, detection engineering, and incident response.
- Phase 3 uses this lab for distributed systems, Kubernetes, Zero Trust, service mesh, and policy-as-code.
- Phase 4 uses this lab for blockchain nodes, devnets, smart contracts, Rust, Go, and protocol security.
- Phase 5 uses this lab for AI security, secure Retrieval-Augmented Generation, model supply chain, and AI-driven defense.
- Phase 6 uses this lab as the base for the final secure distributed architecture capstone.
