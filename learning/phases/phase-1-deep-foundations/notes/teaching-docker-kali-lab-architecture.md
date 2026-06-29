# Teaching Session: Docker, Kali & Lab Architecture

> **Date:** 2026-06-27
> **Context:** Fast-forward foundations before continuing Session 2
> **Status:** ✅ Completed

## [x] What is Docker?

**What it is / what happened:**
Docker runs **containers** — lightweight, isolated environments that share the host's Linux kernel. Containers are built from **images** (read-only templates/recipes).

| Concept | Analogy |
|---|---|
| **Image** | A cake recipe — defines ingredients & steps |
| **Container** | A baked cake — a running instance of the recipe |
| `docker build` | Create an image from a Dockerfile (recipe file) |
| `docker run` | Start a container from an image |
| `docker pull` | Download an image from Docker Hub (registry) |

**Why it matters / why it was done this way:**
- Containers share the host kernel → lightweight, start in seconds, use less RAM
- Each `docker run` starts clean → no state pollution on your host
- We avoid installing pentesting tools directly on Ubuntu (version conflicts, cleanup)

**Why the lab uses both Docker AND VirtualBox (future):**

| | Container | VM |
|---|---|---|
| Kernel | Shares host kernel | Own full OS kernel |
| Start time | ~2 seconds | ~2 minutes |
| Size | ~500MB-2GB | ~5-50GB |
| Isolation | Process-level | Hardware-level |
| Best for | Tools, web app targets (DVWA, etc.) | Full target OSes (Metasploitable, Windows AD) |

**Volumes** — mechanism to share files between host and container:
```bash
docker run -v /host/path:/container/path image
```
`-v` = volume flag. Maps a host directory into the container so files persist.

**Images persist after download** — only need internet once. After that, everything runs locally.

---

## [x] What is Kali Linux?

**What it is / what happened:**
Kali is a Debian-based Linux distro built specifically for penetration testing. Contains 600+ pre-installed security tools.

**Why it matters / why it was done this way:**
- Industry standard — every pentester uses it
- Tools pre-configured to work together (no dependency hunting)
- All documentation/tutorials assume Kali paths

**Tools installed in our `kali-tools` image:**

| Tool | Purpose |
|---|---|
| `nmap` | Port scanning — discover open ports & services |
| `netcat-openbsd` | Raw network connections (Swiss Army knife) |
| `nikto` | Web server vulnerability scanner |
| `gobuster` | Directory/file brute-force on web servers |
| `sqlmap` | Automated SQL injection detection & exploitation |
| `hydra` | Online password brute-force (SSH, FTP, HTTP forms) |
| `john` | Offline password hash cracking |
| `curl`, `wget` | HTTP/S request tools |
| `iproute2` | Network diagnostics (`ip`, `ss`) |
| `dnsutils` | DNS tools (`nslookup`, `dig`) |

---

## [x] Lab Architecture

**What it is / what happened:**
Our lab runs entirely in Docker on WSL2 (Windows Subsystem for Linux).

```
WSL2 (Ubuntu 24.04)
├── Docker Engine
│   ├── kali-tools (attacker)     ← runs tools, no target running here
│   ├── DVWA :8080                ← vulnerable PHP web app
│   ├── WebGoat :8081/WebGoat     ← vulnerable Java web app
│   └── Juice Shop :8082          ← vulnerable Node.js web app
```

**The universal attack pattern:**
1. Run a tool **FROM** Kali (`docker run -it kali-tools <tool>`)
2. Point it **AT** a target (`localhost:8080`, `localhost:8081`, etc.)
3. Observe the result

---

## [x] Debugging: Errors We Encountered & How We Fixed Them

### Error 1: nmap `Operation not permitted`

**Error message:**
```
/usr/bin/nmap: exec: /usr/lib/nmap/nmap: Operation not permitted
```

**Root cause:** Docker containers run with restricted Linux capabilities by default.
- `NET_RAW` (creating raw network packets) is denied
- Nmap needs raw sockets for SYN scans, FIN scans, etc.

**How we found the fix:**
1. Searched: `"nmap operation not permitted docker"`
2. Docker docs mention `--cap-add=NET_RAW`
3. Also needed `NET_ADMIN` for some scan types

**Fix applied:**
```bash
docker run --cap-add=NET_RAW --cap-add=NET_ADMIN kali-tools nmap ...
```

**Why it works:**
Linux capabilities let you grant specific kernel permissions instead of full root.
- `NET_RAW` = permission to create raw sockets
- `NET_ADMIN` = permission to configure network interfaces

### Error 2: `Failed to resolve "host.docker.internal"`

**Error message:**
```
Failed to resolve "host.docker.internal"
```

**Root cause:** `host.docker.internal` is a special DNS name Docker Desktop provides to let containers reach the host machine. On WSL2, it doesn't always resolve (depends on Docker Desktop version).

**How we found the fix:**
1. Checked container's routing table: `docker run kali-tools ip route`
2. Found default gateway: `default via 172.17.0.1 dev eth0`
3. Tested: nmap against `172.17.0.1` — worked

**Fix applied:**
```bash
docker run --rm --cap-add=NET_RAW --cap-add=NET_ADMIN kali-tools nmap -p 8080 172.17.0.1
```

### The General Debugging Process

1. **Read the error carefully** — identify the exact failure
2. **Identify the layer:** OS/kernel? Network? Application?
   - `Operation not permitted` = OS permission problem
   - `Failed to resolve` = DNS/network problem
3. **Search for error + context:** `"nmap operation not permitted docker"` not just `"nmap error"`
4. **Try simplest fix first** — escalate only if needed
5. **Verify** — re-run and check output changed

---

## [x] Running Kali Tools Against Targets (WSL2 Specific)

**The problem:** `localhost` inside a container refers to the container itself, not the WSL2 host.

**Solutions (try in order):**

```bash
# Option 1: Use default gateway IP (most reliable in WSL2)
docker run --rm --cap-add=NET_RAW --cap-add=NET_ADMIN kali-tools nmap -p 8080 172.17.0.1

# Option 2: host.docker.internal (works on some setups)
docker run --rm --cap-add=NET_RAW --cap-add=NET_ADMIN kali-tools nmap -p 8080 host.docker.internal
```

**Why nmap needs extra flags:**
- `--cap-add=NET_RAW` — nmap needs raw sockets to craft custom packets (SYN scan, etc.)
- `--cap-add=NET_ADMIN` — some scan types need network interface control

---

## [x] Container Lifecycle Commands

| Command | What it does |
|---|---|
| `docker compose up -d` | Start target apps in background (`-d` = detached) |
| `docker compose down` | Stop target apps |
| `docker ps` | List running containers |
| `docker images` | List downloaded images |
| `docker run -it kali-tools <cmd>` | Run a one-off Kali tool (`-it` = interactive terminal) |

**Key flags explained:**
- `-d` — detached: run in background, don't attach to output
- `-it` — interactive + TTY: gives you a terminal inside the container
- `-v` — volume: mount a host folder into the container
- `-p` — publish: map a container port to a host port (e.g., `8080:80`)
- `--rm` — remove container after exit (keeps disk clean)
