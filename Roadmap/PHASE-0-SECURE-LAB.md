# Phase 0 — Secure Lab and Cyber Range

> Purpose: Build a safe, local, repeatable environment for every later exercise: offensive labs, defensive labs, distributed systems, and web/API security experiments. Domain-specific zones (Windows/Active Directory, Kubernetes, blockchain, Artificial Intelligence) are deliberately not built here — they are added later, immediately before the phase that needs them, using the Lab Extension Protocol.

---

## 1. Phase Goal

By the end of this phase, you should have a local cyber range that lets you safely:

- Build systems
- Break intentionally vulnerable systems
- Defend and harden systems
- Capture logs and traces
- Restore failed or compromised environments
- Produce architecture diagrams and safety documentation

This phase does not build the Windows identity, Kubernetes, blockchain, or Artificial Intelligence lab zones. Those are built later, just before the phase that needs them, following the Lab Extension Protocol in Section 6. Building them now, before you understand the domain, means configuring them wrong and rebuilding them anyway once the relevant phase teaches the mechanism.

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
- [ ] You can run Linux and web/API labs locally.
- [ ] You can collect basic logs from lab systems.
- [ ] You can document lab risks and safety controls.
- [ ] You can explain why each lab component exists.
- [ ] You can apply the Lab Extension Protocol to safely add a new zone before any later phase.

---

## 5. Lab Zones

The cyber range should be divided into zones.

| Zone | Purpose | Internet Access | Can Reach Real Local Network? | Security Rule |
|---|---|---:|---:|---|
| Host workstation | Daily work and code editing | Yes | Yes | Never run intentionally vulnerable targets directly here. |
| Attack workstation | Security testing tools | Limited/controlled | No | Can reach lab targets only. |
| Vulnerable target zone | Intentionally weak systems | No by default | No | Fully isolated. Assume compromise. |
| Telemetry zone | Logs, metrics, traces, alerts | Limited/controlled | No | Treat logs as sensitive data. |

Additional zones — identity, cloud-native, blockchain, Artificial Intelligence — are not built in Phase 0. They are added later under the Lab Extension Protocol (Section 6), immediately before the phase that needs them.

---

## 6. Lab Extension Protocol

### Why This Matters

Setting up Windows identity, Kubernetes, blockchain, and AI lab zones before you understand the domain means you configure them wrong and rebuild them once you actually learn the mechanism in the relevant phase. The fix is to defer zone construction until immediately before the phase that needs it, while reusing the isolation discipline already built in this phase.

### The Protocol

Before starting any phase that introduces a new domain, run this checklist before touching the phase's technical content:

- [ ] Re-read the Phase 0 Core Principle and Lab Zones table.
- [ ] Define the new zone's purpose in one sentence.
- [ ] Decide internet access: yes/no/controlled.
- [ ] Decide whether the zone can reach the real local network (it should always be no).
- [ ] Decide whether the zone can reach other lab zones, and which ones.
- [ ] Build the zone using the same isolation pattern as the vulnerable target zone (host-only/internal networking, snapshot before risky changes).
- [ ] Add the new zone to the lab architecture diagram.
- [ ] Add the new zone to the connectivity matrix.
- [ ] Write one paragraph on the highest-risk mistake in this zone's design.
- [ ] Snapshot the zone in its clean state before any exercises begin.

### Zone Build Order

| Phase | Zone to Add | Trigger |
|---|---|---|
| Phase 2 | Windows Identity / Active Directory zone | Before Module 2.3b |
| Phase 3 | Container and Kubernetes zone | Before Module 3.3 |
| Phase 4 | Blockchain development zone | Before Module 4.2 |
| Phase 5 | Artificial Intelligence security zone | Before Module 5.1 |

### Recall Checks

- Why is it safer to build a domain-specific lab zone immediately before the phase that needs it rather than during Phase 0?
- What stays constant across every new zone you add, regardless of domain?
- What is the minimum set of decisions you must make before building any new zone?

### Exit Criteria

- [ ] Lab Extension Protocol checklist exists and is ready to apply.
- [ ] Zone build order table is understood.

---

## 7. Architecture Diagram Requirement

Create a diagram before building.

Required diagram elements:

- [ ] Host workstation
- [ ] Virtualization layer
- [ ] Attack workstation
- [ ] Vulnerable target zone
- [ ] Telemetry zone
- [ ] Internet boundary
- [ ] Real local network boundary
- [ ] Allowed flows
- [ ] Denied flows

Domain-specific zones (identity, cloud-native, blockchain, Artificial Intelligence) are added to this diagram later, using the Lab Extension Protocol in Section 6.

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

## 8. Module 0.1 — Host Workstation Safety

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

## 9. Module 0.2 — Virtualization and Isolation

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

## 10. Module 0.3 — Linux Attack and Defense Workstation

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

## 11. Module 0.4 — Vulnerable Target Zone

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

## 12. Module 0.5 — Telemetry and Evidence Zone

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

## 13. Module 0.6 — Documentation System

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

## 14. Phase 0 Mini Projects

## 14.1 Lab Architecture Package

Deliverables:

- [ ] System context diagram
- [ ] Network zone diagram
- [ ] Trust boundary diagram
- [ ] Lab asset inventory
- [ ] Connectivity matrix
- [ ] Safety rules
- [ ] Snapshot/restore plan
- [ ] First Architecture Decision Record

## 14.2 Isolation Verification Report

Deliverables:

- [ ] Allowed network flow tests
- [ ] Blocked network flow tests
- [ ] Explanation of results
- [ ] Risk findings
- [ ] Fixes applied
- [ ] Final isolation statement

## 14.3 Evidence Pipeline Starter

Deliverables:

- [ ] Log collection structure
- [ ] Packet capture sample
- [ ] Application/container log sample
- [ ] Evidence naming convention
- [ ] Sensitive log handling rule

---

## 15. Phase 0 Capstone — Local Secure Cyber Range

Build and document the core local lab.

Required components:

- [ ] Host workstation safety plan
- [ ] Virtualization layer
- [ ] Linux attack/defense workstation
- [ ] Vulnerable target zone
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

Domain-specific zones (Windows identity, container/Kubernetes, blockchain, Artificial Intelligence) are not part of this capstone. Each is added later via the Lab Extension Protocol (Section 6) immediately before the phase that requires it.

---

## 16. Neuroscience Learning Plan

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
- Telemetry/evidence handling → every later phase's detection and incident work.
- Lab Extension Protocol → the identity lab built before Phase 2's Active Directory module, the cloud-native lab built before Phase 3's Kubernetes module, the blockchain lab built before Phase 4, and the AI lab built before Phase 5.

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
- [ ] Why domain-specific zones are deferred to the Lab Extension Protocol instead of being built now.

---

## 17. Phase 0 Exit Criteria

Phase 0 is complete only when:

- [ ] Every core lab zone is built.
- [ ] Network isolation is verified.
- [ ] Vulnerable systems cannot reach real local devices.
- [ ] Clean snapshots or rebuild paths exist.
- [ ] Documentation system exists.
- [ ] Evidence handling process exists.
- [ ] Architecture diagrams exist.
- [ ] Lab threat model exists.
- [ ] Safety rules are written.
- [ ] You can explain the full lab architecture without notes.
- [ ] You can explain the Lab Extension Protocol without notes.

---

## 18. Common Failure Modes

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
- [ ] Building a domain-specific zone (Active Directory, Kubernetes, blockchain, AI) before reaching the phase that needs it.

---

## 19. Links to Later Phases

- Phase 1 uses this lab for Linux, networking, cryptography, Go, Rust, Python, and threat modeling.
- Phase 2 uses this lab for web/API attack and defense, detection engineering, incident response, and — after applying the Lab Extension Protocol — the Windows Identity zone.
- Phase 3 uses this lab for distributed systems, Zero Trust, service mesh, and policy-as-code, and — after applying the Lab Extension Protocol — the container/Kubernetes zone.
- Phase 4 uses this lab for protocol security, and — after applying the Lab Extension Protocol — the blockchain development zone.
- Phase 5 uses this lab for AI-driven defense, and — after applying the Lab Extension Protocol — the Artificial Intelligence security zone.
- Phase 6 uses this lab and every zone built along the way as the base for the final secure distributed architecture capstone.