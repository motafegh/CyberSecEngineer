# Session 007

> **Date:** 2026-07-01
> **Module:** Phase 0, Module 0.5 (Telemetry and Evidence Zone) — Chunks 3-5 (completion)
> **Status:** Complete

## What Was Done

1. **Chunk 3 — DVWA Apache Access Logs (Defender's Perspective)** — Lab restarted from scratch (containers stopped + removed + recreated). Ran fresh nmap NSE scan against DVWA. Extracted Apache `access.log` via `docker cp`. Analyzed 36 entries showing: single source IP (Kali), User-Agent "Nmap Scripting Engine" (trivially evadable), 36 requests in one second (behavioral — hard to fake), unusual HTTP methods (PROPFIND, OPTIONS, IKML). Discussed that single indicators are easy to evade, but behavioral patterns are hard.

2. **Chunk 4 — Evidence Naming Convention** — Formalized `YYYY-MM-DD-tool-target-description.ext`. Reviewed existing 6 evidence files: most follow the pattern but some are missing tool or description fields. Discussed why date goes first (alphabetical = chronological) and why version suffixes (FINAL, v2) create confusion.

3. **Chunk 5 — Evidence Handling Rules** — Wrote 7 rules to `building/labs/EVIDENCE-HANDLING.md`: bind mounts, never edit raw evidence, naming convention, copy to archive after session, flag sensitive data, delete from container, keep until note written. Explained chain of custody principle.

## Outcomes

- Evidence now has both attacker side (pcap + nmap output) and defender side (Apache access log)
- Naming convention documented and understood
- Evidence handling rules written to file

## Next Steps

- Module 0.6: Documentation System — architecture diagram, ADR-001, lab threat model
- Deploy WebGoat and Juice Shop (Module 0.4 remaining targets)
