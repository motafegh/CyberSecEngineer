# Session 10 — Mini-Project 14.2: Isolation Verification Report

> **Roadmap ref:** `PHASE-0-SECURE-LAB.md` §14.2
> **Date:** Planned
> **Status:** [ ] Planned
> **Prerequisites:** Session 9 complete, asset inventory exists, all 3 targets deployed

---

## Session Goals

- [ ] Systematically test every allowed and blocked network flow
- [ ] Document each test with command, expected result, actual result
- [ ] Write risk findings and fixes applied
- [ ] Produce the final isolation statement
- [ ] Save to `building/capstones/phase-0-local-secure-cyber-range/isolation-report.md`

---

## Chunk 1 — Allowed Flow Tests

### Teaching Points

1. **What an allowed flow is:** A connection that SHOULD work based on the architecture. Kali → targets, Kali → internet, host → Kali (bind mount).
2. **Why test it:** If an allowed flow fails, the lab is broken. If an allowed flow succeeds in an unexpected way, the architecture is wrong.
3. **Method:** For each allowed flow, run the test, capture output, compare to expected.

### Tests to Run

| Source | Destination | Method | Expected |
|---|---|---|---|
| Kali | DVWA | `curl http://<dvwa-ip>` | HTTP 200 or login page |
| Kali | WebGoat | `curl http://<webgoat-ip>:8080/WebGoat/` | HTTP 200 or WebGoat page |
| Kali | Juice Shop | `curl http://<juice-ip>:3000/` | HTTP 200 or Juice Shop page |
| Kali | Internet | `ping -c 1 8.8.8.8` | Reply received |
| Kali | Internet (HTTP) | `curl -I https://example.com` | HTTP 200 |
| WSL2 host | Kali (bind mount) | `ls building/labs/evidence/` | Files visible |

---

## Chunk 2 — Blocked Flow Tests

### Teaching Points

1. **What a blocked flow is:** A connection that SHOULD NOT work. Target → internet, target → host services, host → target services (without port mapping).
2. **Why test it:** This is the core safety guarantee. If a blocked flow works, the lab boundary is broken.
3. **The key insight:** "Network is unreachable" is the kernel's answer. It means the routing table has no path. This is stronger than a firewall drop — the packet is never created.

### Tests to Run

| Source | Destination | Method | Expected |
|---|---|---|---|
| DVWA | Internet | `ping -c 1 8.8.8.8` | "Network is unreachable" |
| WebGoat | Internet | `ping -c 1 8.8.8.8` | "Network is unreachable" |
| Juice Shop | Internet | `ping -c 1 8.8.8.8` | "Network is unreachable" |
| DVWA | Kali eth1 | `ping -c 1 <kali-internal-ip>` | Reply received (same network) |
| DVWA | Kali eth0 | Any attempt | Unreachable (different network, no route) |
| WSL2 host | DVWA port 80 | `curl http://<dvwa-ip>` | Connection refused (no -p) |

---

## Chunk 3 — Final Isolation Statement

### Teaching Points

1. **What the isolation statement is:** One paragraph that a reviewer reads to understand the lab's safety posture. Not just "it's safe" — the "why" and the "remaining gaps."
2. **Structure:** What blocks → how it blocks → what's the residual risk → what requires human discipline.

### Hands-On Steps

1. Compile all test results
2. Write risk findings (host IP reachability, discipline-dependent controls)
3. Write fixes applied (no -p, --internal, default capabilities on targets)
4. Write the final isolation statement
5. Save to `building/capstones/phase-0-local-secure-cyber-range/isolation-report.md`

---

## Quiz Questions

1. A blocked flow test returns "Network is unreachable" instead of "Connection timed out." What's the mechanical difference, and why does it matter for your safety argument?
2. You add `-p 8080:8080` to WebGoat so you can access it from your browser. What flows change? What breaks in the isolation model?

---

## After Session

- [ ] Write learning note: `notes/12-isolation-verification-report.md`
- [ ] Update `phase-0-progress-tracker.md`: Mini-Project 14.2 → ✅
- [ ] Update `learning/progress-tracker.md`
- [ ] Write session record: `learning/session-records/SESSION-010.md`
- [ ] Commit and push
