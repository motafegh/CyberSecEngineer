# Session 3 — Review + Deploy Targets

> **Date:** 2026-06-30
> **Phase:** Phase 0, Modules 0.3 (review) + 0.4 (targets)
> **Status:** [x] Complete

---

## Part 1: Study Review (30–45 min)

Re-anchor the Kali build before deploying targets. If you can explain the build, you understand the foundation.

### Step 1 — Quick Recall

Close all notes. Answer from memory:

1. What flag did we need to add to `docker build` and why? What mechanism causes the problem it fixes?
2. How many different ways did we try to install msf? Name each one and why each failed.
3. Which approach worked and what 3 system packages were missing?
4. What's the difference between `Ign:` and `Err:` in apt output? What do you do when you see each?
5. What is the "two-failure rule" and why does it matter operationally?

### Step 2 — Read & Verify

Open `notes/03-kali-build-trial-and-error.md` and check each section against recall.

### Step 3 — Rebuild (optional hands-on)

If you want deeper understanding, delete the image and rebuild from scratch without notes, diagnosing each error yourself.

---

## Part 2: Deploy Targets (main session)

### Overview — Why This Matters

We have 3 vulnerable applications as Docker images. Right now they're just files on disk. To learn exploitation, we need them running in an environment where:
- Kali can reach them freely (to attack)
- **Nothing else** can reach them (for safety)
- We can observe and capture everything (for learning)

This session is about **standing up the isolation architecture and proving it works** — before any exploit touches a target.

---

### Chunk 1 — Docker Network Refresher

**Concept:** Docker networks are software-defined isolation boundaries. A container on one network cannot see containers on another unless explicitly connected. We use two networks — one for internet (NAT), one for targets (internal) — to enforce the lab's trust model.

**Why two networks?**
- `lab-net-nat` — Kali reaches the internet for package updates, tool downloads, etc.
- `lab-net-internal` (`--internal`) — Kali attacks targets here, targets live here, **no gateway** means no egress.

**What we'll observe:**
- A container on `--internal` has no default route. `ip route` shows nothing.
- `ping 8.8.8.8` returns `Network is unreachable` immediately — not a timeout, a kernel-level block.
- Containers on the same user-defined network resolve each other by name via Docker's embedded DNS (127.0.0.11).

### Chunk 2 — Running Targets on an Isolated Network

**Concept:** When you run a container with `--network lab-net-internal` and **no `-p` flag**, the service inside is reachable only from other containers on the same network. The host cannot reach it. The internet cannot reach it.

**What each target teaches:**
- **DVWA** (`vulnerables/web-dvwa`) — PHP/MySQL, old-style LAMP stack. Teaches SQLi, XSS, file upload, command injection. Default creds: `admin/password`. The classic beginner target.
- **WebGoat** (`webgoat/webgoat`) — Java/Spring, lesson-based. Each lesson teaches one vulnerability class with explanation AND the exercise. Best for learning the *mechanism* of each attack.
- **Juice Shop** (`bkimminich/juice-shop`) — Node.js/Express, modern API-heavy SPA. Most realistic. Teaches API exploitation, JWT attacks, SSRF, etc. Has a CTF-style scoreboard.

**Why three different stacks?** Each has a different attack surface. PHP vs Java vs Node means different vulnerability classes, different tooling, different exploitation patterns. Learning across all three builds transferable knowledge, not tool-specific muscle memory.

**Key safety check:** After starting each target, verify no port is listening on the host:
```
ss -tlnp | grep -E "80|443|8080|3000"
```
If nothing shows, the target is invisible from the host.

### Chunk 3 — Kali on Two Networks

**Concept:** A container can be attached to multiple networks simultaneously. Each network gives it a separate interface (eth0, eth1) with its own IP range. Docker handles routing between them automatically.

**Architecture:**
```
Kali container
  ├── eth0 → lab-net-nat (172.x.x.x) → internet via gateway
  └── eth1 → lab-net-internal (172.x.x.x) → targets only, no gateway
```

**What this enables:** Kali can `apt update` on eth0, then immediately `nmap` a target on eth1. Two logically separate networks, one container.

**What we'll observe:**
- `ip addr` shows two interfaces with different IPs
- `ip route` shows a default gateway on NAT, nothing on internal
- From within Kali: `ping 8.8.8.8` works (goes through eth0), `ping dvwa` works (goes through eth1)

### Chunk 4 — Verification: The Connectivity Matrix

**Concept:** Trust boundaries must be *proven*, never assumed. The connectivity matrix documents every allowed and denied flow in the lab. Without it, you don't know if your isolation actually works.

| From | To | Expected | Test |
|---|---|---|---|
| Kali | Target (by name) | ✅ Reachable | `ping dvwa` |
| Kali | Target (by IP) | ✅ Reachable | `ping <target-ip>` |
| Kali | Internet | ✅ Reachable | `ping 8.8.8.8` |
| Target | Internet | ❌ Blocked | `ping 8.8.8.8` from inside target |
| Target | Another target | ✅ Reachable | `ping webgoat` from inside dvwa |
| Host laptop | Target | ❌ Blocked | `curl localhost:80` or target's IP |
| Host laptop | Kali | ❌ Blocked | `ssh <kali-ip>` |

**Why each test matters:**
- Kali→Target: basic attack path, must work
- Kali→Internet: allows updates, tool installs
- Target→Internet: if this works, a compromised target can phone home, exfiltrate data, or download more malware
- Target→Target: lateral movement — if one target is compromised, can it attack others?
- Host→Target: if this works, your real machine is exposed to exploit traffic

**Detection patterns:**
- `ping` succeeds → route exists, no firewall blocking
- `ping` returns `Network is unreachable` → no route (kernel-level, immediate)
- `ping` returns `Destination Host Unreachable` → route exists but host is down
- `ping` hangs (no response) → route exists, host is up, but firewall drops ICMP

### Chunk 5 — First Attack: nmap Against a Target

**Concept:** Before exploiting, you must *recon*. `nmap` discovers what ports are open, what services are running, what versions — all information you need to choose the right exploit.

**What we'll learn:**
- TCP connect scan (`-sT`) vs SYN scan (`-sS`) — the three-way handshake difference and why SYN is stealthier
- Service version detection (`-sV`) — how banners and probe responses reveal exact software versions
- Default scripts (`-sC`) — what NSE scripts check for and why they're noisy
- Output formats (`-oN`, `-oX`, `-oG`) — why you save scans as evidence

**What we'll observe:**
- DVWA on port 80/443 (Apache + PHP)
- WebGoat on port 8080/9090 (Tomcat)
- Juice Shop on port 3000 (Node.js/Express)
- OS detection guesses (all Linux, probably Debian-based)
- Open ports reveal the attack surface before any exploit runs

**Attack/defense pairing:**
- Attack: nmap finds the target's weakest service
- Defense: minimize open ports, use firewalls, banner obfuscation
- Detection: nmap scans show up as connection bursts in target logs; `tcpdump` on Kali captures the scan itself

### Chunk 6 — Capturing Evidence with tcpdump

**Concept:** Evidence is what turns experience into learning. Raw packet captures let you replay and analyze network interactions later. Without evidence, you can't prove what happened or learn from mistakes.

**What we'll learn:**
- `tcpdump -i eth1` captures only internal-network traffic (not internet noise)
- `-w file.pcap` writes raw packets (binary, replayable in Wireshark)
- `-X` prints hex+ASCII (readable, useful for seeing HTTP requests)
- Why you save to a persistent volume or bind mount, not inside the container (containers are ephemeral — when they die, the evidence dies with them)

**Evidence organization:**
```
/home/analyst/evidence/2026-06-30-nmap-dvwa.pcap
/home/analyst/evidence/2026-06-30-connectivity-matrix.txt
```

---

## After the Session

- Save evidence files to `learning/phases/phase-0-secure-lab/evidence/`
- Write learning note `notes/07-target-deployment-and-isolation.md`
- Update `phase-0-progress-tracker.md`: M0.4 → ✅ or ⏳ (Ali decides)
- Update `PLAN.md` if any milestones are met

---

## Practice Questions (Concept Check)

1. A container on `--internal` tries to `curl https://google.com`. What happens at each layer? (DNS lookup → ARP → IP routing → TCP handshake)
2. If you accidentally run a target with `-p 80:80`, what changes in the connectivity matrix? What's the risk?
3. Kali is on two networks. A reverse shell from DVWA connects back to Kali. Does the packet leave the internal network? Why or why not?
4. You run nmap against Juice Shop and see port 3000 open. What does this tell you about the technology stack before you even visit the page?
5. You save a pcap inside the Kali container, then `docker rm` the container. What happened to the evidence? How do you fix this?
