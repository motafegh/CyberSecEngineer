# Phase 0 Recall Checklist

> **Usage:** Run before each Phase 1 session. Mark each item ✅ (know it cold), ⚠️ (fuzzy), or ❌ (forgot).
> **Rule:** If >3 items are ❌ in any single run, schedule a re-teach session before new material.
> **Last full sweep:** — (not yet run)

---

## Module 0.1 — Host Workstation Safety

- [ ] What is the single rule that prevents your host from becoming a target while practicing?
- [ ] Name two host-level controls you verified (e.g., firewall, no unnecessary services).
- [ ] Why is "never scan outside the lab network" the most important rule in Phase 0?

## Module 0.2 — Virtualization and Isolation

- [ ] What is the difference between a VM and a container at the kernel level?
- [ ] Why did we choose Docker over nested VMs for this lab?
- [ ] What does `--internal` do to a Docker network at the kernel routing level?
- [ ] How do you verify that a container on `--internal` truly has no internet access?

## Module 0.3 — Kali Attack/Defense Workstation

- [ ] Why does Kali need both `lab-net-nat` and `lab-net-internal`?
- [ ] What is `eth0` used for vs `eth1` inside the Kali container?
- [ ] Why do we pass `--cap-add=NET_RAW --cap-add=NET_ADMIN --security-opt seccomp=unconfined` to Kali but not to targets?
- [ ] What is the difference between a capability being in the *permitted* set vs the *effective* set?
- [ ] Why did `tcpdump` fail as analyst but work with `docker exec -u 0`?
- [ ] What is the safer alternative to running tcpdump as root inside the container?

## Module 0.4 — Vulnerable Target Zone

- [ ] Name the three vulnerable targets we deploy in Phase 0.
- [ ] Why do targets only connect to `lab-net-internal` and not `lab-net-nat`?
- [ ] Why do we NOT use `-p` port mapping on target containers?
- [ ] What happens if you accidentally run `docker run -p 80:80 dvwa`?

## Module 0.5 — Telemetry and Evidence Zone

- [ ] What is a bind mount and why is it the backbone of evidence persistence?
- [ ] Explain the evidence lifecycle: container → bind mount → archive → delete.
- [ ] What is the naming convention for evidence files?
- [ ] Why must you `chown 1000:1000` the bind mount directory on the host?
- [ ] Name the 7 evidence handling rules (or at least the 3 most critical ones).
- [ ] How does tcpdump capture packets on `lab-net-internal` — which interface and why?

## Module 0.6 — Documentation System

- [ ] What are the three artifacts we created? (directory structure, diagram, ADR)
- [ ] What is an ADR and why is it more useful than a casual "we decided X" comment?
- [ ] In the architecture diagram, what do the trust boundaries represent?
- [ ] How many threats did we catalog in the lab threat model?
- [ ] Which threat relies entirely on human discipline, not OS enforcement?
- [ ] What are the 3 gaps identified in the threat model?

## Cross-Module Reasoning

- [ ] A new teammate joins and says "I'll just add `-p 3306:3306` to a target so I can use my host MySQL client." Walk through why this breaks the lab's security model.
- [ ] You notice the evidence directory is 2 GB after a month. What should you do and what threat model item does this relate to?
- [ ] You pull a new Docker image and it behaves strangely (unexpected outbound connections). What supply chain threat does this map to, and what mitigation should you add?

---

## Scoring Guide

| Mark | Meaning | Action |
|---|---|---|
| ✅ | Know it cold | No action |
| ⚠️ | Fuzzy | Re-read the note, flag for next recall session |
| ❌ | Forgot | Log in `learning/mistakes/phase-0.md` with date, schedule re-teach |

**Threshold:** If any item in "Cross-Module Reasoning" is ❌, fix it before Phase 1 — these test integration, not memorization.
