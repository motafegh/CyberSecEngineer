# Session 9 — Mini-Project 14.1: Lab Architecture Package

> **Roadmap ref:** `PHASE-0-SECURE-LAB.md` §14.1
> **Date:** Planned
> **Status:** [ ] Planned
> **Prerequisites:** Session 8 complete, all 3 targets deployed and verified

---

## Session Goals

- [ ] Assemble all architecture artifacts into `building/capstones/phase-0-local-secure-cyber-range/`
- [ ] Write the asset inventory with all 5 containers
- [ ] Write the standalone safety rules document
- [ ] Write the snapshot/restore plan
- [ ] Finalize the system context and trust boundary diagrams

---

## Chunk 1 — Asset Inventory

### Teaching Points

1. **What an asset inventory is:** A complete list of every component in the lab, with type, purpose, network, and internet access. It's the "what exists" baseline.
2. **Why it matters:** You can't secure what you don't know exists. Every threat model, every connectivity test, every incident response starts from the inventory.
3. **How to read it:** One row per asset. Columns: name, type, purpose, network(s), internet access, rebuild path.

### Hands-On Steps

1. List all Docker images: `docker images`
2. List all Docker networks: `docker network ls`
3. List all running containers: `docker ps -a`
4. Compile into `building/capstones/phase-0-local-secure-cyber-range/inventory.md`

### Deliverable

`inventory.md` with tables for: images, networks, containers, and a connectivity matrix.

---

## Chunk 2 — Safety Rules (Standalone Document)

### Teaching Points

1. **Why a standalone doc:** Safety rules buried in a learning note are invisible to someone opening the lab directory. A standalone `SAFETY-RULES.md` is the first thing a new teammate should read.
2. **What goes in it:** The non-negotiable rules. Not "best practices" — hard rules with consequences if broken.

### Hands-On Steps

1. Extract safety rules from `notes/01-host-safety.md`
2. Add lab-specific rules (no `-p` on targets, `--internal` only, etc.)
3. Write to `building/labs/SAFETY-RULES.md`

---

## Chunk 3 — Snapshot/Restore Plan

### Teaching Points

1. **Why this matters:** If a target is compromised beyond useful study, you need a clean restore. "Rebuild from scratch" is acceptable but must be documented — otherwise you'll forget the exact `docker run` flags.
2. **Two types of restore:** `docker commit` (image snapshot) vs `docker run` from base image (clean rebuild). Each has tradeoffs.

### Hands-On Steps

1. Document `docker commit` procedure for Kali
2. Document `docker run` procedures for each target
3. Document full lab teardown and rebuild sequence
4. Write to `building/capstones/phase-0-local-secure-cyber-range/snapshot-restore.md`

---

## Chunk 4 — Finalize Diagrams

### Teaching Points

1. **Diagrams are living documents:** They must reflect the current state. After adding 2 targets, the architecture diagram from Session 5 is outdated.
2. **What to update:** Add WebGoat and Juice Shop to the architecture diagram. Update trust boundaries if anything changed.

### Hands-On Steps

1. Update `building/diagrams/phase-0-lab-architecture.md` with all 3 targets
2. Ensure trust boundaries, flows, and connectivity matrix match reality
3. Save

---

## After Session

- [ ] Write learning note: `notes/11-lab-architecture-package.md`
- [ ] Update `phase-0-progress-tracker.md`: Mini-Project 14.1 → ✅
- [ ] Update `learning/progress-tracker.md`
- [ ] Write session record: `learning/session-records/SESSION-009.md`
- [ ] Commit and push
