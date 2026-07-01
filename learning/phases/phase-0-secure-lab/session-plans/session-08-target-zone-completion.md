# Session 8 — Deploy WebGoat + Juice Shop (Module 0.4 Completion)

> **Roadmap ref:** `PHASE-0-SECURE-LAB.md` §11 (Module 0.4)
> **Date:** Planned
> **Status:** [ ] Planned
> **Prerequisites:** Session 7 complete, Docker running, `lab-net-internal` exists, WebGoat/Juice Shop images already pulled

---

## Session Goals

- [ ] Deploy WebGoat on `lab-net-internal` (Java stack)
- [ ] Deploy Juice Shop on `lab-net-internal` (Node.js stack)
- [ ] Verify both targets: reachable from Kali, NOT reachable from internet
- [ ] Run basic nmap scan against each new target from Kali
- [ ] Update connectivity matrix with all 3 targets
- [ ] Capture evidence of isolation and reachability
- [ ] Write learning note for session

---

## Chunk 1 — Deploy and Verify WebGoat

### Context Link

In Session 2-3 we deployed DVWA (PHP/Apache/MySQL). WebGoat is the Java equivalent — a deliberately insecure web application built on Spring Boot. Different stack = different attack surface (Java deserialization, Spring vulnerabilities, JWT issues) = different learning value.

### Teaching Points

1. **What WebGoat is:** OWASP (Open Web Application Security Project — a nonprofit that produces free articles, methodologies, documentation, tools, and technologies in the field of web application security) WebGoat — a deliberately insecure Java web application. Each "lesson" is a vulnerability you exploit hands-on, with hints.
2. **Why Java stack matters:** Different runtime = different attacks. PHP attacks (SQLi via `$_GET`) won't teach you Java attacks (deserialization, Spring4Shell, JWT algorithm confusion).
3. **Why it goes on `lab-net-internal`:** Same reason as DVWA — assumed compromised, no internet, no host exposure.

### Hands-On Steps

1. `docker run -dit --name webgoat --network lab-net-internal webgoat/webgoat`
2. `docker inspect webgoat` — get IP
3. From Kali: `curl http://<webgoat-ip>:8080/WebGoat/` — verify reachable
4. From WebGoat container: `ping 8.8.8.8` — verify NOT reachable
5. From Kali: `nmap -sV <webgoat-ip>` — basic service scan
6. Save evidence

### Quiz Questions

1. Why does WebGoat run on port 8080 instead of 80? What does that tell you about the underlying technology?
2. If WebGoat gets compromised and the attacker tries to scan your host's real network, what prevents it? Walk through every layer.

---

## Chunk 2 — Deploy and Verify Juice Shop

### Context Link

DVWA = PHP. WebGoat = Java. Juice Shop = Node.js/Angular. Three different stacks = three different vulnerability patterns. Juice Shop is also the widest — it has the most individual vulnerabilities of any practice app.

### Teaching Points

1. **What Juice Shop is:** OWASP Juice Shop — a Node.js/Angular web application. Self-contained, no separate database server. Notorious for having 60+ vulnerability types in one app.
2. **Why Node.js matters:** JavaScript on the server = different attack patterns (prototype pollution, npm supply chain, server-side JavaScript injection).
3. **Architecture difference:** Juice Shop ships as a single binary + static files (no separate DB container like DVWA's MySQL). Simpler deployment, different internal structure.

### Hands-On Steps

1. `docker run -dit --name juiceshop --network lab-net-internal bkimminich/juice-shop`
2. `docker inspect juiceshop` — get IP
3. From Kali: `curl http://<juiceshop-ip>:3000/` — verify reachable
4. From Juice Shop container: `ping 8.8.8.8` — verify NOT reachable
5. From Kali: `nmap -sV <juiceshop-ip>` — basic service scan
6. Save evidence

### Quiz Questions

1. You now have 3 targets on the same network. What's the risk of putting compromised targets on the same L2 (Layer 2 — data link layer, where ARP operates) segment? What attacks does this enable between targets?
2. Juice Shop uses port 3000. What does that conventionally signal about the technology?

---

## Chunk 3 — Update Connectivity Matrix and Target Inventory

### Teaching Points

1. **Why the connectivity matrix matters:** It's the "proof" for every Phase 0 exit criterion. Without it, you can't answer "can X reach Y?"
2. **How to read it:** Source → Destination → Allowed? → How verified?
3. **What changes:** Add WebGoat and Juice Shop rows/columns. Same pattern as DVWA.

### Hands-On Steps

1. Compile full connectivity matrix with all 5 containers (Kali, DVWA, WebGoat, Juice Shop, and WSL2 host)
2. Write target inventory table: name, stack, port, purpose, risk
3. Save to `building/capstones/phase-0-local-secure-cyber-range/inventory.md`

### Quiz Questions

1. A new target (Metasploitable 2) needs to be added. Walk through the exact steps: which network, what docker run flags, what to verify, what to update.

---

## Evidence to Capture

| File | Tool | Purpose |
|---|---|---|
| `2026-07-01-docker-inspect-webgoat.txt` | `docker inspect` | WebGoat IP and config |
| `2026-07-01-curl-webgoat.txt` | `curl` | Reachability from Kali |
| `2026-07-01-ping-webgoat-fail.txt` | `ping` | Isolation proof |
| `2026-07-01-nmap-webgoat.txt` | `nmap` | Service scan |
| `2026-07-01-docker-inspect-juiceshop.txt` | `docker inspect` | Juice Shop IP and config |
| `2026-07-01-curl-juiceshop.txt` | `curl` | Reachability from Kali |
| `2026-07-01-ping-juiceshop-fail.txt` | `ping` | Isolation proof |
| `2026-07-01-nmap-juiceshop.txt` | `nmap` | Service scan |
| `2026-07-01-connectivity-matrix-full.txt` | manual | Updated matrix |

---

## After Session

- [ ] Write learning note: `notes/10-target-zone-complete.md`
- [ ] Update `phase-0-progress-tracker.md`: Module 0.4 → ✅
- [ ] Update `learning/progress-tracker.md`
- [ ] Write session record: `learning/session-records/SESSION-008.md`
- [ ] Commit and push
