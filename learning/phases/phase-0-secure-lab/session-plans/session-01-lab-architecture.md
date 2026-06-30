# Session Plan — Phase 0: Secure Lab and Cyber Range

> **Date:** 2026-06-29
> **Status:** [~] In Progress
> **Roadmap ref:** `PHASE-0-SECURE-LAB.md`

---

## Session Goals

- [ ] Understand lab architecture zones and trust boundaries
- [ ] Set up host workstation safety controls
- [ ] Configure VMs with proper network isolation
- [ ] Configure Docker with network isolation
- [ ] Verify isolation between all zones
- [ ] Create documentation and evidence structure

---

## Modules to Cover

### Module 0.1 — Host Workstation Safety
- Inventory host system
- Create lab directory structure
- Write host safety checklist
- Verify no real secrets in lab dirs

### Module 0.2 — Virtualization and Isolation
- Create test VM
- Configure NAT adapter (internet access)
- Configure Host-Only adapter (lab-only)
- Test connectivity and isolation
- Practice snapshots and restores
- Clone vs snapshot explained

### Module 0.2b — Docker Isolation
- Docker networking concepts
- Create isolated bridge network
- Run containers in isolated network
- Verify container-to-container communication
- Verify host isolation
- Docker Compose for multi-container labs

### Module 0.3 — Linux Attack Workstation
- Kali Linux setup (VM or Docker)
- Create non-root user
- Directory structure for tools/reports
- First packet capture

### Module 0.4 — Vulnerable Target Zone
- Deploy DVWA (web app target)
- Deploy Metasploitable or similar
- Verify targets are isolated
- Document target inventory

### Module 0.5 — Telemetry and Evidence
- Central log collection structure
- Save first packet capture
- Evidence naming convention

### Module 0.6 — Documentation System
- Directory structure for notes/diagrams
- First Architecture Decision Record
- Lab threat model
- Connectivity matrix

---

## Chunk Order

1. **Lab Architecture Overview** — zones, trust boundaries, why isolation matters
2. **Host Workstation Safety** — directory structure, safety checklist
3. **VM Setup** — VirtualBox/QEMU, network adapters, snapshots
4. **Docker Setup** — networking, containers, compose
5. **Attack Workstation** — Kali setup
6. **Vulnerable Targets** — DVWA, vulnerable VMs
7. **Telemetry** — logs, evidence, captures
8. **Documentation** — ADR, threat model, diagrams
9. **Isolation Verification** — prove everything is isolated

---

## Exit Criteria (Phase 0)

- [ ] Lab architecture explained from memory
- [ ] All trust boundaries identified
- [ ] VMs and Docker containers isolated
- [ ] Vulnerable targets cannot reach real network
- [ ] Snapshots/restore tested
- [ ] Documentation structure exists
- [ ] Evidence handling process exists
- [ ] Architecture diagrams exist
- [ ] Lab threat model exists
- [ ] Safety rules written
