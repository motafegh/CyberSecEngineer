# Module 0.3 — Kali Linux Attack Workstation

> **Session:** Session 2 (2026-06-29)
> **Roadmap ref:** `PHASE-0-SECURE-LAB.md` §10 (Module 0.3)
> **Evidence:** `evidence/2026-06-29-session-2-kali-build.txt`
> **Session plan:** `session-plans/session-02-kali-and-targets.md`

---

## Part 1: Why an Attack Workstation

### The Problem

Security testing requires specialized tools: port scanners, exploitation frameworks, password crackers, web vulnerability scanners. Installing these on your daily machine is:

- **Dangerous** — these tools can be used destructively. A mistyped command or a malicious script could damage your system
- **Messy** — tools leave behind dependencies, configs, databases (Metasploit alone uses a PostgreSQL database and ~500MB of exploits)
- **Non-reproducible** — after months of ad-hoc installs, you'll have no clean way to start fresh

The solution: a **dedicated attack workstation** — a container or VM that exists only for security testing. When it gets messy or compromised, you throw it away and rebuild in seconds.

### Why Docker for Kali on WSL2

| Factor | Docker (this approach) | VirtualBox VM |
|---|---|---|
| Startup time | < 1 second | 2–5 minutes |
| Rebuild from scratch | `docker build` — 3 minutes | Reinstall from ISO — 30 minutes |
| Snapshot | Dockerfile IS the snapshot | Need VM snapshot feature |
| GPU passthrough | Not needed for CLI tools | Possible but complex |
| Works on WSL2? | ✅ Yes (Docker Desktop) | ❌ No nested virtualization |

Since we're on WSL2 (no nested virtualization for full VMs), Docker is the right choice. If we needed a GUI (e.g., Wireshark with a display), we could run an X server on Windows — but for CLI tools, Docker is perfect.

---

## Part 2: The Dockerfile — A Reproducible Recipe

### What is a Dockerfile?

A Dockerfile is a text file that serves as a **recipe** for building a container image. Every line is an instruction. Docker reads the file from top to bottom, executing each instruction to build a layer. The result is a complete, self-contained filesystem snapshot that can run anywhere Docker is installed.

### Our Dockerfile, Line by Line

```dockerfile
FROM kalilinux/kali-rolling
```

**What it does:** Sets the base image. Everything else builds on top of this.

**Why this base:** `kalilinux/kali-rolling` is the official Kali Linux Docker image. It's 120MB — a minimal Kali with just the base system. No tools pre-installed. Rolling release means you always get the latest packages.

```dockerfile
RUN apt update && apt install -y \
    nmap \
    netcat-openbsd \
    nikto \
    gobuster \
    dirb \
    ffuf \
    sqlmap \
    hydra \
    john \
    metasploit-framework \
    curl \
    wget \
    tcpdump \
    python3 \
    python3-pip \
    git \
    jq \
    ncat \
    socat \
    iproute2 \
    dnsutils \
    iputils-ping \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*
```

**What it does:** Updates package lists, installs 22 tools, then cleans up.

**Why these tools — categorized:**

| Category | Tool | What it does | When you'll use it |
|---|---|---|---|
| **Recon** | `nmap` | Port scanning — finds open ports and running services | Every engagement — first step |
| **Recon** | `netcat-openbsd` | Raw TCP/UDP connections | Banner grabbing, reverse shells, data exfiltration |
| **Web recon** | `nikto` | Web server vulnerability scanner | Checking for known web server CVEs |
| **Web recon** | `gobuster` | Directory/ DNS brute-force | Finding hidden paths on web apps |
| **Web recon** | `dirb` | Directory brute-force (different wordlists) | Same as gobuster — different dictionary |
| **Web fuzzing** | `ffuf` | Fast web fuzzer | Modern replacement — much faster for parameter fuzzing |
| **SQL injection** | `sqlmap` | Automated SQL injection | Exploiting database vulnerabilities |
| **Password attack** | `hydra` | Online brute-force (SSH, FTP, HTTP, etc.) | Testing weak credentials on live services |
| **Hash cracking** | `john` | John the Ripper — offline password cracking | Cracking stolen password hashes |
| **Exploitation** | `metasploit-framework` | Exploit development and execution | The industry standard exploitation framework |
| **HTTP** | `curl` | HTTP client | API testing, manual request crafting |
| **Download** | `wget` | File downloader | Pulling tools/payloads from the internet |
| **Packet capture** | `tcpdump` | Capture network traffic | Analyzing protocols, seeing what services send over the wire |
| **Scripting** | `python3`, `python3-pip` | General-purpose scripting | Writing custom scanners, parsers, automation |
| **Version control** | `git` | Clone repositories | Pulling tools/exploits from GitHub |
| **JSON parsing** | `jq` | Parse JSON from the command line | Processing API responses, log files |
| **Shells** | `ncat` | Enhanced netcat with SSL | Encrypted reverse shells, SSL proxies |
| **Relay** | `socat` | Connection relay and port forwarding | Setting up proxies, forwarding through jump hosts |
| **Networking** | `iproute2` | `ip`, `ss`, `tc` commands | Checking routing, sockets, traffic control |
| **DNS** | `dnsutils` | `dig`, `nslookup` | DNS troubleshooting, zone transfers |
| **Ping** | `iputils-ping` | `ping` | Network reachability testing |

**Why `&& apt clean && rm -rf /var/lib/apt/lists/*`:** Without this, the package lists stay in the image, making it ~50MB larger. This is standard Docker optimization — clean up after yourself in the same layer.

```dockerfile
RUN useradd -m -s /bin/bash analyst && \
    echo "analyst:analyst" | chpasswd
```

**What it does:** Creates a non-root user named `analyst` with password `analyst`.

**Why a non-root user:**

| Aspect | Running as root | Running as analyst |
|---|---|---|
| Container breakout impact | Attacker gets **root** on WSL2 | Attacker gets **analyst** user — needs another exploit to escalate |
| Accidentally destructive commands | `rm -rf /` succeeds | Most destructive commands fail (no permission) |
| Principle of least privilege | Violated | Followed |

The password `analyst` is lab-only — never a real credential.

```dockerfile
USER analyst
WORKDIR /home/analyst
```

**`USER analyst`:** Switches the default user. Every subsequent command (and container login) runs as `analyst`.

**`WORKDIR /home/analyst`:** Sets the working directory. When you `docker run -it kali-lab`, you land in `/home/analyst`.

```dockerfile
RUN mkdir -p reports evidence tools
```

**What it does:** Creates three directories in the analyst's home:
- `reports` — for saving scan results, exploitation output
- `evidence` — for packet captures, screenshots, proof files
- `tools` — for downloaded or custom scripts

```dockerfile
CMD ["/bin/bash"]
```

**What it does:** Sets the default command. When you run the container without specifying a command, it starts bash.

---

## Part 3: Build Process (What Happens When You Build)

When you run `docker build -t kali-lab .`, Docker:

1. **Pulls `kalilinux/kali-rolling`** if not already cached (already done ✅ — 120MB)
2. **Executes `apt update`** — downloads latest package lists (new layer, ~3 seconds)
3. **Downloads and installs 22 tools** — this is the slow step (2-4 minutes, ~600MB download)
4. **Cleans apt cache** — same layer, no size waste
5. **Creates `analyst` user** — lightweight layer
6. **Sets USER and WORKDIR** — metadata layers
7. **Creates reports/evidence/tools** — lightweight layer
8. **Sets CMD** — metadata layer
9. **Tags the result as `kali-lab:latest`**

**Layer caching:** If you change only the last few lines (e.g., add a tool), Docker reuses cached layers for everything before the change. Next builds will be much faster.

---

## Part 4: Image Size Breakdown

| Layer | Approximate size |
|---|---|
| Base Kali (kalilinux/kali-rolling) | 120MB |
| Installed tools (nmaps, metasploit, etc.) | ~600MB |
| User creation, directories, metadata | ~1MB |
| **Total** | **~1.1–1.3GB** |

This is a one-time download. After this, `docker run kali-lab` starts instantly.

---

## Part 5: Security Considerations

1. **The `docker` group is root-equivalent.** The `analyst` user inside the container is not root — but the user who runs `docker run` (you) has root access through the Docker socket.

2. **The Kali container shares WSL2's kernel.** A container breakout would give access to WSL2. Keep sensitive data outside mounted volumes.

3. **Metasploit's database.** Metasploit uses PostgreSQL. In the Docker image, this runs inside the container. Data persists only as long as the container lives (unless you mount a volume).

4. **Outbound internet.** The Kali container will be connected to `lab-net-nat` which has outbound internet. This is intentional — Kali downloads exploits, checks for updates, resolves DNS. The vulnerable targets will NOT have this access.

---

## Part 6: Usage — Running Kali After Build

```bash
# Interactive shell
docker run -it --rm kali-lab

# With network access
docker run -it --rm --network lab-net-nat kali-lab

# With a shared directory for evidence
docker run -it --rm -v /path/to/evidence:/home/analyst/evidence kali-lab
```

---

## Part 7: Common Mistakes

1. **Building without `--tag` or with wrong Dockerfile path** — `docker build -t kali-lab /wrong/path` fails. The path must point to the directory containing the Dockerfile.

2. **Forgetting `--rm`** — containers accumulate. Use `--rm` for disposable sessions.

3. **Running as root inside the container** — Our image defaults to `analyst`. But you can override with `docker run --user root -it kali-lab`. Don't do this unless you need to `apt install` something.

4. **Metasploit's first launch** — When you first run `msfconsole`, it initializes the database. This takes ~10 seconds on first run, then is instant.
