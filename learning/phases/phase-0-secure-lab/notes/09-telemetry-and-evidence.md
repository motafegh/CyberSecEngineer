# Telemetry and Evidence Zone

> **Phase 0, Module 0.5 — Complete**
> **Date:** 2026-07-01 (Sessions 6–7)
> **Status:** ✅ All 6 chunks complete
> **Session plans:** `session-plans/session-04-telemetry-and-evidence.md`, `session-plans/session-07-telemetry-evidence-part-2.md`
> **Evidence produced:** 7 files in `evidence/` | pcap, nmap output, connectivity matrix, Apache access log

---

## Chunk 1 — The Ephemerality Problem

### The Mechanism

Every container gets a **writable layer** — a thin overlay on top of the read-only image layers. Files you create inside (`tcpdump -w capture.pcap`, `nmap -oN results.txt`, `touch evidence/note.txt`) all go here.

```
Image layers (read-only)           Container
┌─────────────────────┐           ┌──────────────┐
│ Layer 3: apt clean  │           │ Writable     │
│ Layer 2: apt install│           │ layer        │
│ Layer 1: FROM kali  │           │ ← evidence   │
│ Layer 0: base fs    │           │   files live │
└─────────────────────┘           │   here       │
                                  └──────────────┘
```

### When Evidence Survives vs Dies

| Action | Evidence survives? | Why |
|---|---|---|
| `docker stop` → `docker start` | ✅ Yes | Same container object, same writable layer |
| Host reboot → `docker start` | ✅ Yes | Container persisted to disk |
| `docker rm` | ❌ Gone | Writable layer deleted |
| `docker run` (new container) | ❌ Gone | Fresh writable layer created |
| `docker run --rm` + exit | ❌ Gone | Container auto-deleted on exit |
| Docker Desktop reset + cleanup | ❌ Possibly gone | Orphaned containers may be pruned |

### The Key Insight

Containers are designed to be **disposable** and **stateless**:
- Disposable → `docker rm && docker run` gives a clean state
- Stateless → state lives in volumes/bind mounts, not in the container

Evidence is **state**. Keeping it in the writable layer fights the container model. The fix is to **move evidence out** of the container into a host directory via bind mounts.

### Attack/Defense/Detection

- **Offensive:** Evidence inside a compromised container reveals past findings to the attacker
- **Defensive:** Incident responders need evidence that survives container restarts and redeployments
- **Detection:** Container orchestration (Kubernetes) destroys containers constantly — logs in writable layers are lost on every roll-out

---

## Chunk 2 — Bind Mounts

### The Mechanism

A bind mount mounts a host directory at a specific path inside the container. Files written to that path inside the container are stored on the host filesystem, not in the container's writable layer.

```
Host filesystem                 Container
┌─────────────────────┐        ┌──────────────────┐
│ building/labs/      │        │ /home/analyst/    │
│   evidence/     ◄───┼────────┤   evidence/       │
│   └─ scan.pcap     │ bind   │   └─ scan.pcap    │
└─────────────────────┘ mount  └──────────────────┘
                                 Writable layer
                                 (empty for this path)
```

### The Command

```bash
docker run -dit --name kali \
  -v /host/absolute/path:/container/path \
  --security-opt seccomp=unconfined \
  --cap-add=NET_RAW --cap-add=NET_ADMIN \
  --network lab-net-nat \
  --user analyst \
  kali-lab:with-msf

docker network connect lab-net-internal kali
```

Key points about `-v`:
- **Absolute paths only** — `-v ~/evidence:/evidence` does NOT work; must be `-v /home/motafeq/...`
- The host directory must exist before mounting
- The container mountpoint is auto-created if it doesn't exist
- Ownership on the host maps by UID — `analyst` (UID 1000) inside = `motafeq` (UID 1000) on the host

### Bind Mount Security

The bind mount is a **pinhole** — the container can only access the exact path mounted, NOT the parent directories or siblings.

| Mount | Attacker gets | Risk |
|---|---|---|
| `-v /home/motafeq:/home/analyst` | `.ssh/`, `.config/`, all repos | 🔴 Critical |
| `-v /home/motafeq/projects:/home/analyst` | All projects | 🔴 High |
| `-v /home/motafeq/projects/.../evidence:/home/analyst/evidence` | Only evidence files | 🟢 Low |

**Mount the narrowest path that lets the container do its job.** No path traversal or symlink escape is possible — the kernel enforces the mount boundary.

### Permission Fix (Common Issue)

If Docker auto-creates the host directory, it's owned by `root`. The `analyst` user (UID 1000) cannot write to it. Fix:

```bash
# From a temporary container running as root
docker run --rm -v /host/evidence:/evidence alpine chown 1000:1000 /evidence

# Or from host with sudo
sudo chown motafeq:motafeq /host/evidence
```

### Proven Survivability

**Test 1:** Write file inside container → verify it exists on host
```bash
docker exec kali bash -c "echo 'test' > /home/analyst/evidence/test.txt"
cat /host/evidence/test.txt  # ✅ File is on host
```

**Test 2:** Destroy container → file survives
```bash
docker rm -f kali
ls /host/evidence/  # ✅ test.txt still there
```

**Test 3:** New container with same mount → file accessible
```bash
docker run -dit -v /host/evidence:/home/analyst/evidence ... kali-lab:with-msf
docker exec kali cat /home/analyst/evidence/test.txt  # ✅ File is there
```

### Attack/Defense

- **Attack:** If container is compromised, attacker is confined to the mounted directory only. Cannot read host directories outside the mount.
- **Defense:** Mount only what's needed. Never mount the home directory or project root.
- **Detection:** Files appear on host immediately — host-based monitoring (inotify, auditd) can detect evidence creation in real time.

---

## Chunk 3 — Packet Capture with tcpdump

### The Mechanism

tcpdump puts the network interface into **promiscuous mode** — captures every packet the interface sees, not just packets addressed to the container. On `eth1` (internal network), only attack traffic flows — clean, noise-free captures.

### The Command

```bash
# Start capture (as root — analyst user lacks raw socket permission)
docker exec -d -u 0 kali tcpdump -i eth1 -w /home/analyst/evidence/scan.pcap

# Run the scan
docker exec kali nmap -sV -sC -O dvwa

# Stop capture
docker exec -u 0 kali pkill -SIGINT tcpdump
```

### tcpdump Permission Problem

`analyst` user cannot run tcpdump directly — even with `--cap-add=NET_RAW` and `--cap-add=NET_ADMIN`. Docker adds capabilities to the container's **permitted set** but non-root users don't inherit them as **effective** capabilities.

Two fixes:
1. `docker exec -u 0 kali tcpdump ...` — run as root via docker exec (root inside container can use all capabilities)
2. `setcap cap_net_raw,cap_net_admin+eip /usr/sbin/tcpdump` — give the tcpdump binary the capability directly (done on many production systems)

### What We Captured

From the 218 KB pcap (`2026-07-01-nmap-dvwa.pcap`):

**Phase 1 — ARP (Layer 2):**
```
ARP, Request who-has dvwa.lab-net-internal tell kali
ARP, Reply dvwa is-at ea:e8:b1:20:0b:26
```
Kali resolves DVWA's IP to its MAC address before any scan traffic.

**Phase 2 — SYN Scan (Layer 3-4):**
```
Kali → DVWA: Flags [S] (SYN) to every port    "Is this port open?"
DVWA → Kali: Flags [R.] (RST+ACK) to most      "Closed — nothing here"
DVWA → Kali: Flags [S.] (SYN-ACK) to port 80  "Open — I'm listening"
Kali → DVWA: Flags [R] (RST)                    "SYN scan — nmap never completes handshake"
```

**Phase 3 — Service Version Detection (Layer 7):**
```
GET / HTTP/1.0
```
Full handshake completes. Server responds:
```
HTTP/1.1 302 Found
Server: Apache/2.4.25 (Debian)
Set-Cookie: PHPSESSID=...; path=/
Location: login.php
```

**Phase 4 — NSE Scripts:**
```
GET / HTTP/1.0 (with unusual window size 1)  — http-title, http-cookie-flags probes
GET /robots.txt                                — http-robots.txt NSE script
```

### Evidence Path

```
Container writes to /home/analyst/evidence/
  → Bind mount maps to building/labs/evidence/
    → After session, copied to learning/phases/phase-0-secure-lab/evidence/
```

### Attack/Defense/Detection

- **Attack:** tcpdump captures every packet in plain text. HTTP requests, session cookies, POST data, credentials — all visible in the hex dump. Nothing encrypted on port 80.
- **Defense:** HTTPS (TLS) encrypts everything shown above. The hex dump would show encrypted gibberish, not `GET / HTTP/1.0` and `PHPSESSID=...`.
- **Detection:** The pcap is evidence of the attack. If an incident responder finds it, they can reconstruct exactly what the attacker probed, what they found, and how they interacted with the target. 218 KB of packet-level detail.

---

## Chunk 4 — Application Logs from DVWA (The Defender's Side)

### Why This Matters

Every attack has two sides: what the attacker sees (their own tools' output) and what the defender sees (logs on the target). If you only study attacks from the attacker's perspective, you miss what a real blue team would detect. Understanding what the defender sees tells you whether your attack techniques are stealthy or loud.

### The Mechanism

**Apache access.log** is a text file where the Apache web server records one line for every HTTP request it receives. Each line contains:

| Field | Example from our log | Meaning |
|---|---|---|
| Source IP | `172.19.0.2` | Who made the request (Kali's internal IP) |
| Timestamp | `[01/Jul/2026:11:23:36 +0000]` | When the request arrived |
| HTTP Method | `GET`, `POST`, `PROPFIND`, `OPTIONS` | What action was requested |
| Path | `/robots.txt`, `/.git/HEAD`, `/login.php` | What resource was requested |
| HTTP Version | `HTTP/1.0`, `HTTP/1.1` | Which protocol version |
| Status Code | `200` (OK), `302` (redirect), `404` (not found) | The server's response |
| User-Agent | `Mozilla/5.0 (compatible; Nmap Scripting Engine; ...)` | What client software made the request |

### Extracting the Log

DVWA runs Apache inside its container. Since the `vulnerables/web-dvwa` image is minimal and may lack a shell, we use `docker cp` — a command that copies files **from** a container **to** the host (or vice versa) without needing to `docker exec` into the container:

```bash
docker cp dvwa:/var/log/apache2/access.log /tmp/dvwa-access.log
```

**Command breakdown:**
- `docker cp` — Docker copy command (works like `scp` for containers)
- `dvwa:/var/log/apache2/access.log` — source: container name `dvwa`, path `/var/log/apache2/access.log`
- `/tmp/dvwa-access.log` — destination on the host

Then save to evidence directory:
```bash
cp /tmp/dvwa-access.log learning/phases/phase-0-secure-lab/evidence/2026-07-01-dvwa-access-log.txt
```

### What We Found — nmap Scan Signatures

Running `nmap -sV -sC dvwa` from Kali produced 36 entries in the access log, all from `172.19.0.2` (Kali), all at the exact same second (`11:23:36`). Here are the key signatures:

**Signature 1 — User-Agent:**
```
Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)
```
nmap's NSE scripts literally announce themselves. Real browsers send things like `Mozilla/5.0 (X11; Linux x86_64) Firefox/130.0`. **Evadability:** trivially easy to change — nmap lets you set a custom User-Agent via `--script-args http.useragent="Mozilla/5.0"`. A single string match is not a reliable detection signal on its own.

**Signature 2 — Temporal Clustering (Behavioral):**
All 36 requests happened in the same second. No human types 36 URLs in one second. **Evadability:** Hard to fake — you'd need to deliberately slow the scan (`--scan-delay`), which makes the scan take much longer. Behavioral patterns are inherently harder to evade than single string matches.

**Signature 3 — Unusual HTTP Methods:**
Normal browsers use GET and POST. The log showed: `PROPFIND`, `OPTIONS`, `HEAD`, and even `IKML` (an invalid method — some NSE scripts send deliberately malformed requests to observe server behavior). **Evadability:** You could disable the specific NSE scripts that use unusual methods, but that reduces scan coverage.

**Signature 4 — Suspicious Paths:**
- `/.git/HEAD` — probing for exposed git repositories
- `/HNAP1` — probing for a known router vulnerability
- `/evox/about` — probing for a specific D-Link camera model
- `/nmaplowercheck1782905016` — nmap's own test path to verify the target is actually responding (non-existent path, expects 404)
- `/sdk` — probing for exposed SDK endpoints

No legitimate browser requests these paths. **Evadability:** You could disable specific NSE scripts, but the paths they probe are what make them useful for reconnaissance — removing scripts removes value.

**Signature 5 — HTTP/1.0 Usage:**
Some entries use `HTTP/1.0` instead of `HTTP/1.1`. This comes from nmap's service version detection (`-sV`), which sometimes uses HTTP/1.0 probes. Browsers have used HTTP/1.1 or higher for over 20 years.

### The Core Lesson: Single Signal vs Pattern

Any single indicator (User-Agent, HTTP/1.0, a specific path) can be changed by a smart attacker. The reliable detection is the **combination** — rapid timing + unusual methods + suspicious paths + one source IP — even if the User-Agent looks normal, the pattern still says "scan."

This is a fundamental security principle: **single indicators are easy to evade; behavioral patterns are hard to fake.**

### Attacker vs Defender — Same Event, Two Views

| | Attacker's Evidence (pcap + nmap output) | Defender's Evidence (access.log) |
|---|---|---|
| What is it | Raw network packets captured on Kali's eth1 | Web server log inside DVWA's filesystem |
| Where captured | Kali's network interface | DVWA's Apache process |
| Shows | Every packet — SYN, RST, HTTP, ARP, DNS | Only HTTP requests — organized, readable |
| Level | Network layer (packet bytes) | Application layer (HTTP fields) |
| The pcap sees what the log doesn't | Closed ports (RST packets), TCP handshake, timing between packets | — |
| The log sees what the pcap has too | — | Clean format: one line per request with all fields parsed |

Both are kept because they complement each other. The pcap is raw and complete. The log is organized and queryable.

---

## Chunk 5 — Evidence Naming Convention

### Why This Matters

Evidence files multiply fast. Without a naming convention, you end up with `scan.txt`, `scan2.txt`, `scan_FINAL(3).txt` — you can't find anything, you don't know what's fresh, and you can't trust your own filing system.

A naming convention is not pedantry — it's the difference between "I have evidence somewhere" and "I can find any piece of evidence in 5 seconds."

### The Convention

```
YYYY-MM-DD-tool-target-description.ext
```

### Part-By-Part Explanation

| Part | Purpose | Example |
|---|---|---|
| `YYYY-MM-DD` | Date first — sorts chronologically by alphabet | `2026-07-01` |
| `tool` | What generated the evidence | `nmap`, `tcpdump`, `curl`, `apache` |
| `target` | What was probed or observed | `dvwa`, `kali`, `lab-net-internal` |
| `description` | What kind of evidence | `service-scan`, `access-log`, `syn-scan` |
| `.ext` | File type — tells tools how to parse | `.txt`, `.pcap`, `.json`, `.log` |

### Why Date First

ISO 8601 (`YYYY-MM-DD`) has a critical property: **alphabetical sort = chronological sort.** `ls` alone gives you the timeline:

```
# Date-first: natural chronological order
2026-06-29-kali-build.txt
2026-06-30-nmap-dvwa.txt
2026-07-01-nmap-dvwa.pcap

# Tool-first: jumbled — different tools intermixed
hydra-2026-07-02.txt
kali-build-2026-06-29.txt
nmap-2026-06-30.txt
nmap-2026-07-01.pcap
```

### Rules

1. **Date first** — ISO 8601. Sorts alphabetically = sorts chronologically.
2. **Tool or source** — what generated the evidence.
3. **Target** — who was targeted.
4. **Description** — what kind of evidence.
5. **No spaces** — use hyphens. Spaces break in scripts and URLs.
6. **No version suffixes** — `FINAL`, `v2`, `_fixed` create confusion. Which one is actually final? If you need a new version, make a new file with today's date. The old file stays as a historical record.

### Applied to Our Evidence

| Current filename | Convention check | Better name |
|---|---|---|
| `2026-06-29-session-1-docker-isolation.txt` | `session-1` isn't a tool | `2026-06-29-ping-lab-net-internal-isolation-test.txt` |
| `2026-06-30-connectivity-matrix.txt` | No tool | `2026-06-30-ping-dvwa-kali-connectivity-matrix.txt` |
| `2026-06-30-nmap-dvwa.txt` | Good, missing description | `2026-06-30-nmap-dvwa-service-scan.txt` |
| `2026-07-01-dvwa-access-log.txt` | No tool | `2026-07-01-apache-dvwa-access-log.txt` |
| `2026-07-01-nmap-dvwa.pcap` | Good, but tcpdump generated it, not nmap | `2026-07-01-tcpdump-dvwa-nmap-scan.pcap` |

---

## Chunk 6 — Evidence Handling Rules

### Why This Matters

We built the technical infrastructure (bind mounts survive container destruction). We defined the naming convention (evidence is findable). What's missing is the **process discipline** — the rules you follow so evidence stays **trustworthy**.

Without rules, you'll eventually:
- Accidentally edit a raw evidence file and lose the original data
- Forget to copy evidence from the bind mount to the safe storage directory
- Leave a captured password in a log without flagging it
- Not know whether a file is the original or a cleaned version

### Chain of Custody

**Chain of custody (COC)** is the documented history of who handled evidence, when, and what was done to it. In a criminal investigation, if evidence has a gap in its custody history — "who had this hard drive between Tuesday and Thursday?" — it becomes inadmissible in court.

We're not building a court-admissible lab, but the **principle** is universal: if evidence has been modified, you can't trust what it says. And if you can't trust your own evidence, you can't learn from it.

### The 7 Rules

**Rule 1:** ALWAYS use bind mounts for evidence directories inside containers.
*Why:* The technical foundation. Without bind mounts, `docker rm` destroys evidence. We proved this in practice.

**Rule 2:** NEVER edit raw evidence files.
*Why:* Edited evidence has no chain of custody. If you delete a line, you can't prove what was there originally. Instead, create a companion `.notes.txt` file that says "WARNING: line 47 contains a password — redacted in analysis." The raw file stays untouched.

**Rule 3:** ALWAYS name evidence: `YYYY-MM-DD-tool-target-description.ext`
*Why:* Consistent naming means you can find any file by date, tool, or target without opening it.

**Rule 4:** ALWAYS copy evidence from the bind mount to `learning/phases/phase-N-*/evidence/` after each session.
*Why:* The bind mount is a **working directory** — it accumulates files from every session and can get cluttered or overwritten. The archive is the **permanent, organized** copy. This two-step flow (working → archive) separates active work from permanent storage.

**Rule 5:** FLAG any evidence containing passwords, tokens, or PII in a companion notes file.
*Why:* PII — **Personally Identifiable Information** — includes passwords, API tokens, session cookies, real email addresses. If evidence captures sensitive data (which happens — a scan against a live target could grab credentials), you must flag it so nobody accidentally shares or commits it.

**Rule 6:** DELETE evidence from the Kali container after copying to the host.
*Why:* Kali is the attack workstation — highest risk of compromise. Accumulated evidence inside it is a treasure trove for an attacker. Clean the container-side copy; the archive on the host is your permanent record.

**Rule 7:** KEEP evidence until the session's learning note is written.
*Why:* Evidence is the raw material you write notes from. If you delete evidence before writing the note, you lose the ability to verify what actually happened.

### Evidence Flow

```
Container writes to /home/analyst/evidence/
    ↓ (bind mount)
building/labs/evidence/                    ← working directory, transient
    ↓ (after session: copy to archive)
learning/phases/phase-N-*/evidence/        ← permanent archive
    ↓ (cleanup)
docker exec kali rm /home/analyst/evidence/*     ← remove from container
```

### Where the Rules Are Stored

The 7 rules are documented at `building/labs/EVIDENCE-HANDLING.md` — a standalone file that any future session can reference.

---

## Complete Evidence Inventory (Module 0.5)

| File | Type | Session | What It Captures |
|---|---|---|---|
| `2026-06-29-session-1-docker-isolation.txt` | Ping test output | S1 | Proves `--internal` blocks internet |
| `2026-06-29-session-2-kali-build.txt` | Build log | S2 | Kali image build process |
| `2026-06-30-connectivity-matrix.txt` | Connectivity tests | S3 | Which containers can reach which networks |
| `2026-06-30-nmap-dvwa.txt` | nmap output | S3 | Attack results: open ports, services, NSE findings |
| `2026-07-01-nmap-dvwa.pcap` | Packet capture | S6 | Raw network traffic from the nmap scan |
| `2026-07-01-dvwa-access-log.txt` | Apache access log | S7 | What DVWA recorded about the scan (defender's view) |
| `building/labs/EVIDENCE-HANDLING.md` | Process document | S7 | 7 rules for evidence discipline
