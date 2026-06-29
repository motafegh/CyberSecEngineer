# Phase 0 — Plan: Secure Lab and Cyber Range

> Roadmap source: `Roadmap/PHASE-0-SECURE-LAB.md`
> Status: see `learning/progress-tracker.md`
> Mistakes: `learning/mistakes/phase-0.md`

---

## Phase Goal

Build a safe, local, repeatable environment for every later exercise: offensive labs, defensive labs, distributed systems, and web/API security experiments. Domain-specific zones (Windows/Active Directory, Kubernetes, blockchain, AI) are deliberately not built here — they are added later, immediately before the phase that needs them, via the Lab Extension Protocol (Roadmap §6).

## Required Outcomes (from roadmap)

- [ ] Every core lab zone is built.
- [ ] Network isolation is verified.
- [ ] Vulnerable systems cannot reach real local devices.
- [ ] Clean snapshots or rebuild paths exist.
- [ ] Documentation system exists.
- [ ] Evidence handling process exists.
- [ ] Architecture diagrams exist.
- [ ] Lab threat model exists.
- [ ] Safety rules are written.
- [ ] Explain the full lab architecture and Lab Extension Protocol without notes.

## Modules (from roadmap)

| # | Module | Notes file | Session plan |
|---|---|---|---|
| 0.1 | Host Workstation Safety | `notes/01-host-safety.md` | `session-plans/session-NN-*.md` |
| 0.2 | Virtualization and Isolation | `notes/02-virtualization.md` | `session-plans/session-NN-*.md` |
| 0.3 | Linux Attack and Defense Workstation | `notes/03-kali-workstation.md` | `session-plans/session-NN-*.md` |
| 0.4 | Vulnerable Target Zone | `notes/04-target-zone.md` | `session-plans/session-NN-*.md` |
| 0.5 | Telemetry and Evidence Zone | `notes/05-telemetry.md` | `session-plans/session-NN-*.md` |
| 0.6 | Documentation System | `notes/06-documentation.md` | `session-plans/session-NN-*.md` |

## Mini Projects (from roadmap §14)

- [ ] 14.1 — Lab Architecture Package
- [ ] 14.2 — Isolation Verification Report
- [ ] 14.3 — Evidence Pipeline Starter

## Capstone (from roadmap §15)

- [ ] **Local Secure Cyber Range** — see `building/capstones/phase-0-local-secure-cyber-range/`

## Historical Notes (carried over from v2-era lab setup)

The following pre-v3 notes were moved here for context. They describe a partially built lab using VirtualBox on Windows + Docker in WSL2. The current v3 phase plan uses the new module structure above.

- `notes/00-session-summary.md` — Day 1 lab setup (v2 era)
- `notes/01-lab-architecture.md` — v2 lab architecture
- `notes/02-network-isolation.md` — v2 isolation plan
- `notes/03-snapshots.md` — v2 snapshot workflow
- `notes/04-docker-setup.md` — v2 Docker setup
- `notes/05-project-structure.md` — v2 project layout (superseded by current `Roadmap/ROADMAP-INDEX.md`)

## Session Workflow

Per `AGENTS.md` §3:

1. Before each session: write the actionable session plan in `session-plans/session-NN-<topic>.md`, pulling only the module chunks from the roadmap that this session will cover.
2. During the session: work, capture commands, take notes.
3. After the session: write the learning note in `notes/<topic>.md`, update `learning/progress-tracker.md`, and add any corrected misconceptions to `learning/mistakes/phase-0.md`.
4. Update this PLAN.md to check off completed modules and link to the session plan + notes.
