# Docker Deep Dive — Images, Layers, Caching, and Build Strategy

> **Date:** 2026-06-29 (Session 2 — derived from Kali build trial-and-error)
> **Cross-ref:** `notes/03-kali-build-trial-and-error.md` for the build journey

---

## 1. Image vs Container — The Core Distinction

This is the single most important Docker concept. Get this wrong and everything else is confusing.

### The Analogy

```
Image  →  Class (blueprint / recipe)
Container  →  Instance (running object / cooked meal)
```

| Concept | Image | Container |
|---|---|---|
| **What is it?** | A frozen filesystem snapshot + metadata | A running process with its own filesystem, network, and memory |
| **Mutable?** | ❌ Immutable — never changes after creation | ✅ Mutable — you can write files, install packages, delete data |
| **Size** | Fixed (e.g., 3.51 GB on disk) | Starts at ~0 extra (writable layer grows as you create files) |
| **Persistence** | Survives reboots, machine shutdowns, forever | Ephemeral — deleted when you `docker rm` (unless committed) |
| **Command** | `docker images` | `docker ps` (running) / `docker ps -a` (all) |
| **Create from** | `docker build` or `docker pull` | `docker run` (from an image) |

### How They Connect

```bash
# Image lives on disk
docker images kali-lab:with-msf

# Container is a running instance of that image
docker run -it --user analyst kali-lab:with-msf
# You now have:
#   kali-lab:with-msf (image — frozen, 3.51 GB)
#   + thin writable layer (container — empty, grows as you work)
#   + bash process (running)
```

### The Writable Layer

When a container runs, Docker adds a **thin writable layer** on top of the image layers. This is Copy-on-Write (CoW):

- Read a file → Docker reads from the image layer (fast, no copy)
- Modify a file → Docker copies it UP to the writable layer, then modifies it there (slower, only on write)
- Delete a file → Docker places a "whiteout" marker in the writable layer (file appears gone, but still exists in the image layer below)
- Create a new file → Stored entirely in the writable layer

**Critical implication:** If you `exit` and `docker run` again from the same image, you get a **fresh** writable layer. All changes from the previous session are gone (unless you committed).

```bash
docker run -it kali-lab:with-msf
  → Inside: touch evidence/found.txt
  → exit

docker run -it kali-lab:with-msf
  → Inside: ls evidence/
  → Empty! found.txt is gone — it was in the old writable layer
```

### Saving Changes — docker commit

```bash
docker commit <container-id> kali-lab:with-msf:v2
```

This freezes the container's writable layer into a new image layer. The new image now has the changes baked in permanently.

---

## 2. Docker Layers — How Images Are Built

### What Is a Layer?

Each instruction in a Dockerfile creates a **layer** — the difference (delta) from the previous state.

```dockerfile
FROM ubuntu:22.04           # Layer 0: base (~77 MB)
RUN apt update               # Layer 1: new package index files (~50 MB delta)
RUN apt install -y nmap      # Layer 2: nmap + dependencies (~80 MB delta)
RUN rm -rf /var/lib/apt/*    # Layer 3: deletion markers (~0 bytes, but Layer 1 still exists)
```

### Layers Are Additive, NEVER Subtractive

This is the most important rule and the most common source of confusion:

```
Final Image ≠ Layer 0 + Layer 1 + Layer 2 + Layer 3
Final Image = Layer 0 OVERLAYED with Layer 1 OVERLAYED with Layer 2 OVERLAYED with Layer 3
```

You can think of layers as stacked transparencies. Layer 3 can "cover up" something in Layer 1, but Layer 1's data is STILL THERE in the image file. The image size is the sum of all layers, not the visible filesystem size.

**Concrete example of waste:**

```dockerfile
# BAD — 2 RUN commands
RUN apt update && apt install -y nmap    # Layer 1: ~250 MB (includes .deb cache in /var/cache/apt)
RUN apt clean && rm -rf /var/lib/apt/*   # Layer 2: hides the cache, but Layer 1 still contains it
# Final image size: ~250 MB from Layer 1 + Layer 2 metadata

# GOOD — 1 RUN command
RUN apt update && apt install -y nmap && apt clean && rm -rf /var/lib/apt/*
# Layer 1: ~60 MB (tools only, cache deleted in same step)
# Final image size: ~60 MB
```

### Layer Caching

Docker caches each layer after a successful build by its **instruction hash** (the exact text of the RUN command + the previous layer's hash).

```bash
docker build -t my-image .  # Layer 0 → Layer 1 → Layer 2 → Layer 3 → DONE

docker build -t my-image .  # Same Dockerfile → ALL CACHED → instant
```

**When a layer changes, all subsequent layers are INVALIDATED:**

```dockerfile
FROM ubuntu:22.04           # CACHED
RUN apt update               # CACHED  
RUN apt install -y nmap      # CACHED
RUN apt install -y hydra     # ← NEW LINE: Layer 3 hash changed
                            #   → Layer 3 invalidated, must rebuild
                            #   → Layer 4 (if exists) also invalidated
```

**But if a build FAILS, nothing is cached for that RUN:**

```bash
docker build .
  → RUN apt install -y nmap hydra ... (starts, fails at 300s, exit code 100)
  → Layer NOT cached

docker build . --network host
  → RUN apt install -y nmap hydra ... (runs from scratch, downloads everything again)
  → This is why we re-downloaded 564 MB
```

### Layer Caching and Build Failures

If you have a package that reliably fails (like metasploit on apt mirrors), **split it into its own RUN command**:

```dockerfile
# Layer 1: reliable tools — CACHED after first success
RUN apt update && apt install -y \
    nmap hydra john curl wget git \
    && rm -rf /var/lib/apt/lists/*

# Layer 2: problematic tool — only this reruns on failure
RUN apt update && apt install -y \
    metasploit-framework \
    && rm -rf /var/lib/apt/lists/*
```

If Layer 2 fails, Layer 1 stays cached. Fix Layer 2 (switch to git clone or change mirror), rebuild — Layer 1 doesn't re-download.

**Tradeoff:** Two `apt update` commands = downloading package indexes twice (~21 MB each time). Acceptable for the resilience gain.

---

## 3. BuildKit — Modern Docker Build Engine

### What Is BuildKit?

BuildKit is the next-generation Docker build engine. It replaced the legacy builder in Docker Desktop starting 2022. Key improvements:

| Feature | Legacy Builder | BuildKit |
|---|---|---|
| Layer caching | By instruction hash | By instruction hash + content hash |
| Concurrent builds | No | Yes (independent stages in parallel) |
| Cache mounts | ❌ | ✅ — persists data across builds |
| SSH mounts | ❌ | ✅ — pass SSH agent securely |
| Secret mounts | ❌ | ✅ — pass credentials without leaving them in layers |
| Skip unused stages | No | Yes (automatically) |

### Cache Mounts — The Game-Changer for Package Installs

A cache mount persists a directory across builds, even if the build fails:

```dockerfile
# syntax=docker/dockerfile:1.4
FROM kalilinux/kali-rolling

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    apt update && apt install -y nmap hydra john curl wget git
```

**What this does differently:**
- `/var/cache/apt` is NOT committed to the image layer — it's a build-time cache
- If the build fails and you rebuild, the cached `.deb` files are still there
- apt only downloads packages that aren't already cached
- The cache persists across your machine — survives `docker builder prune` only if explicitly told

**Why we didn't use it:**
- Requires `# syntax=docker/dockerfile:1.4` directive at the top of the Dockerfile
- Requires knowing about the feature — it's not in most Docker tutorials
- Most users discover it only after hitting the exact problem we did

### How to Enable BuildKit

```bash
# Option 1: Set environment variable
DOCKER_BUILDKIT=1 docker build -t my-image .

# Option 2: Default in Docker Desktop (already enabled)
docker build -t my-image .  # Uses BuildKit by default
```

---

## 4. When to Abort an Approach — Recognizing Failure Patterns

This is meta-learning — not a Docker technical concept, but a skill for debugging any system.

### The Two-Failure Rule

**If the same operation fails the same way twice, the approach is wrong, not the execution.**

| Attempt | Method | Result | Lesson |
|---|---|---|---|
| 1 | `docker build` (bridge) | Apt mirror timeout | Network is bottleneck, but maybe transient |
| 2 | `docker run` + `apt install` (host network) | Same mirror timeout for same package | **Pattern confirmed** — apt for msf is broken, not network |
| 3 | `gem install` | Empty stub | Different method, different failure — worth trying |
| 4 | Rapid7 repo (new attempt) | GPG key missing | Infrastructure issue, fixable |
| 5 | `git clone` + `bundle install` | Missing 3 C headers | Fixable with `-dev` packages |

Attempts 1 and 2 should have been the signal to stop trying apt for msf.

### Specific Signals That Mean "Switch Methods"

| Signal | Example | What It Means |
|---|---|---|
| Same package, different mirrors | `Ign:443` from kali.download, then ionos.com | The package itself is the problem, not the mirror |
| Same error at same byte count | Always fails at exactly 58% or 322 MB | Connection is throttled at that point |
| Other packages from same mirror succeed | 468/469 packages installed from kali.download | The mirror works — this specific file is missing or broken |
| Error is infrastructure, not content | "gpg: command not found" | Base image is missing a tool we assumed was there |
| Download succeeds but install fails | `gem install` said "128 gems installed" but directory empty | Version incompatibility — gem is a stub |

### Preemptive Strategies

1. **Test a single package before the full install:**
   ```bash
   apt install -y --dry-run metasploit-framework
   # Tells you what would be installed without downloading anything
   ```

2. **Check if the .deb exists before committing to the install:**
   ```bash
   curl -sI http://kali.download/kali/pool/main/m/metasploit-framework/metasploit-framework_6.4.135-0kali1_amd64.deb
   # Check HTTP status (200 = exists, 404 = missing)
   ```

3. **Separate risky packages into their own layer** (as shown above in section 2)

---

## 5. The Full Build Architecture — What We Ended Up With

### Two-Phase Build Process

**Phase 1 — Dockerfile (reproducible, rebuilt anytime):**
```dockerfile
FROM kalilinux/kali-rolling
RUN apt update && apt install -y \
    nmap netcat-openbsd nikto gobuster dirb ffuf \
    sqlmap hydra john sudo curl wget tcpdump \
    python3 python3-pip git jq ncat socat \
    iproute2 dnsutils iputils-ping \
    && apt clean && rm -rf /var/lib/apt/lists/*
RUN useradd -m -s /bin/bash analyst && \
    echo "analyst:analyst" | chpasswd && \
    usermod -aG sudo analyst
USER analyst
WORKDIR /home/analyst
RUN mkdir -p reports evidence tools
CMD ["/bin/bash"]
```

**Phase 2 — Manual (committed, not reproducible from Dockerfile alone):**
```bash
# Start container as root
docker run -it --network host --user root kali-lab

# Inside container:
apt install -y libyaml-dev libffi-dev libpq-dev libpcap-dev libsqlite3-dev build-essential
git clone --depth 1 https://github.com/rapid7/metasploit-framework /opt/metasploit-framework
cd /opt/metasploit-framework
gem install bundler
bundle install
gem install xmlrpc -v 0.3.3 --no-document
bundle install  # completes after xmlrpc fix
ln -s /opt/metasploit-framework/msfconsole /usr/local/bin/msfconsole
ln -s /opt/metasploit-framework/msfvenom /usr/local/bin/msfvenom
ln -s /opt/metasploit-framework/msfdb /usr/local/bin/msfdb

# Exit and commit
exit
docker commit $(docker ps -lq) kali-lab:with-msf
```

### Image Layer Structure (Final)

```
kali-lab:with-msf (3.51 GB)
├── Layer 0: kalilinux/kali-rolling (1.2 GB) — base OS
├── Layer 1: apt tools + clean (1.3 GB delta) — 22 tools, no cached debs
├── Layer 2: useradd + usermod + sudo (10 KB) — analyst user
├── Layer 3-5: USER, WORKDIR, CMD, mkdir (metadata, ~0)
├── Layer 6 (committed): msf source + 250 gems (2 GB delta)
│   ├── /opt/metasploit-framework/ (source code, git repo)
│   ├── /var/lib/gems/3.3.0/ (250 Ruby gems, includes compiled C extensions)
│   ├── /usr/local/bin/msf* (symlinks)
│   ├── /usr/bin/sudo (installed in commit layer)
│   └── /usr/include/* (dev headers — libyaml-dev, libffi-dev, libpq-dev)
```

**Note on dev headers:** The `-dev` packages (libyaml-dev, libffi-dev, libpq-dev) are in the committed layer. They're not needed at runtime — only for compiling gems. A cleaner image would `apt remove` them after building. But since they're only ~18 MB total and the image is for a lab (not production), it's acceptable.

---

## 6. Quick Reference

```bash
# Image management
docker images                          # List all images
docker image rm kali-lab:with-msf      # Delete image (WARNING: can't undo)
docker image prune                     # Delete dangling (untagged) images

# Container management
docker ps                              # Running containers only
docker ps -a                           # All containers (including stopped)
docker rm <container-id>               # Delete a container
docker container prune                 # Delete all stopped containers

# Building
docker build --network host -t tag .   # Build with host networking
docker commit <id> tag                 # Save container state as new image

# Running
docker run -it image                   # Interactive, with terminal
docker run -it --user user image       # Run as specific user
docker run -it --network host image    # Run with host networking

# Inspection
docker history image                   # See layers and their sizes
docker exec <container-id> command     # Run command in running container
docker logs <container-id>             # See container's stdout/stderr

# BuildKit (modern builder)
DOCKER_BUILDKIT=1 docker build .       # Explicitly enable BuildKit
# syntax=docker/dockerfile:1.4         # Add to top of Dockerfile for cache mounts
```
