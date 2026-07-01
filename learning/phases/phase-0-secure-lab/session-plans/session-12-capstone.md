# Session 12 — Phase 0 Capstone: Local Secure Cyber Range

> **Roadmap ref:** `PHASE-0-SECURE-LAB.md` §15 (Capstone)
> **Date:** Planned
> **Status:** [ ] Planned
> **Prerequisites:** Sessions 8-11 complete, all mini-projects done, all modules complete

---

## Session Goals

- [ ] Write the capstone README that ties everything together
- [ ] Walk through every Phase 0 exit criterion — mark each done or deferred
- [ ] Verify lab rebuild from scratch using only documented steps
- [ ] Final commit marking Phase 0 complete

---

## Chunk 1 — Capstone README

### Teaching Points

1. **What the capstone README is:** The single document someone reads to understand your entire lab. It's the portfolio piece — not a tutorial, but a reference.
2. **Why it matters:** If you can't explain the lab in one document, you don't understand it well enough to defend it.

### Required Sections

1. **One-sentence architecture summary**
2. **How to start the lab from scratch** (commands, in order)
3. **How to stop the lab** (commands, in order)
4. **How to verify isolation** (one test per boundary)
5. **How to collect and archive evidence**
6. **Links to key artifacts** (ADR, threat model, diagrams, inventory, isolation report, evidence rules, safety rules)
7. **Highest-risk mistake** (and how to avoid it)
8. **Known gaps** (from threat model)

### Hands-On Steps

1. Write or update `building/capstones/phase-0-local-secure-cyber-range/README.md`
2. Cross-reference all artifacts from Sessions 8-11

---

## Chunk 2 — Exit Criteria Walkthrough

### The Checklist (from `PHASE-0-SECURE-LAB.md` §17)

- [ ] Every core lab zone is built → Sessions 1-8 prove this
- [ ] Network isolation is verified → Session 10 isolation report
- [ ] Vulnerable systems cannot reach real local devices → Session 10 proof
- [ ] Clean snapshots or rebuild paths exist → Session 9 snapshot/restore plan
- [ ] Documentation system exists → Sessions 5-7, Module 0.6
- [ ] Evidence handling process exists → Session 11 pipeline
- [ ] Architecture diagrams exist → Sessions 5, 9
- [ ] Lab threat model exists → Session 7 (this session), Module 0.6 Chunk 4
- [ ] Safety rules are written → Session 9
- [ ] Can explain the full lab architecture without notes → capstone quiz
- [ ] Can explain the Lab Extension Protocol without notes → capstone quiz

### For Each: Triangulate

1. Point to the artifact that proves it
2. Point to the session that produced it
3. If missing, decide: do it now, defer with reason, accept the gap

---

## Chunk 3 — Lab Rebuild Verification

### Teaching Points

1. **The acid test of documentation:** Can someone follow your written instructions and get a working lab? If not, the documentation is incomplete.
2. **Why from scratch:** Docker images are cached. A clean rebuild proves the instructions work without cached state.

### Hands-On Steps

1. `docker rm -f` all containers
2. `docker network rm` both networks
3. Follow the capstone README start-lab instructions
4. Run one isolation test per boundary
5. If anything fails, fix the instructions, not the lab

---

## Quiz Questions (Phase 0 Final)

1. Someone asks: "Can a compromised DVWA attack your WSL2 host?" Walk through every layer.
2. Someone asks: "Why didn't you use Docker Compose?" What's the honest answer? Is it a gap worth fixing?
3. You come back after 6 months. What do you run to get the lab back? Start from `docker images`.
4. Phase 2 needs a Windows Active Directory zone. Walk through the Lab Extension Protocol steps.

---

## After Session

- [ ] Write final Phase 0 learning note: `notes/14-phase-0-capstone.md`
- [ ] Update `phase-0-progress-tracker.md`: ALL modules + mini-projects + capstone → ✅
- [ ] Update `learning/progress-tracker.md`: Phase 0 → ✅
- [ ] Update `PLAN.md`: all checkboxes ticked
- [ ] Write session record: `learning/session-records/SESSION-012.md`
- [ ] Commit and push with message: "Phase 0 complete"
