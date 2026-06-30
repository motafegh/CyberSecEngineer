# Kali Attack Workstation — Build Journey (Trial & Error)

> **Session 2 — Phase 0, Module 0.3**
> **Date:** 2026-06-29
> **Status:** Complete
> **Evidence:** `evidence/2026-06-29-session-2-kali-build.txt`

---

## 1. What We Were Building

A Docker image for the lab's attack workstation — Kali Linux with:
- 22 security tools (nmap, nikto, sqlmap, hydra, john, msf, etc.)
- A non-root `analyst` user with `sudo` access
- Work directories: `reports/`, `evidence/`, `tools/`
- All tools installed at build time so the image is reproducible

---

## 2. The Plan vs. Reality

### Plan (Straightforward)
```dockerfile
FROM kalilinux/kali-rolling
RUN apt update && apt install -y nmap metasploit-framework hydra ...
```

### Reality (Six Major Failures)

1. **Building without `--network host`** — apt mirrors consistently timed out
2. **`metasploit-framework` never downloaded from any apt mirror** — the 522 MB deb was missing from every reachable mirror
3. **`gem install metasploit-framework`** — installed an empty stub (version 6.0.33, 0 files extracted)
4. **Rapid7 apt repo with GPG** — `gpg` wasn't installed, then the keyring file was empty/broken
5. **Direct `.deb` download from GitHub** — GitHub doesn't host pre-built debs
6. **Source compile via `bundle install`** — missing C headers: `libyaml-dev`, `libffi-dev`, `libpq-dev`. Failed 3 times before the right `apt install` fixed all missing deps.

Each failure taught something about the underlying infrastructure. The sections below document every attempt, what failed, and why.

---

## 3. Detailed Failure Log

### Attempt 1: `docker build` (default bridge network)

**Command:**
```bash
docker build -t kali-lab /home/motafeq/projects/.../compose/kali/
```

**What happened:**
- `apt update` worked (21.6 MB index downloaded from `kali.download`)
- `apt install` started downloading 469 packages (832 MB)
- After ~300 seconds, all mirrors timed out — `Ign:` (ignored) for most packages, then `Err:` (error) and `Unable to connect to http.kali.org:80`
- Build failed with `exit code: 100`

**Root cause:** Docker bridge NAT. Containers on the default bridge network get their traffic translated through Docker's NAT (`docker-proxy`). Some Kali mirror servers (especially `http.kali.org`) rate-limit or drop connections from Docker's IP range (172.17.x.x). Additionally, WSL2 DNS goes through Tailscale (100.100.100.100), which may have interfered.

**Key learning:** The default Docker bridge adds a NAT translation layer that can break long-lived HTTP connections to package mirrors. 564 MB of 832 MB downloaded before the remaining ones timed out — the connection drops were cumulative, not instant.

---

### Attempt 2: `docker build --network host`

**Command:**
```bash
docker build --network host -t kali-lab /home/motafeq/.../compose/kali/
```

**What happened:**
- All 469 packages downloaded in ~300 seconds — mirrors now reachable
- But `metasploit-framework` specifically failed at `Get:443` from `eu.mirror.ionos.com`
- 564 MB downloaded successfully; the build failed only because 1 out of 469 packages was missing from all mirrors

**Root cause:** `metasploit-framework_6.4.135_amd64.deb` (522 MB) is a huge package. Most Kali mirrors don't carry it because it's too large. The few that do (like `eu.mirror.ionos.com`) are unreliable. `kali.download` had it but its connection kept dropping.

**Detection:** `Ign:443` appeared ~30 seconds after `Get:443` started downloading, then retried twice more at 60-second intervals, then `Err:443`. The full Retry → Ign → Err cycle took ~200 seconds.

**Solution for the 22 other tools:** After removing `metasploit-framework` from the apt list, the build completed in 318 seconds (cached the 564 MB from the partial download, only needed ~19 small remaining packages).

**Key learning:** Always check which mirror serves each package. Apt uses a mirror pool (`/etc/apt/sources.list`) and tries multiple mirrors in parallel. If NO mirror has a package, the install fails regardless of how many mirrors are listed.

---

### Attempt 3: `gem install metasploit-framework`

**Command (inside running container):**
```bash
gem install metasploit-framework
```

**What happened:**
- 128 gems fetched and installed
- Output: "128 gems installed" with all sub-dependencies (rex-*, metasploit-model, packetfu, etc.)
- BUT `metasploit-framework-6.0.33` directory at `/var/lib/gems/3.3.0/gems/metasploit-framework-6.0.33/` was **completely empty** — only `.` and `..`
- No `msfconsole`, no `msfvenom`, no exploit modules
- Small utility binaries DID get installed: `msfbinscan`, `msfelfscan`, `msfpescan`, `msfrop`, `msfmachscan` (from sub-gems like `rex-bin_tools` and `metasm`)

**Root cause:** RubyGems published version 6.0.33 (very old, from 2021) for Ruby 3.3, which is incompatible with the latest Kali. The gem was a stub — registered the package but extracted zero files. The error was silent because the sub-gems (which contain supporting libraries like rex-*, recog, packetfu) all installed correctly.

**Detection method:** `ls -la /var/lib/gems/3.3.0/gems/metasploit-framework-6.0.33/` returned only `.` and `..`. The count was 0 files vs. thousands expected.

**Key learning:** Never trust `gem install` for large frameworks — always verify the gem directory has actual files. A successful exit code (0) with "128 gems installed" doesn't mean the main package's code is present.

---

### Attempt 4: Rapid7 apt repo with GPG signing

**Commands (sequence):**
```bash
curl -fsSL https://apt.metasploit.com/metasploit-framework.gpg.key | gpg --dearmor -o /usr/share/keyrings/metasploit-framework.gpg
echo "deb [signed-by=/usr/share/keyrings/metasploit-framework.gpg] https://apt.metasploit.com lucid main" > /etc/apt/sources.list.d/metasploit-framework.list
apt update && apt install -y metasploit-framework
```

**First attempt failed because:**
```bash
bash: gpg: command not found
curl: Failed writing body
```
- `gpg` wasn't installed in the base Kali image (it's not a dependency of any tool we selected)
- The `curl` pipe created an empty/broken keyring file (0 bytes written to `/usr/share/keyrings/metasploit-framework.gpg`)
- `apt update` then tried to use the empty keyring, failed with: `Failed to parse keyring`

**Second attempt (after installing `gpg` and `ca-certificates`):**
```bash
rm -f /usr/share/keyrings/metasploit-framework.gpg /etc/apt/sources.list.d/metasploit-framework.list
apt install -y gpg ca-certificates
# then re-ran the curl/gpg/echo/apt sequence
```
- This time GPG signed correctly, repo was added, but `apt install -y metasploit-framework` still downloaded from Kali mirrors (because apt prefers the original source `kali.download` over newly added repos)
- Same mirror failure at `Get:50` — `kali.download` timed out on the 522 MB deb

**Key learning:** Adding a new apt repo doesn't override apt's existing mirror list. Apt will try ALL configured repos and use the one with the highest version/priority. Since Kali repos already listed `metasploit-framework`, apt ignored the Rapid7 repo and used `kali.download` instead.

---

### Attempt 5: Direct `.deb` download from GitHub

**Command:**
```bash
curl -L -o /tmp/msf.deb https://github.com/rapid7/metasploit-framework/releases/download/6.4.135/metasploit-framework_6.4.135_amd64.deb
dpkg -i /tmp/msf.deb
```

**What happened:**
```bash
% Total    % Received % Xferd  Average Speed
100      9   0      9  --:--:--   --:--:--  --:--:--      9
dpkg-deb: error: unexpected end of file in archive
```
- Only 9 bytes downloaded, not a valid deb package
- `dpkg` reported: `error: unexpected end of file in archive magic version number`

**Root cause:** GitHub Releases doesn't host pre-built `.deb` packages for Metasploit. The URL returned a 302 redirect to a non-existent file, which `curl` followed to an error page (9 bytes of HTML). Rapid7 only distributes debs through their apt repo or the Kali mirrors, both of which we'd already exhausted.

**Detection:** The `curl` output showed `100      9` — only 9 bytes. A valid deb starts with `!<arch>\n` (magic bytes), which a 9-byte file can't contain. The `dpkg` error confirmed it.

**Key learning:** Always check `curl` download size before piping to `dpkg` — add `--fail` and check the file size. A successful `curl` exit code doesn't mean valid content.

---

### Attempt 6: Source compile via `git clone` + `bundle install`

**Command (the one that worked):**
```bash
git clone --depth 1 https://github.com/rapid7/metasploit-framework /opt/metasploit-framework
cd /opt/metasploit-framework
gem install bundler
bundle install
```

**What worked:**
- `git clone` from GitHub's CDN — always reliable for source repositories
- `gem install bundler` installed the dependency resolver
- `bundle install` processed the `Gemfile` and installed 250 gems

**But it failed the first 3 times with missing C headers:**

1. **`psych` gem failed:** `yaml.h not found`
   - Fix: `apt install -y libyaml-dev`
   - `psych` is a YAML parser — Metasploit uses YAML for config files and module metadata

2. **`fiddle` gem failed:** `missing libffi`
   - Fix: `apt install -y libffi-dev`
   - `fiddle` is Ruby's FFI (Foreign Function Interface) — allows Ruby to call C libraries directly. Used for low-level system interaction

3. **`pg` gem failed:** `Can't find the 'libpq-fe.h' header`
   - Fix: `apt install -y libpq-dev`
   - `pg` is the PostgreSQL driver — Metasploit uses PostgreSQL as its backend database

**After installing all three dev packages:**
```bash
apt install -y libyaml-dev libffi-dev libpq-dev
# Then re-run:
bundle install
```
- `bundle install` skipped already-installed gems and only compiled the 3 that had failed
- **250 gems total, all with native extensions compiled successfully**

**Final missing gem — `xmlrpc`:**
- `Bundler::GemNotFound: Could not find xmlrpc-0.3.3.gem for installation`
- `xmlrpc` was removed from Ruby's standard library in Ruby 3.3 (it's deprecated — XML-RPC is obsolete)
- Fix: `gem install xmlrpc -v 0.3.3 --no-document` (installed from RubyGems, not through Bundler)
- Then `bundle install` completed: `Bundle complete! 20 Gemfile dependencies, 250 gems now installed`

**Key learning:** Source compilation is reliable but requires all C build dependencies to be present. The Gemfile.lock pins exact versions. When a gem is retired from the Ruby standard library, it must be installed explicitly. Three missing `-dev` packages caused three separate failures — always install build dependencies as a group before starting compilation, not one at a time.

---

## 4. Final Architecture

### Image Structure

```
kali-lab (size: ~3.5 GB)
├── kalilinux/kali-rolling base (1.2 GB)
├── Layer 1: 22 apt tools + 469 deps (1.5 GB)
│   ├── Recon: nmap, gobuster, dirb, ffuf
│   ├── Web: nikto, sqlmap
│   ├── Creds: hydra, john
│   ├── Network: tcpdump, ncat, socat, curl, wget
│   ├── Dev: python3, python3-pip, git, jq
│   ├── System: iproute2, dnsutils, iputils-ping, sudo
│   └── Cleanup: apt clean, /var/lib/apt/lists/* removed
├── Layer 2: analyst user with sudo (negligible)
├── Layer 3: /home/analyst/{reports,evidence,tools} (negligible)
└── Layer 4 (committed): Metasploit source (2 GB)
    ├── /opt/metasploit-framework/ (git clone, 6.4.142)
    ├── 250 Ruby gems at /var/lib/gems/3.3.0/
    ├── Symlinks: /usr/local/bin/msf{console,venom,db}
    └── Compiled C extensions: pcaprub, pg, nokogiri, psych, fiddle, et al.
```

### The docker build command that works

```bash
docker build --network host -t kali-lab /home/motafeq/.../compose/kali/
```

- `--network host` is required because the default bridge NAT drops connections to apt mirrors
- At runtime (not build), the container will use `--internal` networks for isolation — `--network host` is only for the build

### The Dockerfile (final version)

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

Note: `metasploit-framework` is deliberately excluded from the apt install because it fails on all Kali mirrors. It's installed post-build via `git clone` + `bundle install`.

---

## 5. Key Technical Concepts Learned

### Docker Networking Modes

| Mode | Flag | How It Works | Best For |
|---|---|---|---|
| **Bridge** (default) | *(none)* | Container gets private IP (172.17.x.x), NAT'd through host | Runtime isolation, multi-container services |
| **Host** | `--network host` | Container shares host's network stack — same IP, same ports | Builds that need heavy downloads |
| **None** | `--network none` | Loopback only | Air-gapped containers, security testing |

The bridge NAT adds a `docker-proxy` process that translates container traffic. This works for most HTTP requests, but long-lived downloads (832 MB across 469 packages) can timeout because:
1. Docker-proxy has default keepalive/connection limits
2. WSL2's own NAT (Windows → WSL2) adds a second translation layer
3. Some package mirrors see Docker IP ranges (172.17.x.x) and apply rate limits

### How `apt` Package Distribution Works

Apt doesn't have a single source — it queries multiple mirrors and downloads pieces from whichever responds fastest:

```
source.list entries:
  http://http.kali.org/kali
  http://kali.download/kali
  http://mirror.netcologne.de/kali
  http://eu.mirror.ionos.com/kali
  http://ftp.halifax.rwth-aachen.de/kali
  http://mirror.pyratelan.org/kali
  http://mirror.nl.cdn-perfprod.com/kali
```

Different mirrors host different subsets of packages:
- `kali.download` and `http.kali.org` host most packages but not all
- Regional mirrors (netcologne, halifax, ionos) host a smaller subset
- Large packages like `metasploit-framework` (522 MB) are only on a few mirrors

When `metasploit-framework` fails on `kali.download`, apt tries the next mirror (`ionos.com`), then the next (`ftp.halifax`), until it exhausts all. If NONE succeeds, the install fails.

### Ruby's Dependency Nightmare

Metasploit is a Ruby application. Ruby uses a multi-layered package system:

| Layer | Manager | Config File | Examples |
|---|---|---|---|
| System packages | `apt` | `/etc/apt/sources.list` | `libyaml-dev`, `libpq-dev` |
| Ruby gems | `gem` / `bundler` | `Gemfile` | `psych`, `fiddle`, `pg` |
| Compiled C extensions | `gcc` + `make` | `extconf.rb` | `pcaprub`, `nokogiri`, `eventmachine` |

Each layer depends on the one below. A missing C header (`yaml.h`) blocks the gem (`psych`) which blocks the framework (`metasploit-framework`). The error messages bubble up but don't always tell you which `apt` package to install — you must know that `yaml.h` lives in `libyaml-dev`.

### Why `gem install` vs. `bundle install` matter

| Command | Behavior | Dependency Resolution |
|---|---|---|
| `gem install X` | Installs X + its dependencies at whatever versions RubyGems chooses | Loose — takes latest compatible |
| `bundle install` | Reads `Gemfile.lock` and installs EXACT versions specified | Strict — pins every gem to a specific version |
| `gem install X -v Y` | Installs version Y explicitly | Exact — but doesn't resolve transitive deps |

Using `gem install metasploit-framework` got us version 6.0.33 (old, broken stub). Using `bundle install` from the cloned `Gemfile.lock` got us 6.4.142 (latest, working).

---

## 6. Detection Patterns (How We Knew Each Attempt Failed)

| Symptom | Diagnosis | Tool/Command |
|---|---|---|
| `Ign:443 http://kali.download/...metasploit-framework...` | Mirror has the package listing but can't deliver the file | Read apt output |
| `Err:443 Connection failed [IP: ...]` | Mirror unreachable after retries | Read apt output |
| Gem install said success but no binaries | Empty gem stub | `ls -la /var/lib/gems/*/gems/metasploit-framework-*/` |
| `dpkg: unexpected end of file in archive magic` | Downloaded 9 bytes instead of 522 MB | `file /tmp/msf.deb` |
| `yaml.h not found` / `libffi missing` / `libpq-fe.h no` | Missing C development headers | Read gem native extension build log |
| `Framework Version: 6.4.142-dev` printed correctly | Git repo ownership issue | Minor, non-blocking, `git config --global --add safe.directory` |
| `sudo: msfconsole: command not found` | Symlink missing in this container layer | `ls -la /usr/local/bin/msf*` |

---

## 7. What's in the Final Image

### 22 Apt-Installed Tools

| Tool | Purpose | Verification |
|---|---|---|
| `nmap` | Network scanner | `nmap -V` |
| `netcat-openbsd` | Raw TCP/UDP communication | `nc -h` |
| `nikto` | Web server scanner | `nikto -Version` |
| `gobuster` | Directory/file brute-force | `gobuster --help` |
| `dirb` | Web content scanner | `dirb` |
| `ffuf` | Fast web fuzzer | `ffuf -V` |
| `sqlmap` | SQL injection automation | `sqlmap --version` |
| `hydra` | Online password brute-force | `hydra -h` |
| `john` | Offline password cracking | `john --help` |
| `sudo` | Privilege escalation | `sudo -V` |
| `curl` | HTTP client | `curl -V` |
| `wget` | HTTP downloader | `wget --version` |
| `tcpdump` | Packet capture | `tcpdump --version` |
| `python3` | Scripting | `python3 --version` |
| `python3-pip` | Python package manager | `pip3 --version` |
| `git` | Version control | `git --version` |
| `jq` | JSON processor | `jq --version` |
| `ncat` | Enhanced netcat | `ncat --version` |
| `socat` | Multi-purpose relay | `socat -V` |
| `iproute2` | Network configuration | `ip addr` |
| `dnsutils` | DNS tools (nslookup, dig) | `nslookup google.com` |
| `iputils-ping` | ICMP ping | `ping -c 1 8.8.8.8` |

### Metasploit Framework (6.4.142)

| Binary | Path | Purpose |
|---|---|---|
| `msfconsole` | `/usr/local/bin/msfconsole` | Main interactive console |
| `msfvenom` | `/usr/local/bin/msfvenom` | Payload generator |
| `msfdb` | `/usr/local/bin/msfdb` | Database management |
| `msfbinscan` | `/usr/local/bin/msfbinscan` | Binary analysis |
| `msfelfscan` | `/usr/local/bin/msfelfscan` | ELF binary scanner |
| `msfpescan` | `/usr/local/bin/msfpescan` | PE binary scanner |
| `msfrop` | `/usr/local/bin/msfrop` | ROP gadget finder |
| `msfmachscan` | `/usr/local/bin/msfmachscan` | Mach-O binary scanner |

### Image Storage

```bash
docker images kali-lab
REPOSITORY   TAG          IMAGE ID       SIZE
kali-lab     with-msf     ffe9d7698964   3.51GB
kali-lab     latest       5c70e4286f2c   2.53GB
```

- `kali-lab:latest` — base image without msf (built from Dockerfile)
- `kali-lab:with-msf` — committed image with full msf (can't rebuild from Dockerfile alone)

---

## 8. Key Takeaways

1. **`--network host` is essential for Docker builds that download large packages.** Default bridge NAT drops long-lived connections to apt mirrors.

2. **Not all apt mirrors carry all packages.** Large packages like `metasploit-framework` (522 MB) are only on a subset of mirrors. If those mirrors are unreachable, the package won't install via apt.

3. **`gem install` can silently fail.** A successful exit code with "128 gems installed" doesn't mean the main gem's code was extracted. Always verify the gem directory has actual files.

4. **Rapid7's apt repo has a chicken-and-egg problem.** Adding it requires `gpg` and `ca-certificates`, which aren't in the base Kali image. The GPG keyring file must be complete before `apt update` is run.

5. **Git clone + bundle install is the most reliable way to install Metasploit.** Bypasses all mirrors, apt, GPG, and RubyGems version issues. But requires all C build dependencies (`-dev` packages) to be present.

6. **Layer commits preserve runtime state.** Installing msf via `docker commit` saves the entire build (2 GB of Ruby gems + compiled extensions) without modifying the Dockerfile. But rebuilding from the Dockerfile loses the committed layer.

7. **Error messages are diagnostic goldmines.** Reading the exact apt output (`Ign:` vs `Err:`), the gem build log (`yaml.h not found`), and the dpkg error (`unexpected end of file`) tells you exactly what went wrong at each step.

---

## 9. Docker Commands Reference (All Used in This Session)

```bash
# Build with host networking (required for apt mirrors)
docker build --network host -t kali-lab /path/to/Dockerfile

# Remove metasploit from apt list, rebuild
docker build --network host -t kali-lab /path/to/Dockerfile

# Run container interactively
docker run -it --network host kali-lab
docker run -it --network host --user root kali-lab
docker run -it --network host --user analyst kali-lab

# Commit container to save state as new image
docker commit <container-id> kali-lab:with-msf

# List docker images with sizes
docker images kali-lab

# Find container ID (from host)
docker ps -lq
```
