# Session 01 — Phase 0, Module 0.1 Chunk 1: Host Safety Concepts

> **Date:** Monday, Week 1
> **Roadmap ref:** `Roadmap/PHASE-0-SECURE-LAB.md` §8 (Module 0.1)
> **Phase plan:** `learning/phases/phase-0-secure-lab/PLAN.md`
> **Planned duration:** 3.5h
> **Active chunk:** "Why the host matters" — *Why This Matters* + *Mechanism* + *Attack Surface* sections of Module 0.1

---

## Pre-session checklist

- [ ] Open `learning/phases/phase-0-secure-lab/PLAN.md` and confirm Module 0.1 is the active scope
- [ ] Read `Roadmap/PHASE-0-SECURE-LAB.md` §8 — focus only on *Why This Matters*, *Mechanism*, *Attack Surface*
- [ ] Have `learning/mistakes/phase-0.md` open in another tab (to add entries if needed)

## Active chunk

### Goal

You should be able to explain, without notes, **why the host workstation is the most trusted machine in the lab and what happens when that trust breaks.**

### Sub-topics in this chunk

1. **Why the host is the root of the lab** — what runs on it, what it has access to
2. **Mechanism of virtualization** — VMs as isolated guests, host as supervisor
3. **Attack surface** — 5 vectors listed in the roadmap:
   - Malicious VM images
   - Dangerous copy/paste between host and guest
   - Shared folders exposing sensitive host files
   - Accidentally running exploit code on the host
   - Real credentials used inside labs

### Plan

- **0:10-0:50** — Read the three sections. Note any word or concept that isn't clear.
- **0:50-1:50** — Teach + quiz. I explain the mechanism, you push back / ask questions / teach it back. I quiz 3-5 open-ended questions per AGENTS.md §5. We don't move on until you can explain the chunk unaided.
- **1:50-2:00** — Break.

## After the quiz passes

- **2:00-2:20** — Preview tomorrow's chunk (Attack Surface + Defensive Controls) at a high level. No teaching.
- **2:20-2:50** — Write `notes/01-host-safety.md` — your own writeup. Not a copy of the roadmap.
- **2:50-3:20** — Journal entry in `~/personal/CyberSec_path/journal/2026-06-29-*.md`. Honest.
- **3:20-3:30** — Bookkeeping: tick this file, update `learning/progress-tracker.md`, log any misconceptions to `learning/mistakes/phase-0.md`.

## Quiz format (preview)

When the time comes, expect 3-5 open-ended questions like:

- "Walk me through what runs on the host versus what runs inside a lab VM, and what would happen if a malicious VM image broke out of isolation."
- "Why are shared folders a higher-risk vector than a clipboard copy-paste?"
- "Explain the trust asymmetry: why is the host more trusted than lab guests, and what could break that assumption?"

No multiple choice, no true/false, no peeking at notes.

## Out of scope for this chunk

- Attack Surface + Defensive Controls — tomorrow (Tue)
- Hands-on host audit — Wed
- Module 0.2 (Virtualization) — starts Thu
- Any lab construction work — not until Module 0.2

## Done when

- [ ] Quiz passed without notes
- [ ] `notes/01-host-safety.md` written
- [ ] Journal entry written
- [ ] `learning/progress-tracker.md` updated
- [ ] Any corrected belief added to `learning/mistakes/phase-0.md`
