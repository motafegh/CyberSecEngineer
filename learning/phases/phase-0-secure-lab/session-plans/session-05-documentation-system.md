# Session 5 — Phase 0, Module 0.6: Documentation System

> **Roadmap ref:** `PHASE-0-SECURE-LAB.md` §7, §13 (Architecture Diagram + Module 0.6)
> **Date:** Planned
> **Status:** [ ] Planned

---

## Session Goals

- [ ] Create the documentation directory structure (ADRs, diagrams, threat models)
- [ ] Draw the lab architecture diagram with trust boundaries
- [ ] Write the first Architecture Decision Record
- [ ] Write the first lab threat model
- [ ] Write the Phase 0 recall checklist
- [ ] Identify the highest-risk mistake in the lab design

---

## Chunk 1 — Documentation Directory Structure

### What We'll Learn

| Concept | Why It Matters |
|---|---|
| Documentation has its own structure | Find anything without guessing |
| ADRs capture design decisions | Future you will ask "why did we do it this way?" |
| Threat models capture risks | Written risk = managed risk |

### The Structure

Documentation is NOT dumped in one folder. Different documents serve different purposes:

```
building/
├── labs/
│   ├── evidence/                    # Raw evidence (bind-mounted in containers)
│   ├── compose/                     # Dockerfiles, compose files
│   └── configs/                     # VM/container configs
├── threat-models/                   # Cross-phase threat models
│   └── phase-0-lab-threat-model.md
├── adr/                             # Architecture Decision Records
│   └── ADR-001-lab-networking.md
└── diagrams/                        # Architecture diagrams
    └── phase-0-lab-architecture.md  # Text-based (Mermaid or ASCII)
```

Most of these directories exist already. We'll:
1. Create `building/adr/` and `building/diagrams/`
2. Create `building/threat-models/` if it doesn't exist

### Hands-on Exercise

```bash
mkdir -p /home/motafeq/projects/CyberSecEngineer/building/{adr,diagrams}
ls /home/motafeq/projects/CyberSecEngineer/building/threat-models/  # should exist
```

---

## Chunk 2 — Architecture Diagram

### What We'll Learn

| Concept | Why It Matters |
|---|---|
| Diagrams reveal trust boundaries | A picture shows what text obscures |
| Mark allowed and denied flows | The connectivity matrix in visual form |
| Text-based diagrams are version-controllable | Mermaid, ASCII art — no binary formats |

### The Diagram

We'll draw the lab architecture showing:

```
┌─────────────────────────────────────────────────────────┐
│                    YOUR LAPTOP (HOST)                     │
│  Windows + WSL2                                           │
│  ┌──────────────────────────────────────────────────┐    │
│  │              WSL2 (Ubuntu)                        │    │
│  │                                                    │    │
│  │  ┌─────────────┐   ┌──────────────────────────┐  │    │
│  │  │ Docker       │   │ building/adr/            │  │    │
│  │  │ Desktop      │   │ building/diagrams/       │  │    │
│  │  │              │   │ building/threat-models/  │  │    │
│  │  │  lab-net-nat ◄───┤ building/labs/           │  │    │
│  │  │  (internet)  │   │   evidence/              │  │    │
│  │  │      │       │   │   EVIDENCE-HANDLING.md  │  │    │
│  │  │      ▼       │   └──────────────────────────┘  │    │
│  │  │  ┌───────┐  │                                    │    │
│  │  │  │ Kali  │  │                                    │    │
│  │  │  │ eth0 ─┼──┤  lab-net-nat                        │    │
│  │  │  │ eth1 ─┼──┤  lab-net-internal                   │    │
│  │  │  └───┬───┘  │                                    │    │
│  │  │      │       │                                    │    │
│  │  │      ▼       │                                    │    │
│  │  │  ┌───────┐  │                                    │    │
│  │  │  │ DVWA  │  │  lab-net-internal                    │    │
│  │  │  │(port80)│  │  --internal: NO internet            │    │
│  │  │  └───────┘  │                                    │    │
│  │  └─────────────┘                                    │    │
│  └──────────────────────────────────────────────────┘    │
│                                                            │
│  TRUST BOUNDARIES:                                         │
│  ═══ Host ↔ Container: no port mapping, IP reachable     │
│  ═══ Internal ↔ Internet: --internal blocks at kernel     │
└─────────────────────────────────────────────────────────┘
```

### Hands-on Exercise

1. Draw the diagram in a markdown file using ASCII art (as above, but with your own style)
2. Mark: host, WSL2, Docker, Kali, DVWA, lab-net-nat, lab-net-internal
3. Mark: allowed flows (green arrows or `✅`) and denied flows (red arrows or `❌`)
4. Mark: trust boundaries (dashed lines with labels)
5. Save to `building/diagrams/phase-0-lab-architecture.md`

### Key Takeaway

A diagram that shows trust boundaries is more valuable than a diagram that shows IP addresses. The boundaries are what change between architectures — the IPs are implementation details.

---

## Chunk 3 — Architecture Decision Record (ADR)

### What We'll Learn

| Concept | Why It Matters |
|---|---|
| ADRs capture WHY decisions were made | Future you and others need context |
| ADRs are lightweight (not essays) | 2–3 paragraphs per decision |
| ADRs are timestamped and numbered | Decision history is trackable |

### What an ADR Looks Like

```
# ADR-001: Lab Network Isolation Strategy

## Status
Accepted

## Context
The lab needs to run vulnerable targets (DVWA, WebGoat, Juice Shop)
that can be attacked from a Kali workstation. Targets must never
reach the internet or the host machine. The attack workstation
needs internet access for tool downloads and updates.

## Decision
Use Docker bridge networks for isolation:
- lab-net-internal (--internal, no gateway) for targets
- lab-net-nat (standard bridge) for Kali's internet access
- Kali connects to both networks

This was chosen over:
1. VM-based isolation (QEMU/libvirt) — not available on WSL2
2. Single network with iptables rules — more complex, easier to misconfigure
3. Docker Compose with custom networks — possible but adds abstraction

## Consequences
Positive:
- Targets are isolated at kernel routing level (--internal)
- No port mapping means targets have no host-side listeners
- Simple, verifiable architecture

Negative:
- Docker's seccomp profile blocks raw sockets (nmap needed
  --security-opt seccomp=unconfined)
- IP-level host-to-container reachable (Docker bridge property);
  isolation relies on no port mapping, not IP blocking
- Manual docker run commands instead of Docker Compose (more typing)
```

### Hands-on Exercise

Write ADR-001 covering the lab network architecture decision. Save to `building/adr/ADR-001-lab-networking.md`.

### Discussion Prompts

- What alternatives did we consider but reject? (VMs, single network, iptables)
- What's the biggest negative consequence? (seccomp problem, host-IP reachable)
- Under what conditions would this ADR be superseded? (e.g., switching to Kubernetes in Phase 3)

### Key Takeaway

The ADR is not for today — it's for six months from now when you wonder "why did we do it this way instead of using iptables?" Write it while the reasoning is fresh.

---

## Chunk 4 — Lab Threat Model

### What We'll Learn

| Concept | Why It Matters |
|---|---|
| Threat models identify risks before they happen | Proactive, not reactive |
| A simple model beats no model | Start with STRIDE or a custom table |
| Mitigations are the output | Every risk gets a control, acceptance, or transfer |

### The Threat Model Format

A simple table format that asks four questions per risk:

| Threat | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Target compromised and used to attack host | Low (no port mapping) | Critical (host access) | No `-p` flag, `--internal`, verify with connectivity matrix |
| Attacker escapes Kali container to host | Low-Medium (seccomp disabled) | Critical | Always run as `analyst`, not root; no host mount of sensitive dirs |
| Evidence lost on container destroy | High (certain if no bind mount) | Medium (reproducible) | Bind mount evidence directory, copy to `evidence/` after session |
| Real credentials leak into lab evidence | Medium (habit risk) | High | Use only test credentials, flag any real secrets in evidence |
| Lab target phones home to internet | Low (`--internal` blocks) | High (data exfiltration) | `--internal` at kernel level; verify with ping test |

### Hands-on Exercise

1. List all threats you can think of for the lab
2. Rate each: likelihood (Low/Medium/High), impact (Low/Medium/High/Critical)
3. Write the current mitigation
4. Identify any gaps — threats with no mitigation
5. Save to `building/threat-models/phase-0-lab-threat-model.md`

### Gap Analysis

Review the threats. For any with no mitigation (or weak mitigation), add an action item:
- "Fix by doing X before Session N"
- "Accept — risk is low enough"
- "Transfer — Docker's responsibility (not realistic for our scope)"

### Key Takeaway

A threat model with one gap you know about is safer than an undocumented setup with ten gaps you haven't thought of. Awareness itself is a control.

---

## Chunk 5 — Phase 0 Recall Checklist

### What We'll Learn

| Concept | Why It Matters |
|---|---|
| Recall checks prove retention | If you can't explain it without notes, you don't know it |
| The roadmap has formal exit criteria | This is the evidence that Phase 0 is done |
| Teach-back is the strongest test | Explain to someone else → you know it |

### The Recall Questions

Without notes, you should be able to answer:

**Architecture**
1. Draw the lab network diagram from memory — show all networks, containers, and trust boundaries
2. Why does Kali need two network interfaces? What happens if it has only one?
3. What is the difference between `--internal` and a regular bridge network? Show the `ip route` output for each.

**Isolation**
4. How do you prove a target cannot reach the internet? What exact command and expected output?
5. How do you prove the host cannot reach a target? What's the one thing that would break this?
6. Can the host reach container IPs directly? Why or why not? What does this mean for safety?

**Container Security**
7. What three Docker security layers restrict containers? Why did we need to override two of them for Kali?
8. Why do targets run with DEFAULT security restrictions (no `--cap-add`)? What does this mean if a target is compromised?

**Telemetry**
9. Where does evidence live during a session? Where does it live after? What happens if you forget the bind mount?
10. What does a tcpdump capture on `eth1` show that a capture on `eth0` doesn't?

**ADRs and Threat Models**
11. What is an ADR and why is it more useful than a comment in a config file?
12. Name one threat in the lab threat model that is currently unmitigated. What could fix it?

### Hands-on Exercise

1. Close all notes and answer the questions above
2. For each one you get wrong, add it to `learning/mistakes/phase-0.md`
3. For any you can't answer at all, flag it — that concept needs review before Phase 0 ends

### Key Takeaway

If you can answer all 12 without notes, Phase 0 understanding is solid. If you can't, the gaps tell you exactly what to review before the capstone.

---

## Quiz — Session 5

1. You come back to the lab after 3 months. Which document tells you why the networks are split the way they are?

2. The threat model lists "target phones home" as low likelihood. How was this proven, and what would you do if a future target needs internet access?

3. Why should a diagram show trust boundaries instead of just IP addresses and container names?

4. You find a typo in ADR-001. Do you edit it in place or create ADR-002? Why?

---

## What We'll Produce

| Artifact | Location |
|---|---|
| Architecture diagram | `building/diagrams/phase-0-lab-architecture.md` |
| ADR-001: Lab Networking | `building/adr/ADR-001-lab-networking.md` |
| Lab threat model | `building/threat-models/phase-0-lab-threat-model.md` |
| Documentation structure | `building/adr/`, `building/diagrams/` directories exist |
| Phase 0 recall results | `learning/mistakes/phase-0.md` updated |
| Learning note | `notes/10-documentation-system.md` |

---

## Next Session

**Session 6 — Phase 0 Mini-Projects + Capstone:** Synthesize everything into the Lab Architecture Package, Isolation Verification Report, and Evidence Pipeline Starter. Final Phase 0 review.
