# Phase 0 Lab Threat Model

> **Status:** Living document. Last updated: 2026-07-01.
> **Purpose:** Identify risks specific to the local cyber range, rate them, document controls, and flag gaps.
> **Related:** `building/diagrams/phase-0-lab-architecture.md`, `building/adr/ADR-001-lab-networking.md`, `building/labs/EVIDENCE-HANDLING.md`

## Methodology

Risk = Likelihood × Impact. A threat is worth tracking if either:
- Likelihood ≥ Medium AND Impact ≥ Medium, OR
- Impact ≥ Critical (regardless of likelihood — rare-but-severe threats still need plans)

Format: Threat / Likelihood / Impact / Mitigation / Residual risk or Gap.

| Likelihood | Meaning |
|---|---|
| Low | Unlikely in normal operation |
| Medium | Possible in routine use |
| High | Common or near-certain without care |

| Impact | Meaning |
|---|---|
| Low | Annoying, no real damage |
| Medium | Disruption, recoverable |
| High | Significant damage, time-consuming to recover |
| Critical | Lab boundary breach or data loss |

---

## Threat Catalog

### 1. Compromised target attacks the host

A target (DVWA, WebGoat, Juice Shop) is intentionally vulnerable. If compromised, attacker has code execution in the target container. Could they reach the host?

- **Likelihood:** Low — target on `--internal`, no route to host
- **Impact:** Critical — host compromise breaks all lab boundaries
- **Mitigation:** No `-p` flag (no host listener for target services), `--internal` network (no default gateway), targets run with default Docker capabilities and seccomp
- **Residual risk:** All controls are *human discipline*. If someone runs `docker run -p 80:80 dvwa` later, mitigation breaks silently.

### 2. Kali container escape to host

Kali has expanded capabilities (`seccomp=unconfined`, `NET_RAW`, `NET_ADMIN`). During red-team exercises, Kali itself may be attacked. If compromised, attacker has more capabilities than a target.

- **Likelihood:** Low-Medium — Kali is the attack box, so it's expected to be probed
- **Impact:** Critical — host compromise
- **Mitigation:** Narrow bind mount (only `evidence/` path), Kali runs as `analyst` user when possible, no host secrets in bind-mounted paths
- **Gap:** tcpdump requires `docker exec -u 0` (root) because analyst user lacks effective capabilities. Root inside container has all capabilities enabled. **Action:** prefer setting file capabilities on tcpdump binary (`setcap cap_net_raw,cap_net_admin+eip /usr/sbin/tcpdump`) so it can run as analyst.

### 3. Evidence lost on container destroy

Files written inside a container live in the writable layer. `docker rm` destroys the layer. Without a bind mount, evidence dies with the container.

- **Likelihood:** High if you forget the bind mount
- **Impact:** Medium — reproducible but time-consuming
- **Mitigation:** Bind mount evidence directory at `docker run` time, copy to phase archive (`learning/phases/phase-N-*/evidence/`) after each session
- **Status:** Mitigated

### 4. Real credentials leak into lab evidence

A scan against a real production target (by accident) captures real API keys, real passwords. Log file gets committed to a public repo.

- **Likelihood:** Low (lab targets are isolated) but Medium (careless copy-paste from real work into lab)
- **Impact:** High — credential exposure, possible account compromise
- **Mitigation:** Use only test credentials in lab (`admin/admin` style), scan only lab targets, never commit logs without review
- **Rule:** Evidence handling rule #5 says to flag any evidence containing passwords, tokens, or PII in a companion notes file
- **Residual risk:** Human review at commit time is the last line of defense

### 5. Lab target phones home

Target contains code that tries to beacon to a C2 server. Without `--internal`, the beacon could reach the internet.

- **Likelihood:** Low — `--internal` blocks at kernel level
- **Impact:** High — if successful, C2 learns lab topology and vulnerabilities
- **Mitigation:** `--internal` flag removes the default gateway. Kernel returns "Network is unreachable" before any packet is sent.
- **Verification:** `ping 8.8.8.8` from DVWA returns "Network is unreachable" — verified during Session 1
- **Status:** Enforced at kernel level (strongest form)

### 6. Docker image supply chain attack

Base image (`kalilinux/kali-rolling`, `vulnerables/web-dvwa`) pulled from Docker Hub. If the image is backdoored at the source, every container built from it is compromised.

- **Likelihood:** Low — official images from trusted vendors
- **Impact:** Critical — backdoored tools could exfiltrate every scan
- **Mitigation:** Trust the source, monitor for security advisories
- **Gap:** We do not verify image digests. **Action:** compute SHA256 of base images at first pull, document in `building/labs/image-digests.txt`.

### 7. Stale evidence fills disk

Every session creates pcap files (100s of KB to MBs), log files, scan outputs. Without cleanup, evidence directory grows.

- **Likelihood:** High over months of use
- **Impact:** Low — disk full is annoying, not dangerous
- **Mitigation:** None currently
- **Gap:** No retention policy. **Action:** decide on retention (e.g., delete pcap files older than 90 days after note is written), or accept the gap if disk is large enough.

### 8. WSL2 kernel vulnerability

All containers share WSL2's Linux kernel. A kernel CVE could allow container escape regardless of network configuration.

- **Likelihood:** Low — CVEs are patched regularly
- **Impact:** Critical — full host escape possible
- **Mitigation:** Keep WSL2 updated, `apt upgrade` on host periodically, monitor kernel CVE feeds

### 9. Bind mount ownership confusion

Docker auto-creates host bind mount directory as `root`. Container's `analyst` user (UID 1000) cannot write.

- **Likelihood:** High (we hit this in Module 0.5)
- **Impact:** Low — easy fix
- **Mitigation:** Document the `chown 1000:1000` step; or build analyst user into the image and use `docker run -u analyst`
- **Status:** Mitigated by procedure

### 10. Host can reach container IPs

WSL2 host can ping `172.19.0.3` (DVWA) directly. This is a Docker bridge property. Without port mapping, no service is exposed — but the IP is reachable.

- **Likelihood:** Certain — it's the default Docker behavior
- **Impact:** Low — no service listening
- **Mitigation:** None — this is fundamental to Docker bridge mode
- **Note:** This is why the lab is "safe by discipline, not enforcement." Adding `-p 80:80` would expose the target.

---

## Gap Summary

| # | Threat | Gap | Action |
|---|---|---|---|
| 2 | Kali escape via root tcpdump | Analyst user can't run tcpdump | `setcap` on binary, or accept the gap for lab use |
| 6 | Image supply chain | No digest verification | Document SHA256 in `image-digests.txt` |
| 7 | Stale evidence | No retention policy | Decide retention or accept the gap |

## Supersession Conditions

This threat model is updated when:
- New target type added (e.g., Windows VM in Phase 2)
- New network added (e.g., AD domain network)
- New capability added to Kali (e.g., new --cap-add)
- Lab moves to a new host (e.g., dedicated hardware)

## File Reference

- This document: `building/threat-models/phase-0-lab-threat-model.md`
- Architecture diagram: `building/diagrams/phase-0-lab-architecture.md`
- Network decision: `building/adr/ADR-001-lab-networking.md`
- Evidence rules: `building/labs/EVIDENCE-HANDLING.md`
