# Architecture Spine

> The architecture spine is the set of questions, artifacts, and reasoning habits that run through every phase. It turns technical learning into principal-level secure architecture capability.

---

## 1. Purpose

A principal architect must not only know individual technologies. They must reason across systems.

For every system, ask:

- What is trusted?
- Why is it trusted?
- What happens if that trust is wrong?
- What identities exist?
- What data matters?
- What policies control access?
- What telemetry proves behavior?
- What fails under attack or partial outage?
- What design tradeoff are we accepting?

---

## 2. Universal Architecture Questions

Use these questions in every phase.

## 2.1 System Boundary

- [ ] What is inside the system?
- [ ] What is outside the system?
- [ ] What external dependencies exist?
- [ ] What assumptions are made about those dependencies?

## 2.2 Trust Boundaries

- [ ] Where does data cross from lower trust to higher trust?
- [ ] Where does identity change?
- [ ] Where does authorization happen?
- [ ] Where are secrets handled?
- [ ] Where can an attacker inject input?

## 2.3 Identity

- [ ] Who are the human users?
- [ ] What services/workloads exist?
- [ ] What machines or nodes exist?
- [ ] How are identities issued?
- [ ] How are identities rotated or revoked?
- [ ] What identity has the highest privilege?

## 2.4 Authorization

- [ ] What actions exist?
- [ ] Who or what can perform each action?
- [ ] Where is authorization enforced?
- [ ] Is policy centralized, distributed, or embedded in code?
- [ ] What is denied by default?
- [ ] How are authorization failures logged?

## 2.5 Secrets and Keys

- [ ] What secrets exist?
- [ ] Where are they stored?
- [ ] How are they rotated?
- [ ] Who can read them?
- [ ] What happens if one secret leaks?
- [ ] Is there key separation by purpose?

## 2.6 Data

- [ ] What data is public, internal, confidential, or restricted?
- [ ] Where is data stored?
- [ ] Where is data processed?
- [ ] Where is data transmitted?
- [ ] Is data encrypted at rest and in transit?
- [ ] What data appears in logs?

## 2.7 Failure Modes

- [ ] What happens when a service is down?
- [ ] What happens when the network is partitioned?
- [ ] What happens when a dependency lies or returns malformed data?
- [ ] What happens when clocks disagree?
- [ ] What happens when retries amplify load?
- [ ] What happens during partial compromise?

## 2.8 Attack Paths

- [ ] What is the easiest initial access path?
- [ ] What can be exploited without credentials?
- [ ] What can be exploited with low privilege?
- [ ] What allows privilege escalation?
- [ ] What allows lateral movement?
- [ ] What allows persistence?
- [ ] What allows data exfiltration?

## 2.9 Detection and Telemetry

- [ ] What logs prove authentication?
- [ ] What logs prove authorization decisions?
- [ ] What logs prove data access?
- [ ] What traces show service-to-service calls?
- [ ] What metrics indicate abuse or failure?
- [ ] What alerts are actionable?
- [ ] What evidence survives compromise?

## 2.10 Resilience and Recovery

- [ ] How is the system backed up?
- [ ] How is integrity verified?
- [ ] How is a compromised credential revoked?
- [ ] How is a compromised node removed?
- [ ] How is service restored?
- [ ] How is incident scope determined?

## 2.11 Tradeoffs

- [ ] What security control adds latency?
- [ ] What control adds operational complexity?
- [ ] What control reduces developer speed?
- [ ] What risk is accepted and why?
- [ ] What alternatives were considered?
- [ ] What would make this decision wrong later?

---

## 3. Required Architecture Artifacts

## 3.1 System Context Diagram

Shows:

- [ ] System boundary
- [ ] Users
- [ ] External systems
- [ ] Major data flows
- [ ] Trust assumptions

## 3.2 Container or Component Diagram

Shows:

- [ ] Services
- [ ] Databases
- [ ] Queues
- [ ] Identity providers
- [ ] Policy engines
- [ ] Logs/telemetry systems
- [ ] Network paths

## 3.3 Trust Boundary Diagram

Shows:

- [ ] Trust zones
- [ ] Boundary crossings
- [ ] Authentication points
- [ ] Authorization points
- [ ] Encryption boundaries
- [ ] Untrusted inputs

## 3.4 Threat Model

Includes:

- [ ] Assets
- [ ] Actors
- [ ] Entry points
- [ ] Trust boundaries
- [ ] Threats
- [ ] Controls
- [ ] Residual risk

## 3.5 Architecture Decision Record

Template:

```markdown
# ADR: Decision Title

## Status
Accepted / Proposed / Rejected / Superseded

## Context
What problem are we solving?

## Options Considered
1. Option A
2. Option B
3. Option C

## Decision
What did we choose?

## Rationale
Why this option?

## Tradeoffs
What did we gain and lose?

## Security Impact
What risks changed?

## Operational Impact
What maintenance or monitoring is needed?

## Revisit Trigger
What would cause us to reconsider?
```

## 3.6 Risk Register

Tracks:

- [ ] Risk
- [ ] Impact
- [ ] Likelihood
- [ ] Owner
- [ ] Mitigation
- [ ] Detection
- [ ] Residual risk
- [ ] Status

## 3.7 Incident-Ready Runbook

Includes:

- [ ] Detection signal
- [ ] Triage steps
- [ ] Containment actions
- [ ] Evidence to preserve
- [ ] Recovery steps
- [ ] Communication notes
- [ ] Lessons learned

---

## 4. Phase Integration

## Phase 0

Architecture focus:

- Lab isolation
- Network boundaries
- Safety model
- Restore/recovery design

## Phase 1

Architecture focus:

- Operating system trust boundaries
- Network flows
- Cryptographic trust
- Basic threat models

## Phase 2

Architecture focus:

- Application trust boundaries
- Authentication and authorization design
- Secure coding patterns
- Detection and response design

## Phase 3

Architecture focus:

- Distributed systems failure modes
- Cloud-native trust
- Zero Trust service identity
- Policy-as-code
- Observability

## Phase 4

Architecture focus:

- Blockchain trust and consensus
- Validator/node security
- Smart contract and protocol boundaries
- Bridge and oracle trust models
- Key custody

## Phase 5

Architecture focus:

- AI pipeline trust boundaries
- Model/data/tool trust
- AI-driven security guardrails
- Human-in-the-loop response
- Privacy and telemetry risk

## Phase 6

Architecture focus:

- Full cross-domain synthesis
- Principal-level design reviews
- Executive risk communication
- Long-term operational ownership

---

## 5. Architecture Recall Prompts

Use these repeatedly:

- Explain the trust boundaries of this system without looking at the diagram.
- Which identity is most dangerous if compromised?
- What is the highest-impact secret?
- Where does authorization happen?
- What log proves a policy decision?
- What breaks during partial network failure?
- What is the simplest attack path?
- What control reduces blast radius most?
- What design decision would you document in an Architecture Decision Record?
- What risk remains after all planned controls?
