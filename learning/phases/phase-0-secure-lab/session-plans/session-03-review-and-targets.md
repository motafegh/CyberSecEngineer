# Session 3 — Review + Deploy Targets

> **Date:** 2026-06-30
> **Phase:** Phase 0, Modules 0.3 (review) + 0.4 (targets)
> **Status:** [ ] Planned

---

## Part 1: Study Review (30–45 min)

### Step 1 — Quick Recall

Close all notes. Open a terminal. Answer:
1. What flag did we need to add to `docker build` and why?
2. How many different ways did we try to install msf? Name each one.
3. Which one worked and what 3 packages were missing?
4. What's the difference between `Ign:` and `Err:` in apt output?

### Step 2 — Read & Verify

Open `notes/03-kali-build-trial-and-error.md` and read through checking each section against what you remembered:

| Section | Check against recall |
|---|---|
| Attempt 1 (bridge timeout) | ✅/❌ |
| Attempt 2 (--network host) | ✅/❌ |
| Attempt 3 (gem install) | ✅/❌ |
| Attempt 4 (Rapid7 repo) | ✅/❌ |
| Attempt 5 (direct .deb) | ✅/❌ |
| Attempt 6 (git clone) | ✅/❌ |
| Detection patterns table | ✅/❌ |
| Tool inventory | ✅/❌ |

### Step 3 — Rebuild (optional hands-on)

If you want to go deeper, delete the image and rebuild from scratch without looking at the note:

```bash
docker rmi kali-lab:with-msf kali-lab:latest
docker build --network host -t kali-lab .../compose/kali/
# Then add msf via git clone + bundle install
```

If you get stuck on an error, try to diagnose it *before* checking the note.

---

## Part 2: Deploy Targets (main session)

### What We'll Do

1. Create Docker networks (`lab-net-internal`, `lab-net-nat`)
2. Run DVWA on `--network lab-net-internal` with no port mapping
3. Run Kali on both networks (NAT for updates, internal for targets)
4. Verify: Kali → DVWA ✅, Host → DVWA ❌, DVWA → Internet ❌
5. Document connectivity matrix

### Files to Read Before

- `notes/02-network-isolation.md` (from Session 1)
- `building/labs/HOST-SAFETY-CHECKLIST.md`

### Practice Questions (before session starts)

1. How do you connect a container to TWO Docker networks?
2. What does `--internal` do on a Docker network?
3. If Kali can reach DVWA but DVWA can't reach Kali, can a reverse shell work?
4. You want to save tcpdump output. Where in the container should it go?
