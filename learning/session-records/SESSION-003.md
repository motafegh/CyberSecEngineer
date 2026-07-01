# Session 003 — Phase 0: Host Workstation Safety & Docker Isolation

**Date:** 2026-06-29  
**Phase:** Phase 0 — Secure Lab and Cyber Range  
**Modules:** 0.1 (Host Workstation Safety), 0.2 (Virtualization and Isolation)  
**Session plan:** `learning/phases/phase-0-secure-lab/session-plans/session-01-host-safety-and-isolation.md`  
**Learning note:** `learning/phases/phase-0-secure-lab/notes/01-host-safety.md`  
**Evidence:** `learning/phases/phase-0-secure-lab/evidence/2026-06-29-session-1-docker-isolation.txt`

> This session marks the fresh start of the learning journey. Previous SESSION-001 and SESSION-002 are historical records from a prior roadmap version.

---

## What Was Covered

### Chunk 1 — Why the Host Matters
- Trust model: Windows → WSL2 → Docker containers
- Host is root of trust; lab guests are assumed compromised
- Attack vectors: shared folders, clipboard, same-network, exploit-on-host
- System inventory completed (Ubuntu 24.04 on WSL2, i7-12700H, 50Gi RAM, Docker 29.5.3)

### Chunk 2 — Virtualization Concepts
- Containers vs VMs: kernel sharing, isolation boundaries, breakout severity
- Container breakout → WSL2; VM escape → Windows host (more severe)
- WSL2 limitation: no nested virtualization → QEMU/KVM won't work inside WSL2
- Docker Desktop + WSL2 is our primary platform; VirtualBox on Windows deferred

### Chunk 3 — Lab Directory Structure & Safety Checklist
- Created `building/labs/` with subdirs for configs, compose, ISO
- Wrote `building/labs/HOST-SAFETY-CHECKLIST.md` with 5 hard rules
- Lab directories are for test data only — no real secrets ever

### Chunk 4 — Docker Isolation (Hands-On)
- Created `lab-net-internal` (with `--internal` flag, no internet)
- Created `lab-net-nat` (with NAT, internet access)
- Tested: `ping 8.8.8.8` → `Network unreachable` on internal network ✅
- Tested: `ping server1` → 0% loss, DNS resolution works ✅
- Cleaned up all containers and networks after testing

---

## Key Takeaways

1. **Trust layers matter:** WSL2 on Windows means our isolation is WSL2-level, not full hardware isolation
2. **`--internal` is the main mechanism:** Docker's `--internal` flag blocks outbound internet for vulnerable targets
3. **Docker networks are isolated by default:** Containers on different bridge networks cannot communicate without explicit configuration
4. **Safety starts before the lab:** Hard rules about secrets, exploit code, and directory permissions prevent accidents

---

## What Was Deferred

| Item | Reason |
|---|---|
| QEMU/libvirt install | WSL2 has no nested virtualization; VMs can be added via VirtualBox on Windows later |
| Full isolation matrix verification | Depends on VM setup; Docker-only verification was sufficient for this session |

---

## Bookkeeping

- [x] Learning note written: `notes/01-host-safety.md`
- [x] Evidence saved: `evidence/2026-06-29-session-1-docker-isolation.txt`
- [x] Session plan updated: Chunks 1-4 completed, 5-6 deferred
- [x] Progress tracker updated: M 0.1 ✅, M 0.2 ✅
- [x] Phase PLAN.md updated: outcomes tracked, module links added
- [ ] Mistake log: none surfaced this session
- [ ] Postponed items logged: QEMU/VMs deferred (WSL2 limitation)

---

## Next Session

**Session 2 — Module 0.3–0.4:** Kali Linux attack workstation in Docker, deploy vulnerable targets, practice exploitation in isolated network.
