# Session 5 — Threat Modeling

> **Roadmap ref:** `PHASE-1-FOUNDATIONS.md` → Section 1.5
> **Topics:** STRIDE, DREAD, Attack Trees, Data Flow Diagrams

## What We'll Learn

| Framework | Purpose |
|---|---|
| **STRIDE** | Categorize threats (Spoofing, Tampering, Repudiation, Info Disclosure, DoS, Elevation) |
| **DREAD** | Risk-score each threat (Damage, Reproducibility, Exploitability, Affected Users, Discoverability) |
| **Attack Trees** | Decompose an attack goal into sub-steps |
| **Data Flow Diagrams** | Map the system, find trust boundaries |

## The STRIDE Model

| Letter | Threat | Example |
|---|---|---|
| S | Spoofing | Fake login page, stolen JWT |
| T | Tampering | Modify API request in transit |
| R | Repudiation | Delete audit logs, deny actions |
| I | Information Disclosure | SQL injection leaking data |
| D | Denial of Service | Resource exhaustion |
| E | Elevation of Privilege | User → Admin |

## Practice

**Target:** A basic 3-tier web app (Browser → API → Database)

1. Draw the DFD with trust boundaries
2. Apply STRIDE to each component
3. Build an attack tree for "attacker steals user data"
4. Score each threat with DREAD
5. Propose one control per threat

## Write-Up
- Threat model document in `notes/vulnerability-research/reports/`
- Include DFD, STRIDE table, attack tree, DREAD scores

## Done When
- You can produce a threat model for any simple application
- You understand why this is tested in security engineering interviews
