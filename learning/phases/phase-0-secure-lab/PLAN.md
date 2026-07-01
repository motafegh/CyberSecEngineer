# Phase 0 — Plan: Secure Lab and Cyber Range

> Roadmap source: `Roadmap/PHASE-0-SECURE-LAB.md`
> Phase progress: `phase-0-progress-tracker.md`
> Master status: `learning/progress-tracker.md`
> Mistakes: `learning/mistakes/phase-0.md`

---

## Phase Goal

Build a safe, local, repeatable environment for every later exercise: offensive labs, defensive labs, distributed systems, and web/API security experiments. Domain-specific zones (Windows/Active Directory, Kubernetes, blockchain, AI) are deliberately not built here — they are added later, immediately before the phase that needs them, via the Lab Extension Protocol (Roadmap §6).

## Required Outcomes (from roadmap)

- [ ] Every core lab zone is built.
- [~] Network isolation is verified — Docker internal network tested; connectivity matrix written for DVWA; full matrix pending WebGoat/JuiceShop
- [ ] Vulnerable systems cannot reach real local devices.
- [~] Clean snapshots or rebuild paths exist — Docker images committed; Dockerfile for base build
- [ ] Documentation system exists.
- [~] Evidence handling process exists — bind mounts proven, pcap + Apache logs captured, naming convention defined, 7 rules written to `building/labs/EVIDENCE-HANDLING.md`
- [ ] Architecture diagrams exist.
- [ ] Lab threat model exists.
- [~] Safety rules written — rules defined in `notes/01-host-safety.md`, no standalone checklist
- [ ] Explain the full lab architecture and Lab Extension Protocol without notes.

## Modules (from roadmap)

| # | Module | Status | Notes file | Session plan |
|---|---|---|---|---|
| 0.1 | Host Workstation Safety | ✅ | `notes/01-host-safety.md` | `session-plans/session-01-host-safety-and-isolation.md` |
| 0.2 | Virtualization and Isolation | ✅ | `notes/02-network-isolation.md` | `session-plans/session-01-host-safety-and-isolation.md` |
| 0.3 | Linux Attack/Defense Workstation | ✅ | `notes/03-kali-build-trial-and-error.md`, `notes/04-docker-deep-dive-images-layers-caching.md`, `notes/05-docker-build-strategies-complete-guide.md`, `notes/06-current-lab-state-and-architecture.md` | `session-plans/session-02-kali-and-targets.md`, `session-plans/session-03-review-and-targets.md` |
| 0.4 | Vulnerable Target Zone | 🔄 | `notes/07-nmap-reconnaissance.md`, `notes/08-target-deployment-and-isolation.md` | `session-03-review-and-targets.md`, `session-08-target-zone-completion.md` |
| 0.5 | Telemetry and Evidence Zone | ✅ | `notes/09-telemetry-and-evidence.md` | `session-04-telemetry-and-evidence.md`, `session-07-telemetry-evidence-part-2.md` |
| 0.6 | Documentation System | ✅ | — | `session-05-documentation-system.md` |
| MP.1 | Lab Architecture Package | ⏳ | — | `session-09-lab-architecture-package.md` |
| MP.2 | Isolation Verification Report | ⏳ | — | `session-10-isolation-verification-report.md` |
| MP.3 | Evidence Pipeline Starter | ⏳ | — | `session-11-evidence-pipeline.md` |
| CP | Capstone (§15) | ⏳ | — | `session-12-capstone.md` |

## Mini Projects (from roadmap §14)

- [ ] 14.1 — Lab Architecture Package
- [ ] 14.2 — Isolation Verification Report
- [ ] 14.3 — Evidence Pipeline Starter

## Capstone (from roadmap §15)

- [ ] **Local Secure Cyber Range** — see `building/capstones/phase-0-local-secure-cyber-range/`

## Historical Notes (carried over from v2-era lab setup)

The following pre-v3 notes were moved here for context. They describe a partially built lab using VirtualBox on Windows + Docker in WSL2. The current v3 phase plan uses the new module structure above. Most are superseded by current notes.

- `notes/00-session-summary.md` — Day 1 lab setup (v2 era, superseded)
- `notes/01-lab-architecture.md` — v2 lab architecture (superseded)
- `notes/02-network-isolation.md` — v2 isolation plan (superseded by new `notes/02-*`)
- `notes/03-snapshots.md` — v2 snapshot workflow (superseded)
- `notes/04-docker-setup.md` — v2 Docker setup (superseded)
- `notes/05-project-structure.md` — v2 project layout (superseded by current `Roadmap/ROADMAP-INDEX.md`)

## Session Workflow

Per `AGENTS.md` §3:

1. Before each session: write the actionable session plan in `session-plans/session-NN-<topic>.md`, pulling only the module chunks from the roadmap that this session will cover.
2. During the session: work, capture commands, take notes.
3. After the session: write the learning note in `notes/<topic>.md`, update `phase-0-progress-tracker.md` and `learning/progress-tracker.md`, and add any corrected misconceptions to `learning/mistakes/phase-0.md`.
4. Update this PLAN.md for phase-level transitions and major milestones (not per-session).
