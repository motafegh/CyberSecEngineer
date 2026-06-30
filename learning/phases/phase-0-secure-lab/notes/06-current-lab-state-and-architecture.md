# Current Lab State — Images, Tools, Networks, and Architecture

> **Date:** 2026-06-29
> **Phase:** Phase 0 — Modules 0.1 through 0.3 complete
> **Next:** Module 0.4 (Vulnerable Target Deployment)
> **Cross-ref:** `notes/02-network-isolation.md` for VM-based concepts, this note is the Docker-specific version

---

## 1. What We Have Right Now

### Docker Images

```bash
docker images
REPOSITORY          TAG           SIZE
kali-lab            with-msf      3.51 GB    ← Full image with msf (committed)
kali-lab            latest        2.53 GB    ← Base image without msf (from Dockerfile)
kalilinux/kali-rolling  latest    1.2 GB     ← Official Kali base (pulled from Docker Hub)
vulnerables/web-dvwa    latest     ?         ← Pulled but not yet used
webgoat/webgoat         latest     ?         ← Pulled but not yet used
bkimminich/juice-shop   latest     ?         ← Pulled but not yet used
```

### Docker Networks

```bash
docker network ls
NETWORK          DRIVER    SCOPE
lab-net-internal  bridge    local    ← No internet (--internal), for targets
lab-net-nat       bridge    local    ← Has internet (default bridge), for Kali
bridge            bridge    local    ← Docker default (not used in lab)
host              host      local    ← Host network (used only during build)
none              null      local    ← No network (not used)
```

**`lab-net-internal`** was created with the `--internal` flag — containers on this network have NO route to the internet. No default gateway, no external DNS resolution. They can only talk to each other on this network.

**`lab-net-nat`** is a regular bridge network — containers get private IPs and traffic is NAT'd through the host to the internet.

### Docker Containers

**None currently running.** No containers exist until we `docker run`. The image is on disk, ready to use.

---

## 2. The Kali Attack Workstation (What's Inside the Image)

### The 22 Apt-Installed Tools

| # | Tool | Category | What It Does | Typical Command |
|---|---|---|---|---|
| 1 | **nmap** | Recon | Port scanning, service detection, OS fingerprinting | `nmap -sV target` |
| 2 | **netcat-openbsd** | Utility | Raw TCP/UDP read/write | `nc -lvnp 4444` |
| 3 | **nikto** | Web Scanning | Scans web servers for known vulnerabilities | `nikto -h target` |
| 4 | **gobuster** | Web BF | Brute-force directories, DNS, S3 buckets | `gobuster dir -u target -w wordlist` |
| 5 | **dirb** | Web BF | Dictionary attack on web directories | `dirb http://target` |
| 6 | **ffuf** | Web Fuzzing | Fast parameter/directory fuzzing | `ffuf -u target/FUZZ -w wordlist` |
| 7 | **sqlmap** | Web Exploit | Automated SQL injection detection + exploitation | `sqlmap -u target?id=1` |
| 8 | **hydra** | Credential | Online password brute-force (SSH, FTP, HTTP, etc.) | `hydra -l user -P passlist ssh://target` |
| 9 | **john** | Credential | Offline password hash cracking | `john hash.txt` |
| 10 | **curl** | Utility | HTTP client for testing APIs and web responses | `curl -v http://target` |
| 11 | **wget** | Utility | Download files, mirror websites | `wget -r http://target` |
| 12 | **tcpdump** | Packet Capture | Capture and analyze raw network traffic | `tcpdump -i eth0 -w capture.pcap` |
| 13 | **python3** | Development | General-purpose scripting language | `python3 exploit.py` |
| 14 | **python3-pip** | Development | Python package manager | `pip3 install requests` |
| 15 | **git** | Version Control | Clone repositories, manage code | `git clone https://...` |
| 16 | **jq** | Utility | Parse and format JSON from command line | `curl api | jq .` |
| 17 | **ncat** | Utility | Netcat with SSL/TLS support | `ncat --ssl target 443` |
| 18 | **socat** | Utility | Bidirectional data relay between two endpoints | `socat TCP-L:8080 TCP:target:80` |
| 19 | **iproute2** | Network | Network configuration (ip, ss, tc, bridge) | `ip addr`, `ip route` |
| 20 | **dnsutils** | Network | DNS lookup tools | `nslookup target`, `dig target` |
| 21 | **iputils-ping** | Network | ICMP connectivity test | `ping -c 4 target` |
| 22 | **sudo** | System | Run commands as root | `sudo apt update` |

### Metasploit Framework (6.4.142)

| Binary | PATH | What It Does |
|---|---|---|
| `msfconsole` | `/usr/local/bin/msfconsole` | Main interactive console — launch exploits, manage sessions |
| `msfvenom` | `/usr/local/bin/msfvenom` | Generate payloads (reverse shells, meterpreter, etc.) |
| `msfdb` | `/usr/local/bin/msfdb` | Initialize and manage the PostgreSQL database for msf |

### The analyst User

- **Username:** `analyst`
- **Password:** `analyst`
- **Groups:** `analyst`, `sudo`
- **Home:** `/home/analyst/`
- **Work directories:**
  - `/home/analyst/reports/` — written findings, screenshots, summaries
  - `/home/analyst/evidence/` — raw output (nmap scans, pcap files, sqlmap output)
  - `/home/analyst/tools/` — custom scripts, downloaded exploits, wordlists

---

## 3. The Network Architecture (Docker Version)

### The Core Design

```
                    WSL2 HOST (Windows)
                           │
            ┌──────────────┴──────────────┐
            │                             │
     ┌──────┴──────┐              ┌───────┴────────┐
     │ lab-net-nat │              │ lab-net-internal│
     │ (internet)  │              │ (--internal)    │
     │ 172.17.x.x  │              │ 172.18.x.x     │
     └──────┬──────┘              └───────┬────────┘
            │                             │
            │     ┌─────────────────┐     │
            └─────│   KALI LINUX    │─────┘
                  │   Container     │
                  │                 │
                  │ eth0: lab-net-  │
                  │      nat        │
                  │                 │
                  │ eth1: lab-net-  │
                  │      internal   │
                  └────────┬────────┘
                           │
                  ┌────────┴────────┐
                  │   TARGETS      │
                  │   (DVWA etc.)  │
                  │                 │
                  │ Only on lab-   │
                  │ net-internal   │
                  └────────────────┘
```

### What Each Network Provides

| Network | Gateway? | Internet? | Can reach host? | Containers on it |
|---|---|---|---|---|
| `lab-net-nat` | ✅ Yes (172.17.0.1) | ✅ Yes (via NAT) | ✅ Yes (via NAT) | Kali only |
| `lab-net-internal` | ❌ No | ❌ No | ❌ No | Kali + all targets |

### Why This Architecture

**The Kali container needs two networks because:**

- It must download exploits, update msf modules, and access documentation → needs `lab-net-nat`
- It must attack isolated targets on a private network → needs `lab-net-internal`
- One container can have multiple network interfaces — Docker handles this natively

**Targets (DVWA, WebGoat, JuiceShop) need only one network because:**

- They should NEVER reach the internet (prevent data exfiltration if compromised)
- They should NEVER reach the host (prevent host compromise)
- They only need to serve web traffic to Kali
- One interface on `lab-net-internal` is sufficient

### How Traffic Routing Works

When Kali runs `nmap 172.18.0.2` (DVWA on internal network):

```
nmap sends packet to 172.18.0.2
  → Kernel checks routing table
  → 172.18.0.0/16 is directly connected on eth1 (lab-net-internal)
  → Packet goes out eth1
  → DVWA receives on eth0 (lab-net-internal)
  → Response comes back through eth1
```

When Kali runs `curl https://github.com`:

```
curl sends packet to 140.82.121.4 (GitHub)
  → Kernel checks routing table
  → 140.82.121.4/32 is NOT in any directly connected network
  → Uses default gateway (0.0.0.0/0)
  → Default gateway is on eth0 (lab-net-nat)
  → Packet goes out eth0 → Docker NAT → WSL2 → Windows → internet
  → Response comes back the same way
```

Docker's routing handles this automatically — no special configuration needed.

### The Isolation Matrix (What We Will Verify)

| From → To | Expected | Why |
|---|---|---|
| Kali → Internet | ✅ Reachable | `lab-net-nat` has gateway |
| Kali → Target (internal) | ✅ Reachable | Same `lab-net-internal` network |
| Kali → Target (by DNS name) | ✅ Reachable | Docker DNS resolves container names |
| Target → Internet | ❌ Blocked | `lab-net-internal` has no gateway |
| Target → WSL2 Host | ❌ Blocked | No route, no port mapping |
| Host → Target (by IP) | ❌ Blocked | Host not on `lab-net-internal` |
| Target → Kali | ✅ Reachable | Same network, Kali is reachable |
| Internet → Target | ❌ Blocked | No public IP, no port forwarding |

---

## 4. How Everything Connects — Command Reference

### Run Kali with Both Networks

```bash
# Step 1: Create container on lab-net-nat
docker run -dit --name kali \
  --network lab-net-nat \
  --user analyst \
  kali-lab:with-msf

# Step 2: Attach second network
docker network connect lab-net-internal kali

# Step 3: Get interactive shell
docker exec -it kali bash
```

Or in one command (shorter):
```bash
# Create with no network, then connect both
docker run -dit --name kali --network none --user analyst kali-lab:with-msf
docker network connect lab-net-nat kali
docker network connect lab-net-internal kali
docker exec -it kali bash
```

### Run Target on Internal Network

```bash
docker run -dit --name dvwa \
  --network lab-net-internal \
  vulnerables/web-dvwa
```

### Verify Connectivity

```bash
# From inside Kali:
ping -c 4 8.8.8.8                              # Should work (internet via nat)
ping -c 4 dvwa                                  # Should work (DNS resolves container name)
curl -sI http://dvwa                            # Should work (HTTP response)
nmap -p 80 dvwa                                 # Should show port 80 open

# From inside DVWA (separate terminal):
docker exec -it dvwa ping 8.8.8.8              # Should FAIL (no internet)
docker exec -it dvwa ping kali                 # Should work (same network)
```

---

## 5. Summary — What We Built, Why, and What's Next

### What We've Built (Sessions 1-2)

| Component | Status | Purpose |
|---|---|---|
| `lab-net-internal` | ✅ Created | Isolated network for targets (no internet) |
| `lab-net-nat` | ✅ Created | Network with internet for Kali |
| `kali-lab:with-msf` image | ✅ Built | Attack workstation with 22 tools + msf |
| `analyst` user (non-root) | ✅ Configured | Defense-in-depth, habit for production work |
| Host safety checklist | ✅ Written | 5 hard rules for working with offensive tools |
| Lab directory structure | ✅ Created | `building/labs/` with compose, configs, evidence |

### What's Next

| Module | What We'll Do | Artifact |
|---|---|---|
| 0.4 — Targets | Run DVWA, WebGoat, JuiceShop on `lab-net-internal` | `TARGET-INVENTORY.md` |
| 0.4 — Verification | Test the isolation matrix with real connectivity checks | `CONNECTIVITY-MATRIX.md` |
| 0.5 — Evidence | Mount host directories for saving output, tcpdump captures | Evidence files |
| 0.6 — Docs System | Complete documentation structure, ADR, threat model | Learning notes |
| Capstone | Full lab is built, isolated, documented, and reproducible | README for the lab |

### Safety Rules Recap

From `building/labs/HOST-SAFETY-CHECKLIST.md`:

1. **Never port-map vulnerable targets** to the host (`-p` flag)
2. **Never run target containers on host or NAT networks** — only `lab-net-internal`
3. **Always run Kali as analyst, not root**, unless necessary for installation
4. **Always verify isolation** after starting new containers (ping test both directions)
5. **Delete all evidence** when done with a lab session (container `docker rm` or volume cleanup)
