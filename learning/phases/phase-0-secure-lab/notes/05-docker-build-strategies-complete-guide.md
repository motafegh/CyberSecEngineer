# Docker Build Strategies — Complete Educational Guide

> **Date:** 2026-06-29
> **Prerequisites:** Basic Docker knowledge (image vs container, Dockerfile syntax)
> **Cross-ref:** `notes/03-kali-build-trial-and-error.md` for the real-world context that motivated this
> **Status:** Complete

---

## Table of Contents

1. [Strategy 1: Single Dockerfile RUN](#strategy-1-single-dockerfile-run)
2. [Strategy 2: BuildKit Cache Mounts](#strategy-2-buildkit-cache-mounts)
3. [Strategy 3: Split RUNs (Layered Install)](#strategy-3-split-runs-layered-install)
4. [Strategy 4: Lean Dockerfile + Container CLI + Commit](#strategy-4-lean-dockerfile--container-cli--commit)
5. [Strategy 5: Multi-Stage Builds](#strategy-5-multi-stage-builds)
6. [Strategy 6: Pre-Built Base Images](#strategy-6-pre-built-base-images)
7. [Decision Matrix — Which Strategy When?](#decision-matrix--which-strategy-when)
8. [Quick Reference](#quick-reference)

---

## The Problem

We needed to build a Docker image with Kali Linux + 22 security tools + Metasploit Framework (total ~3.5 GB). The straightforward approach failed because:

1. **apt mirrors timed out** on long downloads (default Docker bridge NAT)
2. **metasploit-framework deb** (522 MB) was unreachable on all Kali mirrors
3. **gem install** produced an empty stub
4. **Rapid7 repo** had GPG chicken-and-egg problems
5. **Direct .deb download** — wrong URL

This guide documents all 6 possible strategies for such a scenario, from simplest to most sophisticated.

---

## Strategy 1: Single Dockerfile RUN

### What It Is

All packages installed in one `RUN apt` command in the Dockerfile.

### The Code

```dockerfile
FROM kalilinux/kali-rolling

RUN apt update && apt install -y \
    nmap netcat-openbsd nikto gobuster dirb ffuf \
    sqlmap hydra john sudo curl wget tcpdump \
    python3 python3-pip git jq ncat socat \
    iproute2 dnsutils iputils-ping \
    metasploit-framework \
    && apt clean && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash analyst && \
    echo "analyst:analyst" | chpasswd && \
    usermod -aG sudo analyst

USER analyst
WORKDIR /home/analyst
RUN mkdir -p reports evidence tools
CMD ["/bin/bash"]
```

### How It Works Step by Step

1. Docker reads `FROM` → pulls base image (`kalilinux/kali-rolling`, 1.2 GB)
2. Docker reads `RUN apt update && apt install -y ...` → starts a temporary container
3. Inside the container: `apt update` downloads package indexes (21 MB)
4. Inside the container: `apt install -y` resolves dependencies (469 packages, 832 MB)
5. Inside the container: downloads all 832 MB from apt mirrors in parallel
6. Inside the container: `apt clean` removes cached `.deb` files
7. Inside the container: `rm -rf /var/lib/apt/lists/*` removes package indexes
8. Docker freezes the container's filesystem as a new layer
9. Docker reads `RUN useradd ...` → starts another temp container from the new layer
10. ... continues for each instruction

### Layer Structure

```
kali-lab (2.53 GB)
├── Layer 0: kalilinux/kali-rolling (1.2 GB)
├── Layer 1: apt install + clean (1.33 GB delta)
│   ├── /usr/bin/nmap, /usr/bin/hydra, ...
│   ├── /var/lib/dpkg/ (package database)
│   └── /etc/ (config files)
├── Layer 2: useradd + chpasswd + usermod (~10 KB)
├── Layer 3: USER analyst (metadata, 0 bytes)
├── Layer 4: WORKDIR /home/analyst (metadata, 0 bytes)
├── Layer 5: mkdir reports evidence tools (0 bytes)
└── Layer 6: CMD (metadata, 0 bytes)
```

### Pros

- **Simple** — one command, everything in one place
- **Reproducible** — anyone with Docker can build the exact same image
- **CI/CD friendly** — works in automated pipelines

### Cons

- ALL packages download together — one failure breaks the entire build
- No caching across builds if any part fails
- No way to resume a failed build — everything re-downloads

### When to Use

- Small, simple images (<10 packages, <500 MB total)
- Packages from reliable mirrors
- Development environments where build time isn't critical

### When NOT to Use

- Large packages from unreliable mirrors (like our msf scenario)
- Packages split across multiple repositories
- Any situation where a partial build failure is likely

---

## Strategy 2: BuildKit Cache Mounts

### What It Is

BuildKit is Docker's modern build engine (replaced legacy builder in Docker Desktop 2022+). It adds features like **cache mounts** — directories that persist across builds even if the build fails.

### Prerequisites

BuildKit is enabled by default in Docker Desktop. To verify:
```bash
docker buildx version
# docker buildx v0.xx.x
```

If not enabled:
```bash
export DOCKER_BUILDKIT=1
# Or set it permanently in ~/.docker/config.json
```

### The Code

```dockerfile
# syntax=docker/dockerfile:1.4
FROM kalilinux/kali-rolling

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    apt update && apt install -y \
    nmap netcat-openbsd nikto gobuster dirb ffuf \
    sqlmap hydra john sudo curl wget tcpdump \
    python3 python3-pip git jq ncat socat \
    iproute2 dnsutils iputils-ping \
    metasploit-framework \
    && rm -rf /var/lib/apt/lists/*
```

**Three key additions vs Strategy 1:**

**1. `# syntax=docker/dockerfile:1.4`**
This tells Docker to use the latest Dockerfile syntax parser (needed for cache mount features). Without this line, BuildKit falls back to legacy parser and the `--mount` flags are ignored.

**2. `--mount=type=cache,target=/var/cache/apt,sharing=locked`**
Mounts a persistent cache directory at `/var/cache/apt` (where apt stores downloaded `.deb` files). The `sharing=locked` means only one build process can access the cache at a time (prevents corruption when multiple builds run concurrently).

**3. `--mount=type=cache,target=/var/lib/apt/lists,sharing=locked`**
Mounts a persistent cache for the package index files. Normally `apt update` downloads these fresh every time. With this mount, they persist and only need to be updated (not re-downloaded entirely).

### How Cache Mounts Differ from Image Layers

| | Regular Layer | Cache Mount |
|---|---|---|
| **Where stored** | In the image (permanent) | In BuildKit's cache (not in image) |
| **Included in final image?** | ✅ Yes | ❌ No |
| **Survives build failure?** | ❌ No | ✅ Yes |
| **Can be shared across builds?** | ❌ No (each build creates new layer) | ✅ Yes |
| **Can be manually cleared?** | `docker image rm` | `docker builder prune` |

### How It Works Step by Step

**First build (no cache exists):**
1. BuildKit checks if any cache exists at the mount targets → none found
2. Creates empty cache directories
3. Runs `apt update` → downloads package indexes → stored in `/var/lib/apt/lists` cache
4. Runs `apt install` → downloads packages → stored in `/var/cache/apt` cache
5. Build succeeds → layers committed to image, cache directories are NOT included in image

**Second build (cache exists, no changes):**
1. BuildKit finds cached `/var/lib/apt/lists` → no re-download needed for `apt update`
2. BuildKit finds cached `/var/cache/apt` → no re-download for already-cached packages
3. **Build is instant** — all layers come from cache

**Build failure with cache (our scenario):**
1. Build starts, first 468 packages download fine → cached
2. `metasploit-framework` (522 MB) fails → build stops at exit code 100
3. **However:** the 564 MB already downloaded is SAFE in the cache mount
4. Fix the issue (different mirror, different method for msf)
5. Rebuild → BuildKit uses cached packages → ONLY re-downloads missing/corrupt packages

### Layer Structure

```
kali-lab (2.53 GB)
├── Layer 0: kalilinux/kali-rolling (1.2 GB)
├── Layer 1: apt install + clean (1.33 GB delta)
│   ├── /usr/bin/nmap, /usr/bin/hydra, ...
│   └── Cache mounts NOT included in this layer
├── [rest same as Strategy 1]
```

Plus on the build host:
```
/tmp/buildkit-cache/apt/          ← ~500 MB (NOT in image, only on builder's disk)
/tmp/buildkit-cache/apt-lists/    ← ~21 MB
```

### Additional Cache Mount Tricks

**Sharing modes:**
```dockerfile
# shared: multiple concurrent builds share the cache (default)
RUN --mount=type=cache,target=/var/cache/apt,sharing=shared ...

# locked: only one build at a time (safe for apt)
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked ...

# private: each build gets its own copy
RUN --mount=type=cache,target=/var/cache/apt,sharing=private ...
```

**Cache from specific source (CI/CD):**
```dockerfile
# Use cache from a previous build, even on different machine
RUN --mount=type=cache,from=my-cache-image,source=/var/cache/apt,target=/var/cache/apt ...
```

### Pros

- **Resumes failed builds** — no re-downloading packages that already succeeded
- **Speeds up repeated builds** — `apt update` is instant after first run
- **Cache isn't in the image** — no wasted space from cached debs
- **Transparent** — same Dockerfile, just add mount flags

### Cons

- **Requires BuildKit** — legacy Docker builder ignores mount flags silently
- **Requires `# syntax=docker/dockerfile:1.4`** — easy to forget
- **Cache stored on builder disk** — can grow large if not pruned
- **Not a magic fix** — if the mirror is fundamentally unreachable, caching won't help (you still can't get the file)

### When to Use

- Any large build (>1 GB) where network failures are possible
- CI/CD pipelines where build time = money
- Development workflows with frequent rebuilds
- Any build with unreliable package mirrors

### When NOT to Use

- Legacy Docker environments without BuildKit
- Builds that must not cache sensitive data (cache mounts can be inspected)
- Very simple builds (<10 packages) where caching adds complexity with no benefit

### Pruning the Cache

```bash
docker builder prune                    # Remove all unused build cache
docker builder prune --filter type=exec.cachemount   # Only cache mounts, not other BuildKit cache
docker builder prune --all             # Remove everything (use with caution)
```

---

## Strategy 3: Split RUNs (Layered Install)

### What It Is

Instead of one `RUN apt install` for all packages, split them into multiple RUN commands. Reliable packages go in early layers (cached after first success). Unreliable packages go in later layers (only those re-run on failure).

### The Code

```dockerfile
FROM kalilinux/kali-rolling

# Layer 1: absolutely reliable tools
RUN apt update && apt install -y \
    nmap curl wget tcpdump python3 python3-pip git jq socat \
    iproute2 dnsutils iputils-ping netcat-openbsd ncat \
    && rm -rf /var/lib/apt/lists/*

# Layer 2: still reliable, but separated for logical grouping
RUN apt update && apt install -y \
    nikto gobuster dirb ffuf sqlmap hydra john sudo \
    && rm -rf /var/lib/apt/lists/*

# Layer 3: the problematic package — isolated so failure doesn't affect others
RUN apt update && apt install -y \
    metasploit-framework \
    && rm -rf /var/lib/apt/lists/*
```

### How Layer Caching Works

```
Build 1: Layer 1 ✅  Layer 2 ✅  Layer 3 ❌ (msf failed)
         CACHED      CACHED      NOT CACHED

Build 2 (switch msf to git clone):
         Layer 1 CACHED  Layer 2 CACHED  Layer 3 REBUILT
         (no download)   (no download)   (git clone + bundle install)
```

**If Layer 3 fails, Layers 1 and 2 are still cached. They are NEVER re-downloaded.**

### The Cost of This Strategy

Each `apt update` re-downloads the package indexes (~21 MB). So 3 layers = 3 × 21 MB = 63 MB extra per build.

**Mitigation:** Combine with BuildKit cache mounts:
```dockerfile
# syntax=docker/dockerfile:1.4
FROM kalilinux/kali-rolling

RUN --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    apt update && apt install -y nmap curl wget \
    && rm -rf /var/lib/apt/lists/*
# ^^ apt update uses cache → no re-download for subsequent layers

RUN --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    apt update && apt install -y hydra john sqlmap \
    && rm -rf /var/lib/apt/lists/*
```

### Pros

- **Granular caching** — each layer is independently cached
- **No special Docker features needed** — works with any builder
- **Clear organization** — logical separation of concerns

### Cons

- **More Dockerfile lines** — not as clean as one big RUN
- **Re-downloads apt indexes** — each RUN needs `apt update` (except with BuildKit)
- **More image layers** — technically more layers (Docker has a 128-layer limit, not an issue here)

### When to Use

- Large builds with mixed reliability packages
- When BuildKit isn't available (legacy CI/CD)
- Development builds where you're iterating on the problematic package

---

## Strategy 4: Lean Dockerfile + Container CLI + Commit

### What It Is

Build a minimal Dockerfile (only reliable packages). Then start a container, install the remaining tools interactively via CLI commands, and save the result as a new image with `docker commit`.

### The Code

**Phase 1 — Dockerfile (reliable only):**
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

**Phase 2 — Build the base image:**
```bash
docker build --network host -t kali-lab /path/to/Dockerfile
```

**Phase 3 — Start container and install the rest:**
```bash
docker run -it --network host --user root kali-lab

# Inside the container (as root):
apt install -y libyaml-dev libffi-dev libpq-dev libpcap-dev libsqlite3-dev build-essential
git clone --depth 1 https://github.com/rapid7/metasploit-framework /opt/metasploit-framework
cd /opt/metasploit-framework
gem install bundler
bundle install
gem install xmlrpc -v 0.3.3 --no-document
bundle install
ln -s /opt/metasploit-framework/msfconsole /usr/local/bin/msfconsole
ln -s /opt/metasploit-framework/msfvenom /usr/local/bin/msfvenom
ln -s /opt/metasploit-framework/msfdb /usr/local/bin/msfdb
usermod -aG sudo analyst

exit
```

**Phase 4 — Commit the container as a new image:**
```bash
docker commit $(docker ps -lq) kali-lab:with-msf
```

### Automating Phase 3 (semi-reproducible)

Instead of typing commands manually, write a setup script and run it inside the container:

```bash
# save-setup.sh
docker run -it --user root kali-lab bash -c "
set -e
apt install -y libyaml-dev libffi-dev libpq-dev libpcap-dev libsqlite3-dev build-essential
git clone --depth 1 https://github.com/rapid7/metasploit-framework /opt/metasploit-framework
cd /opt/metasploit-framework
gem install bundler
bundle install
gem install xmlrpc -v 0.3.3 --no-document
bundle install
ln -s /opt/metasploit-framework/msfconsole /usr/local/bin/msfconsole
ln -s /opt/metasploit-framework/msfvenom /usr/local/bin/msfvenom
ln -s /opt/metasploit-framework/msfdb /usr/local/bin/msfdb
"
docker commit $(docker ps -lq) kali-lab:with-msf
```

### What We Actually Get vs What We Want

```
kali-lab:latest             → 2.53 GB, no msf, can rebuild from Dockerfile
kali-lab:with-msf           → 3.51 GB, has msf, CANNOT rebuild from Dockerfile (needs commit)
```

The `with-msf` image is a **pre-built artifact** — you can't get it from `docker build` alone.

### Pros

- **Maximum flexibility** — can do ANYTHING inside the container (git clone, compile, download)
- **No dependency on Dockerfile features** — works with any Docker version
- **Full debugging** — see errors in real-time in an interactive shell
- **The only approach that worked for us** — because apt mirrors were fundamentally unreachable for msf

### Cons

- **NOT reproducible** — if someone deletes the image, you can't rebuild from the Dockerfile alone
- **Requires manual steps** — or a script that mimics the manual steps
- **Larger image** — includes dev packages, build tools, git history (unless you clean up before commit)
- **State drift risk** — the committed image is a snapshot of what you did, not what you intended

### Making It More Reproducible

Keep the setup script version-controlled:
```
kali-lab/
├── Dockerfile              # For the base image
├── setup.sh                # Script to run inside container for msf
└── README.md               # Instructions: "Run setup.sh then commit"
```

Then rebuilding is:
```bash
docker build --network host -t kali-lab .
bash setup.sh
docker commit $(docker ps -lq) kali-lab:with-msf
```

---

## Strategy 5: Multi-Stage Builds

### What It Is

Docker multi-stage builds use **multiple `FROM` statements** in a single Dockerfile. Each `FROM` starts a new stage. You can copy artifacts from earlier stages into later stages. The final image only contains what's explicitly copied — build tools, temporary files, and dependencies from earlier stages are discarded.

### The Code

```dockerfile
# syntax=docker/dockerfile:1.4

# ============================================================
# Stage 1: Builder — compile/build everything needed
# ============================================================
FROM kalilinux/kali-rolling AS builder

# Install build dependencies (these will NOT be in the final image)
RUN apt update && apt install -y \
    git ruby-dev build-essential \
    libyaml-dev libffi-dev libpq-dev libpcap-dev libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone and build Metasploit
WORKDIR /opt
RUN git clone --depth 1 https://github.com/rapid7/metasploit-framework
WORKDIR /opt/metasploit-framework
RUN gem install bundler && \
    bundle install && \
    gem install xmlrpc -v 0.3.3 --no-document && \
    bundle install

# Create symlinks
RUN ln -s /opt/metasploit-framework/msfconsole /usr/local/bin/msfconsole && \
    ln -s /opt/metasploit-framework/msfvenom /usr/local/bin/msfvenom && \
    ln -s /opt/metasploit-framework/msfdb /usr/local/bin/msfdb

# ============================================================
# Stage 2: Runtime — only what's needed to RUN the tools
# ============================================================
FROM kalilinux/kali-rolling

# Install runtime tools (only tools, no dev packages)
RUN apt update && apt install -y \
    nmap netcat-openbsd nikto gobuster dirb ffuf \
    sqlmap hydra john sudo curl wget tcpdump \
    python3 python3-pip git jq ncat socat \
    iproute2 dnsutils iputils-ping \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Copy Metasploit from the builder stage (ONLY what's needed)
COPY --from=builder /opt/metasploit-framework /opt/metasploit-framework
COPY --from=builder /usr/local/bin/msf* /usr/local/bin/
COPY --from=builder /var/lib/gems/3.3.0 /var/lib/gems/3.3.0
COPY --from=builder /usr/lib/x86_64-linux-gnu/ruby /usr/lib/x86_64-linux-gnu/ruby

# Setup user
RUN useradd -m -s /bin/bash analyst && \
    echo "analyst:analyst" | chpasswd && \
    usermod -aG sudo analyst

USER analyst
WORKDIR /home/analyst
RUN mkdir -p reports evidence tools

CMD ["/bin/bash"]
```

### What Gets Discarded vs What Gets Kept

**Builder stage (DISCARDED from final image):**
- `git` binary and its dependencies
- `build-essential` (gcc, make, etc.)
- All `-dev` packages (libyaml-dev, libffi-dev, etc.)
- `/var/cache/apt/` — downloaded .deb files
- `/opt/metasploit-framework/.git/` — git history
- `/root/.gem/` — gem build cache
- All temporary compilation artifacts

**Runtime stage (KEPT in final image):**
- /opt/metasploit-framework/ (source code, minus .git)
- /usr/local/bin/msf* (binaries and symlinks)
- /var/lib/gems/3.3.0/ (Ruby gems and compiled C extensions)
- /usr/lib/x86_64-linux-gnu/ruby/ (Ruby shared libraries)
- All 22 apt tools (nmap, hydra, etc.)
- analyst user and work directories

### Why This Gives a Smaller Image

Compare:

| Strategy | Image Size | What's in it |
|---|---|---|
| 4 (commit) | 3.51 GB | dev packages, gem build cache, git history |
| 5 (multi-stage) | ~3.2 GB | **No dev packages**, no build cache, no git history |

The difference is ~300 MB saved by isolating build tools from the runtime image.

### How Multi-Stage Builds Execute

```
Docker reads the Dockerfile:

Stage 1 "builder":
  FROM kalilinux/kali-rolling  ───┐
  RUN apt install git ruby-dev...  │  Temp container 1
  RUN git clone...                │  Runs to completion
  WORKDIR ...                     │  Stops, saved as "builder" stage
  RUN bundle install...           │
  RUN ln -s ...                  ─┘

Stage 2 "runtime":
  FROM kalilinux/kali-rolling  ───┐
  RUN apt install nmap hydra...   │  Temp container 2 (FRESH START)
  COPY --from=builder ...         │  Copies files from Stage 1's filesystem
  RUN useradd ...                 │  Container runs, stops
  ...                             │
  CMD ...                        ─┘

Final image = Stage 2 ONLY
Stage 1 is discarded (not in final image, just used temporarily on builder's disk)
```

### Build Command

Same as a single-stage build:
```bash
docker build --network host -t kali-lab:multi-stage /path/to/Dockerfile
```

**No special flags needed.** Docker automatically identifies and executes the multi-stage pattern.

### Naming the Stages

```dockerfile
# Unnamed stage (default)
FROM ubuntu AS builder     # Named — reference by name
FROM ubuntu                # Unnamed — reference by index (0, 1, 2)

COPY --from=builder ...    # Copy by name
COPY --from=0 ...          # Copy by index (first FROM = index 0)
```

### Selective Build (debugging)

You can build only a specific stage for debugging:
```bash
docker build --target builder -t kali-builder .
# Only builds Stage 1, stops before Stage 2
# Use this to debug the msf compilation without building the full image

docker build --target runtime -t kali-lab:multi-stage .
# Builds both stages (Stage 1 is required for Stage 2)
```

### Pros

- **Smallest final image** — no build tools or dev packages leak through
- **Fully reproducible** — single Dockerfile, one `docker build` command
- **CI/CD friendly** — no manual commit step
- **Bre of concern** — each stage is independently cached

### Cons

- **Complex Dockerfile** — harder to read and maintain
- **COPY lines can be fragile** — you must know exactly which files to copy
- **Build time is longer** — both stages run sequentially (though parallel execution is possible with BuildKit)
- **Debugging is harder** — errors in the builder stage are harder to inspect interactively

### When to Use

- Production images where size matters
- CI/CD pipelines where a single command must produce the complete image
- When you need fully reproducible builds (no manual steps)
- When build tools are large and shouldn't ship in the runtime image

### When NOT to Use

- Quick prototyping or learning
- When you don't know exactly which files are needed at runtime
- When the build process is still experimental (use commit strategy first, then migrate to multi-stage)

---

## Strategy 6: Pre-Built Base Images

### What It Is

Instead of building everything from scratch, start from an image that already has most of what you need. You only add the missing pieces.

### The Concept

```
FROM scratch (empty)       ← 0 MB, you build EVERYTHING
FROM ubuntu (base OS)      ← 77 MB, you still install almost everything
FROM kalilinux/kali-rolling ← 1.2 GB, Kali tools already included
FROM kali-full (all tools)  ← 5+ GB, virtually nothing to install
```

Each step up reduces build time but increases image size and dependency on someone else's work.

### Available Kali Images on Docker Hub

| Image | Description | Size | Tools Included |
|---|---|---|---|
| `kalilinux/kali-rolling` | Minimal Kali | ~1.2 GB | Base system only |
| `kalilinux/kali-headless` | Kali without GUI tools | ~2 GB | Basic CLI tools |
| `kalilinux/kali-last-release` | Pinned to latest stable release | ~1.2 GB | Same as rolling but version-locked |
| `kalilinux/kali-linux` | "Full" Kali | ~3 GB | Many tools, but not all |
| Community images | Various | Varies | Whatever the maintainer included |

**No official image includes msf pre-installed.** Metasploit is too large and changes too frequently.

### Finding Pre-Built Images

```bash
# Search Docker Hub for Kali-based images with msf
docker search kali | grep -i msf
docker search kali | grep -i metasploit

# Check image details
docker pull some-user/kali-msf:latest
docker history some-user/kali-msf:latest   # See layers to verify what's inside
```

**Security warning with community images:** Anyone can upload to Docker Hub. A pre-built image might include:
- Backdoors or malware
- Outdated packages with known vulnerabilities
- Modified versions of tools that behave differently

**Always verify:**
```bash
docker image inspect some-user/kali-msf:latest   # Check ENV, CMD, labels
docker history some-user/kali-msf:latest          # Check what layers contain
```

### Building Your Own Pre-Built Image (Our Approach)

The "pre-built image" doesn't have to come from Docker Hub. Our `kali-lab:with-msf` IS a pre-built image — we built it once and now use it as a starting point.

**Push to a registry for team access:**
```bash
docker tag kali-lab:with-msf your-registry/kali-lab:with-msf
docker push your-registry/kali-lab:with-msf

# Anyone can now pull it:
docker pull your-registry/kali-lab:with-msf
```

### Layering on Top of Pre-Built Images

Once you have `kali-lab:with-msf`, you can build ON TOP of it for specific scenarios:

```dockerfile
# For web application testing
FROM kali-lab:with-msf

RUN apt install -y burpsuite zaproxy
# Now you have a web-specific Kali image

# For network testing
FROM kali-lab:with-msf

RUN apt install -y wireshark ettercap
# Now you have a network-specific Kali image
```

### Pros

- **Fastest build time** — minimal `apt install` needed
- **Smallest delta** — your Dockerfile is just a few lines
- **Shared across team** — push once, use everywhere

### Cons

- **Trust dependency** — you must trust the image source
- **Larger base image** — includes things you might not need
- **Maintenance burden** — if the base image isn't updated, you inherit old packages
- **Not always available** — msf specifically is rarely pre-installed in public images

### When to Use

- As a target state — build once, commit, use forever (what we did)
- Team environments — push to shared registry so others don't rebuild
- CI/CD — pull pre-built base, only build your custom layer on top

### When NOT to Use

- When you need full control over every package version
- When security requirements demand building from known-good sources
- When the pre-built image is significantly larger than what you actually need

---

## Decision Matrix — Which Strategy When?

| Scenario | Best Strategy | Why |
|---|---|---|
| Simple build, reliable mirrors, <500 MB | 1 (Single RUN) | Simplest, no special features needed |
| Large build, possible network failures | 2 (BuildKit cache) | Resumes partial downloads |
| Mixed reliability — some packages always fail | 3 (Split RUNs) | Isolate failures, cache successes |
| Interactive debugging needed | 4 (Lean + commit) | Full control, real-time error visibility |
| Production image, must be small | 5 (Multi-stage) | Discards build tools, smallest size |
| Team needs same image without rebuilding | 6 (Pre-built base) | Build once, share everywhere |
| CI/CD pipeline, one command must work | 5 (Multi-stage) | Fully reproducible, no manual steps |
| Learning / experimentation | 4 (Lean + commit) | Interactive, see every error in real-time |

### Combining Strategies

The best approach often combines multiple strategies:

```dockerfile
# syntax=docker/dockerfile:1.4

# Stage 1 uses BuildKit cache mounts + split RUNs for reliability
FROM kalilinux/kali-rolling AS builder
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt update && apt install -y git ruby-dev build-essential libyaml-dev ...
RUN git clone ... && bundle install

# Stage 2 builds minimal runtime on top of pre-built base
FROM kalilinux/kali-rolling
COPY --from=builder /opt/msf /opt/msf
RUN apt install -y nmap hydra ...
```

This combines:
- **Strategy 2** (BuildKit cache mounts) — for the builder stage
- **Strategy 3** (split RUNs) — separating build deps from runtime tools
- **Strategy 5** (multi-stage) — discarding build tools
- **Strategy 6** (pre-built base) — using kAlinux/kali-rolling as starting point

---

## Quick Reference

### Build Commands

```bash
# Strategy 1-3, 5: Standard build
docker build -t my-image /path/to/Dockerfile

# With host networking (if mirrors are behind NAT)
docker build --network host -t my-image /path/to/Dockerfile

# BuildKit explicit enable
DOCKER_BUILDKIT=1 docker build -t my-image /path/to/Dockerfile

# Multi-stage: build specific stage
docker build --target builder -t builder-image .

# Strategy 4: Commit
docker run -it --user root base-image bash
# ... install stuff interactively ...
exit
docker commit $(docker ps -lq) new-image:tag

# Strategy 6: Push/pull
docker tag my-image registry.example.com/my-image:tag
docker push registry.example.com/my-image:tag
docker pull registry.example.com/my-image:tag
```

### Cache Management

```bash
# Strategy 2: Prune BuildKit cache
docker builder prune
docker builder prune --all

# General: clean up unused images and containers
docker image prune
docker container prune
docker system prune -a   # CAREFUL — removes everything unused
```

### Image Inspection

```bash
docker images                   # List all images with sizes
docker image history my-image   # See each layer and its size
docker image inspect my-image   # Full metadata (ENV, CMD, layers, etc.)
docker run -it my-image bash    # Explore the image interactively
```
