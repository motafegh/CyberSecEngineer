# Session 7 — Phase 0, Module 0.5: Telemetry and Evidence (Part 2)

> **Roadmap ref:** `PHASE-0-SECURE-LAB.md` §12 (Module 0.5)
> **Continues from:** `session-04-telemetry-and-evidence.md` (Chunks 1-2 done, 3-5 postponed)
> **Date:** 2026-07-01
> **Status:** [x] Complete

---

## Session Goals

- [x] Extract DVWA Apache access logs and identify nmap scan signatures
- [x] Formalize and apply the evidence naming convention
- [x] Write the evidence handling rules document

---

## Chunk 1 — Application Logs from DVWA

Problem it solves: Attackers leave traces on the target. Defenders find those traces in logs. If you only ever look at your own attack tools' output, you never see what the target sees — you're missing the defender's perspective.

Where this sits: every attack generates log artifacts on the target. Understanding those artifacts is how you (a) know whether an attack was detected and (b) know what a real defender would see.

### The core idea

- Apache's `access.log` records every HTTP request — IP, timestamp, method, path, status code, User-Agent
- nmap NSE scripts each make real HTTP requests with identifiable signatures:
  - User-Agent: `Nmap Scripting Engine`
  - Unusual HTTP version: `HTTP/1.0` instead of `HTTP/1.1`
  - Rapid sequential requests from the same IP
- `docker cp` copies files out of a container even without a shell

### Attack/Defense Pairing

- **Attack:** nmap probes reveal the server stack → attacker chooses exploit
- **Defense:** Log monitoring detects scanning in real time. Fail2ban can block after N rapid requests
- **Detection:** Burst of GETs from one IP with `Nmap Scripting Engine` UA = high-confidence scan alert

### Hands-on

1. If new scan needed: from Kali, run `nmap -sV -sC dvwa` (or reuse existing capture)
2. Extract the log: `docker cp dvwa:/var/log/apache2/access.log /tmp/dvwa-access.log`
3. Save to evidence: `cp /tmp/dvwa-access.log learning/phases/phase-0-secure-lab/evidence/2026-07-01-dvwa-access-log.txt`
4. Identify: which lines correspond to nmap? Which are normal?

### Key Takeaway

Every nmap NSE script creates a log entry. Scanning is detectable from the target's perspective. There is no truly stealthy full scan — what changes is how long it takes the defender to notice.

---

## Chunk 2 — Evidence Naming Convention

Problem it solves: Without a convention, evidence files become `scan.txt`, `scan2.txt`, `scan_FINAL(3).txt` — you can't find anything, you don't know what's fresh, and you can't script around them.

### The Convention

```
YYYY-MM-DD-tool-target-description.ext
```

Examples:
- `2026-07-01-nmap-dvwa-syn-scan.txt`
- `2026-07-01-tcpdump-dvwa-eth1-capture.pcap`
- `2026-06-30-connectivity-matrix.txt`

### Rules

1. **Date first** — ISO 8601 (`YYYY-MM-DD`). Sorts alphabetically = sorts chronologically
2. **Tool or source** — what generated it (nmap, tcpdump, hydra)
3. **Target** — who was targeted (dvwa, kali, lab-net-internal)
4. **Description** — what kind of evidence (syn-scan, service-detect, pcap)
5. **No spaces** — hyphens only. Works in URLs, scripts, CLI
6. **No version suffixes** — `FINAL`, `v2`, `_fixed` create confusion. Use timestamps instead

### Hands-on

Review existing evidence files and verify convention:
```bash
ls -1 learning/phases/phase-0-secure-lab/evidence/
```
Rename any that don't match. Note the convention in the evidence directory.

---

## Chunk 3 — Evidence Handling Rules

Problem it solves: Without rules, evidence gets deleted, edited, or lost. The bind mount solves the technical problem (survival); the rules solve the process problem (discipline).

### The Rules

1. ALWAYS use bind mounts for evidence directories
2. NEVER edit raw evidence files — annotate in a separate notes file
3. ALWAYS use the naming convention: `YYYY-MM-DD-tool-target-description.ext`
4. ALWAYS save evidence to `learning/phases/phase-N-*/evidence/` after session
5. FLAG any evidence containing passwords, tokens, or PII
6. DELETE evidence from Kali container after copying to host
7. KEEP evidence until the related lab session is complete and learning note is written

### Hands-on

Write to `building/labs/EVIDENCE-HANDLING.md`

---

## Quiz

1. You run `nmap -sV -sC dvwa` from Kali. DVWA's Apache `access.log` now has entries from Kali's IP. What three things in those log entries tell a defender "this is a scan, not a real browser"?

2. You have two evidence files: `scan-results.txt` and `2026-07-01-nmap-dvwa-service-scan.txt`. Which one follows the convention? What's wrong with the other?

3. You find a cleartext password in an nmap output file saved as evidence. What do you do? (Name at least two correct actions.)

---

## What We'll Produce

| Artifact | Location |
|---|---|
| DVWA Apache access log sample | `evidence/2026-07-01-dvwa-access-log.txt` |
| Evidence naming convention applied | Evidence directory verified |
| Evidence handling rules | `building/labs/EVIDENCE-HANDLING.md` |
| Learning note | `notes/09-telemetry-and-evidence.md` (updated) |

---

## Next Session

**Session 8 — Module 0.6:** Documentation system — architecture diagram, ADR-001, lab threat model.
