# Session 005

> **Date:** 2026-06-30
> **Module:** Phase 0, Modules 0.3 review + 0.4 (Vulnerable Target Zone)
> **Status:** Complete

## What Was Done

1. **Kali build review** — walk-through of all 6 failed msf install approaches, Docker build strategies (single RUN, commit-based, multi-stage), apt mirror timeout mechanism explained

2. **DVWA deployed on `lab-net-internal`** — `docker run -dit --name dvwa --network lab-net-internal vulnerables/web-dvwa` with no port mapping. Target unreachable from host, reachable from Kali by container name

3. **Kali dual-network configuration** — container attached to both `lab-net-nat` (eth0, internet) and `lab-net-internal` (eth1, targets). Routing verified: `ping 8.8.8.8` via nat, `ping dvwa` via internal. Docker handles multi-interface routing automatically

4. **Connectivity matrix verified** — full flow table documented in `evidence/2026-06-30-connectivity-matrix.txt`. All expected results confirmed: Kali→internet ✅, Kali→target ✅, target→internet ❌ (immediate `Network is unreachable`)

5. **Docker seccomp/capability problem** — nmap failed with `socket: Operation not permitted`. Root cause: Docker's default seccomp profile blocks raw socket (`SOCK_RAW`) syscalls. Fix: `--security-opt seccomp=unconfined --cap-add=NET_RAW --cap-add=NET_ADMIN`. Kali recreated with these flags

6. **nmap reconnaissance scan against DVWA** — full scan: service detection (`-sV`), default NSE scripts (`-sC`), OS detection (`-O`). Findings: Apache 2.4.25 (Debian), DVWA v1.10, PHPSESSID missing HttpOnly flag, 1 port open (80), 999 closed, no firewall, 1 hop. Saved as `evidence/2026-06-30-nmap-dvwa.txt`

7. **Learning notes written** — `notes/07-nmap-reconnaissance.md` covers TCP handshake mechanism, SYN vs Connect scan, service detection, OS fingerprinting, seccomp problem, attack/defense pairing

8. **Concept audit completed** — all 7 existing learning notes reviewed for unexplained concepts. 13 concept boxes added across 5 notes (namespaces/cgroups, Layer-2, CIDR, ICMP, port numbers, conntrack, HTTP protocol, L2 segment, WAF/IPS, Ruby native extensions, Copy-on-Write, whiteout markers, instruction hash)

## Outcomes

- DVWA running on isolated network, reachable from Kali, invisible from host
- Connectivity matrix proven: 8 flow pairs tested, all matching expected isolation model
- First reconnaissance scan completed and analyzed
- 13 concept gaps in learning notes filled with explanatory boxes
- Evidence: 2 new files in `evidence/` directory

## Deferred / Not Done

- WebGoat and Juice Shop not deployed (only DVWA activated)
- tcpdump packet capture of nmap scan not performed
- Post-session bookkeeping (progress tracker, session record) was postponed during concept audit — completed now in this session

## Next Steps

- Deploy WebGoat and Juice Shop (remaining M0.4 targets)
- Capture tcpdump evidence of nmap scan
- Target inventory document
- Architecture diagram
- Lab threat model
