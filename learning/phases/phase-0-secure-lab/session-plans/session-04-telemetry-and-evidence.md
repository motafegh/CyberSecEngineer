# Session 4 — Phase 0, Module 0.5: Telemetry and Evidence Zone

> **Roadmap ref:** `PHASE-0-SECURE-LAB.md` §12 (Module 0.5)
> **Date:** 2026-07-01
> **Status:** [~] In progress — Chunks 1-2 done, 3-5 postponed to next session

---

## Session Goals

- [x] Understand why evidence must survive container destruction
- [x] Set up host bind mounts for persistent evidence storage
- [x] Capture a tcpdump packet trace of an nmap scan
- [~] Collect application logs from DVWA (Apache access.log) — postponed
- [~] Create an evidence naming convention — postponed
- [~] Write evidence handling rules — postponed

---

## Chunk 1 — The Ephemerality Problem

### What We'll Learn

| Concept | Security Relevance |
|---|---|
| Containers are ephemeral by design | `docker rm` destroys all evidence inside |
| Writable layer dies with the container | `exit` and re-enter → fresh filesystem |
| Evidence must live outside the container | On the host, in a bind-mounted directory |

### The Problem

```bash
docker exec -it kali bash
analyst@kali:/$ tcpdump -i eth1 -w /home/analyst/evidence/scan.pcap
# ... capture runs ...
analyst@kali:/$ exit

docker rm kali
# scan.pcap is GONE. The writable layer is destroyed.
```

Containers are designed to be disposable. `docker rm` deletes the entire writable layer — including every file you created inside. If evidence lives only inside the container, destroying the container destroys the evidence.

### The Fix

**Bind mounts** — mount a host directory into the container at a specific path. Files written to that path exist on the host, not in the container's writable layer. The container can be destroyed and recreated; the evidence survives.

```bash
docker run -dit --name kali \
  -v /home/motafeq/projects/CyberSecEngineer/building/labs/evidence:/home/analyst/evidence \
  ...
```

Now anything written to `/home/analyst/evidence/` inside the container appears at `building/labs/evidence/` on the host.

### Hands-on Exercise

1. Stop and remove the current Kali container (`docker stop kali && docker rm kali`)
2. Recreate Kali with a bind mount for evidence
3. Create a test file inside `/home/analyst/evidence/`
4. Verify it exists on the host
5. Remove the container — verify the file still exists on the host

### Key Takeaway

Bind mounts are the difference between "I saved evidence" and "I saved evidence that survives container destruction." Every container that generates evidence should have a bind mount.

---

## Chunk 2 — Packet Capture with tcpdump

### What We'll Learn

| Concept | Security Relevance |
|---|---|
| tcpdump captures raw network packets | Reconstruct attacks, verify network behavior |
| Different interfaces capture different traffic | eth0 = internet noise, eth1 = attack traffic only |
| `-w` writes binary pcap | Viewable in Wireshark, replayable with `tcpreplay` |
| `-X` prints hex+ASCII | Readable HTTP requests, headers, payloads |

### Why tcpdump on the Internal Interface

Kali's `eth1` is on `lab-net-internal`. Only attack traffic flows here — no internet noise, no ARP chatter from other Docker networks. A capture on `eth1` captures exactly what Kali sends and receives from targets.

`eth0` is on `lab-net-nat` — internet traffic, DNS lookups, apt updates. Much noisier.

### Hands-on Exercise

Run a packet capture alongside an nmap scan:

1. Terminal 1 — start tcpdump on eth1:
```bash
tcpdump -i eth1 -w /home/analyst/evidence/2026-07-01-nmap-dvwa.pcap
```

2. Terminal 2 — run nmap against DVWA:
```bash
nmap -sV -sC -O dvwa
```

3. After scan completes, stop tcpdump (Ctrl+C)

4. Examine the capture:
```bash
tcpdump -r /home/analyst/evidence/2026-07-01-nmap-dvwa.pcap -X | head -50
```

### What We'll Observe in the Capture

| Packet | What It Shows |
|---|---|
| SYN → 172.19.0.2:80 | nmap's port scan probe |
| SYN-ACK ← 172.19.0.2:80 | DVWA confirms port 80 is open |
| RST → 172.19.0.2:80 | SYN scan — nmap never completes handshake |
| GET / HTTP/1.0 | Service version probe (`-sV`) |
| HTTP/1.1 200 OK + Server: Apache/2.4.25 (Debian) | Banner response |
| GET /robots.txt | NSE script `http-robots.txt` |

### Attack/Defense Pairing

- **Attack:** tcpdump captures credentials, session cookies, exploit payloads in transit
- **Defense:** Encrypt traffic (HTTPS on port 443 instead of HTTP on 80). DVWA uses HTTP — all traffic is plaintext
- **Detection:** A pcap on the attack machine is evidence of the attack. If an incident responder finds this pcap, it shows exactly what the attacker did

### Key Takeaway

tcpdump on the internal interface captures clean, noise-free evidence of every attack. The pcap is replayable — you can run the same analysis in Wireshark months later.

---

## Chunk 3 — Application Logs from DVWA

### What We'll Learn

| Concept | Security Relevance |
|---|---|
| Apache access.log logs every HTTP request | IP, path, user-agent, status code — attacker's footprint |
| Nmap NSE scripts leave traces | Each script makes real HTTP requests → visible in logs |
| Logs are evidence of scanning | Indisputable record that a scan happened |

### Where DVWA's Logs Live

DVWA runs Apache inside the container. The access log is at `/var/log/apache2/access.log`. But we can't `docker exec` into DVWA because `vulnerables/web-dvwa` is a minimal image that may not have a shell.

**Alternative 1 — `docker exec` with a command:**
```bash
docker exec dvwa cat /var/log/apache2/access.log
```

**Alternative 2 — Copy the log out:**
```bash
docker cp dvwa:/var/log/apache2/access.log /tmp/dvwa-access.log
```

### Hands-on Exercise

1. From Kali, run an nmap NSE scan against DVWA (or just `curl http://dvwa`)
2. Extract DVWA's Apache access log
3. Identify which entries correspond to:
   - The nmap scan (rapid connections, unusual User-Agent)
   - NSE script requests (GET /robots.txt, GET /)
   - Service version probe (GET / HTTP/1.0)

### What We'll Observe

```
172.19.0.3 - - [01/Jul/2026:12:00:01 +0000] "GET / HTTP/1.0" 302 431 "-" "Nmap Scripting Engine"
172.19.0.3 - - [01/Jul/2026:12:00:02 +0000] "GET /robots.txt HTTP/1.0" 200 27 "-" "Nmap Scripting Engine"
172.19.0.3 - - [01/Jul/2026:12:00:03 +0000] "GET /login.php HTTP/1.0" 200 2341 "-" "Nmap Scripting Engine"
```

The source IP (172.19.0.3 = Kali), the unusual User-Agent (`Nmap Scripting Engine`), and the rapid timing are all scanning signatures.

### Attack/Defense Pairing

- **Attack:** nmap probes reveal the server stack and app → attacker chooses exploit
- **Defense:** Log monitoring detects the scan in real time. Fail2ban can block the source IP after N rapid requests
- **Detection:** The `access.log` is the definitive record. A burst of GET requests from one IP with `Nmap Scripting Engine` User-Agent is a high-confidence scan alert

### Key Takeaway

Every nmap NSE script creates a log entry. Scanning is detectable from the target's perspective — there is no truly stealthy full scan. What changes is how long it takes the defender to notice.

---

## Chunk 4 — Evidence Naming Convention

### What We'll Learn

| Concept | Why It Matters |
|---|---|
| Consistent naming = findable evidence | `nmap-dvwa.txt` vs `scan_results_FINAL(2).txt` |
| Date prefix sorts chronologically | `2026-07-01-nmap-dvwa.pcap` sorts by date automatically |
| Tool-target-event pattern | `nmap-dvwa-service-scan.txt` — what, where, what kind |

### The Convention

```
YYYY-MM-DD-tool-target-description.ext
```

Examples:
- `2026-07-01-nmap-dvwa-syn-scan.txt`
- `2026-07-01-tcpdump-dvwa-eth1-capture.pcap`
- `2026-06-30-connectivity-matrix.txt`
- `2026-06-29-kali-build-log.txt`

### Rules

1. **Date first** — ISO 8601 (`YYYY-MM-DD`). Sorts alphabetically = sorts chronologically
2. **Tool or source** — what generated the evidence (nmap, tcpdump, hydra, curl)
3. **Target** — who was targeted (dvwa, kali, lab-net-internal)
4. **Description** — what kind of evidence (syn-scan, service-detect, pcap, log)
5. **No spaces** — use hyphens. Works in URLs, scripts, CLI operations
6. **No version suffixes** — `FINAL`, `v2`, `_fixed` create confusion. If you need versions, add a timestamp instead

### Hands-on Exercise

Review the existing evidence files and rename any that don't match:
```bash
ls -1 learning/phases/phase-0-secure-lab/evidence/
# Do all files follow the convention? Fix any that don't.
```

---

## Chunk 5 — Evidence Handling Rules

### What We'll Learn

| Rule | Why |
|---|---|
| Evidence lives on the host, not in containers | Container destruction = evidence loss |
| Raw evidence is never edited | Edited evidence has no chain of custody |
| Evidence files are plain text or standard formats | pcap, txt, csv, json — no proprietary formats |
| Sensitive data in evidence is flagged | Logs may contain passwords, tokens, PII |

### The Rules

```
## Evidence Handling Rules

1. ALWAYS use bind mounts for evidence directories
2. NEVER edit raw evidence files — annotate in a separate notes file
3. ALWAYS use the naming convention: YYYY-MM-DD-tool-target-description.ext
4. ALWAYS save evidence to `learning/phases/phase-N-*/evidence/` after the session
5. FLAG any evidence containing passwords, tokens, or PII
6. DELETE evidence from the Kali container after copying to host
7. KEEP evidence until the related lab session is complete and the learning note is written
```

### Hands-on Exercise

Write the rules to `building/labs/EVIDENCE-HANDLING.md`:
```bash
cat > /home/motafeq/projects/CyberSecEngineer/building/labs/EVIDENCE-HANDLING.md << 'EOF'
# Evidence Handling Rules

## Purpose
Evidence is the raw material of learning. Without it, you cannot prove what happened,
reproduce results, or learn from mistakes.

## Rules
...
EOF
```

---

## Quiz — Session 4

1. You run `docker run -v /host/path:/container/path image`. What happens to the container's original `/container/path` directory?

2. A tcpdump capture on `eth1` shows traffic to `172.19.0.2:80`. You also see traffic to `172.19.0.2:3306`. Why is MySQL traffic visible on this interface even though Kali never connected to MySQL?

3. You find a password in an nmap output file saved as evidence. What do you do? (Three correct actions.)

4. Why does the naming convention put the date first instead of the tool name?

5. A bind mount writes to `/host/evidence/`. You `docker rm` the container and `docker run` a new one with the same bind mount. Are the old evidence files still there? Why?

---

## What We'll Produce

| Artifact | Location |
|---|---|
| tcpdump pcap of nmap scan | `evidence/<date>-nmap-dvwa-capture.pcap` |
| DVWA Apache access log sample | `evidence/<date>-dvwa-access-log.txt` |
| Evidence handling rules | `building/labs/EVIDENCE-HANDLING.md` |
| Kali container with bind mount | Updated `docker run` command |
| Learning note | `notes/09-telemetry-and-evidence.md` |
| Evidence naming convention | Documented in learning note |

---

## Next Session

**Session 5 — Phase 0, Module 0.6:** Documentation system — architecture diagrams, ADR, threat model, recall checklist.
