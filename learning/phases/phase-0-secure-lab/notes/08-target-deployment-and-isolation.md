# Target Deployment and Isolation Verification

> **Session 3 — Phase 0, Module 0.4**
> **Date:** 2026-06-30
> **Status:** Partial (DVWA deployed; WebGoat, Juice Shop deferred)
> **Evidence:** `evidence/2026-06-30-connectivity-matrix.txt`, `evidence/2026-06-30-nmap-dvwa.txt`

---

## 1. The Problem: Why Targets Need Isolation

Vulnerable applications are intentionally exploitable. Running one on your machine means:
- Any SQL injection you try hits a real server
- Any command injection you find gives shell access
- Any reverse shell you catch is from a real process

If that server can reach your WSL2 host, or the internet, or other targets — the isolation fails. A compromised target becomes a launching pad.

The goal: **targets must be reachable FROM Kali but NOT from anything else.**

---

## 2. Network Architecture (Recap)

Two Docker bridge networks, purpose-built:

| Network | Gateway | Internet | Purpose |
|---|---|---|---|
| `lab-net-nat` (172.18.0.0/16) | ✅ Yes | ✅ Yes (via NAT) | Kali's internet access |
| `lab-net-internal` (172.19.0.0/16) | ❌ None (`--internal`) | ❌ Blocked | Target isolation |

**Cross-ref:** Full explainer at `notes/01-host-safety.md` §4.2–4.3.

---

## 3. Running Targets on an Isolated Network

### The Command

```bash
docker run -dit --name dvwa \
  --network lab-net-internal \
  vulnerables/web-dvwa
```

**What each flag does:**

| Part | Effect |
|---|---|
| `-dit` | Detached + interactive + TTY (runs in background, keeps stdio ready) |
| `--name dvwa` | Container hostname. Docker DNS registers this on `lab-net-internal` |
| `--network lab-net-internal` | Container gets one interface on the internal network. No gateway, no internet |
| `vulnerables/web-dvwa` | Image name. Already pulled in an earlier session |

**No `-p` flag.** No port mapping. The service inside (Apache on port 80) is reachable at `http://dvwa:80` from other containers on `lab-net-internal`, but NOT from the host (`localhost:80` shows nothing) and NOT from the internet.

### Verification: Host Cannot Reach Target

```bash
# From WSL2 terminal (the host):
ss -tlnp | grep 80   # nothing — no host-side listener on port 80
curl -I http://localhost:80   # Connection refused — nothing is listening here
curl -I http://172.19.0.2:80 # Connection refused — host isn't on this network
```

Note: the `curl` to `172.19.0.2` may actually succeed depending on your Docker configuration. Docker on WSL2 sometimes bridges container IPs to the host. The **real** isolation relies on:
1. No port mapping (host has no listener)
2. `--internal` egress block (target cannot reach host)
3. Targets never having internet access

---

## 4. Kali on Two Networks

### Why Two Interfaces

Kali needs:
- **Internet access** — download exploits, update msf modules, install tools
- **Target access** — reach the isolated targets

These are contradictory requirements if the attack machine has only one network. Solution: give Kali two network interfaces, each on a different bridge.

### The Commands

```bash
# Create container with no network (start clean)
docker run -dit --name kali \
  --network none \
  --user analyst \
  kali-lab:with-msf

# Attach both networks
docker network connect lab-net-nat kali
docker network connect lab-net-internal kali

# Verify interfaces
docker exec -it kali bash
analyst@kali:/$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> ...
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> ... inet 172.18.0.2/16
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> ... inet 172.19.0.3/16

analyst@kali:/$ ip route
default via 172.18.0.1 dev eth0   ← Gateway only on NAT
172.18.0.0/16 dev eth0            ← lab-net-nat
172.19.0.0/16 dev eth1            ← lab-net-internal (NO gateway)
```

### How Routing Works

- `ping 8.8.8.8` → kernel checks routes. Not in any directly connected network → uses default gateway (172.18.0.1 on eth0) → goes out `lab-net-nat` → Docker NAT → internet
- `ping dvwa` → Docker DNS resolves `dvwa` to `172.19.0.2` → kernel checks routes. `172.19.0.0/16` is directly connected on eth1 → goes out `lab-net-internal` → reaches DVWA

Docker manages this automatically. The container doesn't need special configuration; the kernel's routing table handles traffic separation by destination IP.

---

## 5. The Docker Seccomp/Capability Problem

### The Initial Failure

```bash
analyst@kali:/$ nmap -sV dvwa
Starting Nmap 7.99 ...
Failed to open raw socket: Operation not permitted
```
nmap could not create raw sockets. It fell back to TCP Connect scan (`-sT`), which worked but was noisier. More critically, `tcpdump` and SYN scan (`-sS`) also failed — anything needing a raw socket was broken.

### Root Cause: Three Layers of Docker Security

Docker restricts containers at three levels:

| Layer | What it restricts | Default? |
|---|---|---|
| **Linux capabilities** | Privileged operations (raw sockets, mount, chown, etc.) | 14 capabilities granted (subset of root). `NET_RAW` and `NET_ADMIN` are NOT in the default set |
| **seccomp** (secure computing mode) | System calls (syscalls). Blocks dangerous ones even if the capability is granted | Default profile blocks `socket()` with `SOCK_RAW` family, `clone()` with certain flags, etc. |
| **User namespace** | UID mapping inside → outside container | Off by default |

**The trap:** `--cap-add=NET_RAW` grants the capability, but seccomp still blocks the syscall. Capabilities say "you may" but seccomp says "you can't." Both must be open.

### The Fix

```bash
docker run -dit --name kali \
  --security-opt seccomp=unconfined \
  --cap-add=NET_RAW \
  --cap-add=NET_ADMIN \
  --network none \
  --user analyst \
  kali-lab:with-msf
```

**What each flag does:**

| Flag | Effect | Risk |
|---|---|---|
| `--security-opt seccomp=unconfined` | Disables the seccomp filter. Allows ALL syscalls | Medium — attacker in container can use any syscall the kernel supports |
| `--cap-add=NET_RAW` | Grants raw socket capability | Low — raw sockets are needed for ICMP ping, SYN scan, packet crafting |
| `--cap-add=NET_ADMIN` | Grants network administration capability | Low — needed for tcpdump interface config, but allows changing firewall rules inside container |

### Why This Is Safe in a Lab

The container is the ATTACK machine, not the target. If the attack machine is compromised, the attacker already has the tools they need. The security restrictions here protect the HOST from the attack container — and we've opened enough for the security tools to work.

Targets like DVWA run with **default Docker restrictions** — no `--cap-add`, no seccomp override. If a target is compromised, the attacker inside it has fewer capabilities than inside Kali. This is intentional: targets are the thing being exploited, not the thing doing the exploiting.

---

## 6. The Connectivity Matrix

### What We Tested

A connectivity matrix is a table of every allowed and blocked flow in the lab. It turns "I think the isolation works" into "I have proven the isolation works."

| From | To | Method | Result | Meaning |
|---|---|---|---|---|
| Kali | Internet (8.8.8.8) | `ping -c 4 8.8.8.8` | ✅ 64 bytes, 129ms | Kali has outbound internet via NAT |
| Kali | DVWA (by name) | `ping -c 4 dvwa` | ✅ 64 bytes, 0.072ms | Docker DNS resolves container names |
| Kali | DVWA (by IP) | `ping -c 4 172.19.0.2` | ✅ reachable | Direct L2 connectivity |
| DVWA | Internet | `ping -c 4 8.8.8.8` | ❌ `Network is unreachable` | `--internal` blocks egress at kernel routing level |
| DVWA | Kali | `ping -c 4 172.19.0.3` | ✅ 64 bytes, 0.063ms | Same network, bidirectional |
| Host | DVWA (localhost:80) | `curl -I http://localhost:80` | ❌ Connection refused | No port mapping |
| Host | DVWA (by IP) | `curl -I http://172.19.0.2` | ✅ reachable | Docker bridge property — host CAN reach container IPs |
| Host | Kali (by IP) | `curl -I http://172.18.0.2` | ✅ reachable | Same Docker bridge property |

### What the Matrix Tells Us

**The good:**
- Targets cannot reach the internet (`--internal` blocks at kernel level, immediate `Network is unreachable`)
- Targets cannot reach the host (no port mapping, and host-initiated connections are one-way)
- Kali can reach both internet AND targets through separate interfaces

**The caveat:**
- The HOST can reach container IPs directly on both bridges (line 19–20). This is a Docker design property — the host is on every bridge network. Our safety relies on **no port mapping**, not on IP-level isolation. If someone adds `-p 80:80` to a target, the host exposes it.

### How to Read `ping` Responses

| Response | Meaning |
|---|---|
| `64 bytes from ...` | Host is up, ICMP is allowed |
| `Network is unreachable` | No route exists (kernel-level, instant — this is what `--internal` gives) |
| `Destination Host Unreachable` | Route exists, ARP failed (host is down or wrong network) |
| Hang / timeout | Route exists, host is up, but firewall drops ICMP |

---

## 7. What This Means for Future Sessions

The lab has a proven security boundary:

```
Internet → [lab-net-nat] → Kali → [lab-net-internal] → DVWA
                                      ↑
                               No gateway → no egress
                               No port mapping → no host exposure
```

**When we add more targets (WebGoat, Juice Shop),** they follow the same pattern:
```bash
docker run -dit --name webgoat --network lab-net-internal webgoat/webgoat
docker run -dit --name juice-shop --network lab-net-internal bkimminich/juice-shop
```

**When we run tcpdump evidence capture:** Kali needs `--cap-add=NET_ADMIN` (already added) and `seccomp=unconfined` (already added) to use raw sockets.

**When the lab is shared with someone else:** The safety rules are:
1. Never add `-p` to target containers
2. Never connect targets to `lab-net-nat`
3. Always verify with a ping test after adding new containers
4. Always stop all containers when the lab session ends

---

## 8. Evidence Saved

| File | Content |
|---|---|
| `evidence/2026-06-30-connectivity-matrix.txt` | 8 flow pairs tested, results, findings |
| `evidence/2026-06-30-nmap-dvwa.txt` | Full nmap scan output (service, scripts, OS) |

---

## 9. Key Takeaways

1. **Isolation is two layers:** `--internal` blocks egress (kernel routing), no `-p` blocks host ingress (no port listener). Both must be present.

2. **Docker DNS makes multi-container testing easy:** Container names resolve on user-defined bridges. `ping dvwa` works without knowing IPs.

3. **Docker has three security layers** (capabilities, seccomp, user namespace) and they interact. Granting a capability isn't enough if seccomp blocks the syscall. Fix: `--security-opt seccomp=unconfined` for the attack container.

4. **The connectivity matrix is the proof of isolation.** Without documented tests, "it's isolated" is an assumption, not a fact.

5. **The host can reach container IPs.** Don't assume IP-level isolation between host and containers — rely on port mapping (or lack thereof) for host safety.
