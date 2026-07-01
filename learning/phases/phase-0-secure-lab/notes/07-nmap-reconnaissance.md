# nmap Reconnaissance — From Zero to First Scan

> **Session:** Session 3 (Phase 0, Module 0.4)
> **Target:** DVWA (Damn Vulnerable Web Application)
> **Attacker:** Kali container on `lab-net-internal`
> **Evidence:** `evidence/2026-06-30-nmap-dvwa.txt`, `evidence/2026-06-30-connectivity-matrix.txt`

---

## 1. Why Reconnaissance Matters

Before any exploit runs, you must know what you are attacking. In real engagements, reconnaissance takes 70% of the time. An attacker who runs an exploit without recon is guessing. An attacker who does recon first is aiming.

Reconnaissance answers four questions, in order:

1. **What hosts are alive?** (host discovery — ping sweeps)
2. **What ports are open?** (port scanning — which doors are unlocked)
3. **What services are running?** (service fingerprinting — what's behind each door)
4. **What versions and vulnerabilities?** (version detection + NSE scripts)

**Concept Box — What Is a Port Number?**

A port number is a **16-bit identifier** (0–65535) that tells the OS which application should receive incoming data. Think of it like an apartment number in a building:

- **IP address** = building address (172.19.0.2)
- **Port number** = apartment door (80, 443, 22, 3306)

When you connect to `http://172.19.0.2`:80, your browser's OS puts port 80 in the TCP header. The server's OS reads it, knowing that port 80 is registered for HTTP, and delivers the data to Apache (which bound to port 80). Without ports, every application would need its own IP address, or every packet would go to every application.

Port ranges:
- **0–1023**: Well-known ports (system services — HTTP=80, HTTPS=443, SSH=22, FTP=21)
- **1024–49151**: Registered ports (user services — MySQL=3306, PostgreSQL=5432)
- **49152–65535**: Dynamic/ephemeral (temporary, used as source ports by clients)

In scanning, each port is either **open** (something listens), **closed** (port reachable but nothing listens), or **filtered** (firewall drops the probe).

nmap (Network Mapper) is the standard tool for all four. It was created by Gordon Lyon (Fyodor) in 1997 and remains the most widely used network discovery tool in security. No single tool covers more ground in one pass.

---

## 2. How nmap Works — The Mechanism

### 2.1 Host Discovery

**Concept Box — What Is ICMP?**

ICMP (Internet Control Message Protocol) is a companion protocol to IP — it's not TCP or UDP, but a separate protocol (protocol number 1) used for **control messages** between network devices. Think of it as the network's intercom system:

- **ICMP Echo Request (type 8)**: "Are you there?" — the `ping` command sends this
- **ICMP Echo Reply (type 0)**: "Yes, I'm here" — the target responds
- **ICMP Destination Unreachable (type 3)**: "Can't reach that host/port" — a router or firewall sends this
- **ICMP Time Exceeded (type 11)**: "Packet lived too long" — used by `traceroute`

ICMP has **no ports** — it's identified by type and code numbers, not port numbers. Firewalls can (and should) block ICMP echo to prevent host discovery, but blocking ALL ICMP breaks path MTU discovery (type 3, code 4), which can cause connectivity issues.

nmap sends probes to determine if a target is alive. The default probe is:
- ICMP echo request (ping)
- TCP SYN to port 443
- TCP ACK to port 80
- ICMP timestamp request

If any probe gets a response, the host is marked "up." If all fail, the host is skipped to save time (use `-Pn` to skip this phase entirely and scan anyway).

### 2.2 Port Scanning — Three-Way Handshake

TCP is a connection-oriented protocol. Every TCP connection starts with a **three-way handshake**:

```
Client → SYN        → Server     "I want to connect on this port"
Client ← SYN-ACK    ← Server     "OK, I'm listening here"
Client → ACK        → Server     "Great, connection established"
```

nmap has two main modes for port scanning, distinguished by whether the handshake completes:

#### TCP Connect Scan (`-sT`)

nmap completes the full handshake then immediately tears it down with a RST:

```
Client → SYN        → Server
Client ← SYN-ACK    ← Server
Client → ACK        → Server     ← Handshake COMPLETE
Client → RST        → Server     ← nmap closes immediately
```

- **Reliable** — works on any OS, any user (no root needed)
- **Noisy** — every connection is logged by the target. Apache's `access.log` will show GET requests from script probes. The kernel's `conntrack` (connection tracking) table logs every completed connection.

**Concept Box — What Is conntrack?**

`conntrack` is the Linux kernel's **connection tracking** system (part of the netfilter framework, which is the same subsystem that powers iptables). The kernel inspects every passing packet and records which connections are active:

- **Source IP:port → Dest IP:port** — a 5-tuple uniquely identifying each flow
- **State** — `NEW` (SYN seen but no reply), `ESTABLISHED` (handshake complete), `RELATED` (e.g., FTP data channel related to control channel)
- **Protocol** — TCP, UDP, ICMP
- **Timeout** — when to expire the entry (default ~5 days for established TCP, but much shorter for incomplete SYNs)

When you run a TCP Connect scan and complete the handshake, the kernel creates a `conntrack` entry with state `ESTABLISHED`. Even though nmap immediately sends RST, the entry stays in the table until the timeout expires. An administrator can inspect `/proc/net/nf_conntrack` or use the `conntrack` CLI tool to see every connection — including the scan. This is why TCP Connect scans are detectable even if the application (Apache) doesn't log incomplete connections.

SYN scans (`-sS`) do NOT complete the handshake (they don't send the final ACK), so the target's kernel sees state `NEW` or `SYN_RECV` — which times out much faster (typically 60 seconds vs 5 days). This is one reason SYN scans are considered "stealthier" — they leave a much smaller window in conntrack.

#### SYN Scan (`-sS`) — The Default as Root

nmap sends only the SYN and watches for the response. The handshake NEVER completes:

```
Client → SYN        → Server
Client ← SYN-ACK    ← Server     (port is open)
Client → RST        → Server     ← Handshake ABORTED
```

- **Stealthier** — many applications don't log incomplete handshakes
- **Faster** — no need to complete and tear down each connection
- **Requires root/raw sockets** — needs `CAP_NET_RAW` to craft raw packets

The response tells nmap the port state:

| Server Response | Port State | Meaning |
|---|---|---|
| SYN-ACK | **open** | A service is listening |
| RST | **closed** | Port is reachable but nothing is listening |
| No response (timeout) | **filtered** | Firewall dropped the probe |
| ICMP unreachable | **filtered** | Firewall rejected the probe |

**Concept Box — What Is HTTP (the Protocol)?**

HTTP (Hypertext Transfer Protocol) is a **text-based request/response protocol** that runs over TCP (usually port 80). The client sends a request line, headers, and optionally a body. The server responds with a status line, headers, and a body.

A minimal HTTP request:
```http
GET / HTTP/1.1
Host: dvwa
```
- `GET` = the method (retrieve a resource)
- `/` = the path (root of the website)
- `HTTP/1.1` = protocol version
- `Host:` header = which virtual host (required since HTTP/1.1)

A minimal HTTP response:
```http
HTTP/1.1 200 OK
Server: Apache/2.4.25 (Debian)
Content-Type: text/html
```
- `200 OK` = status code (success)
- `Server:` = header revealing the web server software and version
- `Content-Type:` = tells the browser how to render the body

HTTP is **stateless** — each request is independent. State (like login sessions) is maintained through cookies (like DVWA's `PHPSESSID`). The protocol sends everything in plain text unless TLS (HTTPS on port 443) encrypts it.

### 2.3 Service Version Detection (`-sV`)

After finding open ports, nmap sends application-layer probes to each one. For HTTP (port 80), it sends something like `GET / HTTP/1.0` and reads the response headers.

It extracts:
- **Service name** — Apache, nginx, IIS, sshd, etc.
- **Version string** — `Apache httpd 2.4.25`, `OpenSSH 8.9p1`
- **OS hints** — `(Debian)`, `(Ubuntu)`, `(FreeBSD)`

The version is extracted from **banners** — text that services send to identify themselves. Apache sends a `Server:` header. SSH sends a banner on connection. These banners are often configurable, so version detection can be fooled by banner obfuscation.

### 2.4 OS Detection (`-O`)

nmap analyzes subtle differences in how the target's TCP/IP stack responds to crafted probes. This is called **TCP/IP fingerprinting**. Different operating systems implement the TCP stack slightly differently (initial TTL values, window sizes, how they handle out-of-spec packets).

nmap sends up to 16 different test probes (T1-T7, U1, IE) and compares the responses against its database of known OS fingerprints.

### 2.5 NSE Scripts (`-sC`)

The Nmap Scripting Engine (NSE) contains hundreds of Lua scripts categorized as:
- **safe** — informational checks, no exploitation (the `-sC` default set)
- **default** — balance of safety and usefulness
- **intrusive** — may crash services or trigger alarms
- **vuln** — checks for specific CVEs
- **exploit** — attempts actual exploitation

---

## 3. The Problem: Docker Blocks nmap

When we tried to run nmap from the Kali container, it failed:

```
/usr/bin/nmap: 6: exec: /usr/lib/nmap/nmap: Operation not permitted
```

### 3.1 The Wrapper Script

`/usr/bin/nmap` is not the real binary — it's a 165-byte shell wrapper:

```sh
#!/usr/bin/env sh
set -e
if [ "$(id -u)" -eq 0 ] || [ "$1" = "--resume" ]; then
  exec /usr/lib/nmap/nmap "$@"
else
  exec /usr/lib/nmap/nmap --privileged "$@"
fi
```

Logic:
- If running as root → exec the real binary directly
- If NOT root → add `--privileged` flag (needed for raw sockets)

Our Kali container runs as the `analyst` user with `sudo` access. The wrapper tried `--privileged` mode. This requires `CAP_NET_RAW` — which the analyst user doesn't have.

### 3.2 Even sudo Didn't Work

Running `sudo nmap` (as root) still failed. This exposed the second layer of Docker security.

Docker restricts containers by default at **three levels**:

```
┌──────────────────────────────────────────────────┐
│ 1. SECCOMP (syscall filter)                      │
│    Blocks specific syscalls at kernel level      │
│    Even with the right capability, the syscall   │
│    is rejected before it reaches the kernel.     │
│    ┌────────────────────────────────────────┐    │
│    │ 2. CAPABILITIES (privilege subsets)    │    │
│    │    Drops dangerous capabilities         │    │
│    │    --cap-add=NET_RAW restores them      │    │
│    │    ┌──────────────────────────────┐    │    │
│    │    │ 3. USER NAMESPACE            │    │    │
│    │    │  root in container ≠         │    │    │
│    │    │  root on host                │    │    │
│    │    └──────────────────────────────┘    │    │
│    └────────────────────────────────────────┘    │
└──────────────────────────────────────────────────┘
```

| Layer | Block | How nmap hits it |
|---|---|---|
| **Seccomp** | Blocks `socket()` with `SOCK_RAW` | SYN scan needs raw packets |
| **Capabilities** | `CAP_NET_RAW` dropped by default | Without it, can't open raw socket even if seccomp allows |
| **User namespace** | Container root mapped to unprivileged user on host | Can't escape the container, but also can't access host raw sockets |

### 3.3 The Fix

```bash
docker run --security-opt seccomp=unconfined --cap-add=NET_RAW --cap-add=NET_ADMIN ...
```

- **`--security-opt seccomp=unconfined`** — disables Docker's syscall filter. Needed because Docker's default seccomp profile specifically blocks `socket(SOCK_RAW)` even when `CAP_NET_RAW` is granted.
- **`--cap-add=NET_RAW`** — allows the container to create raw sockets (SYN scan, packet crafting)
- **`--cap-add=NET_ADMIN`** — allows network administration (tcpdump, iptables, interface config)

### 3.4 The Trade-off

We relaxed security on Kali intentionally. Kali is the **trusted attack workstation**. It needs these capabilities to run security tools. The targets (DVWA, WebGoat, JuiceShop) run with **default restrictions** — they don't need raw sockets. This is defense-in-depth: the attacker has full tools, the targets have minimal permissions.

If a target is compromised, the attacker inside it cannot run nmap because the target container lacks `CAP_NET_RAW` and has seccomp enabled. Lateral movement is blocked at the capability level.

---

## 4. The Scan

### 4.1 Command

```bash
nmap -sV -sC -O dvwa -oN /tmp/nmap-dvwa.txt
```

| Flag | Full name | What it does |
|---|---|---|
| `-sV` | Service/Version detection | Probes open ports with application-layer payloads to identify exact service and version |
| `-sC` | Default scripts | Runs the "safe" set of NSE scripts (informational checks, no exploitation) |
| `-O` | OS detection | Sends 16+ TCP/IP probes and fingerprints the stack against nmap's database |
| `dvwa` | Target | Resolved by Docker DNS to `172.19.0.2` on `lab-net-internal` |
| `-oN` | Output Normal | Saves results to file in human-readable format (for evidence) |
| *(implicit)* | `-sS` SYN scan | Default scan type when run as root (raw SYN packets, no handshake completion) |

### 4.2 Raw Output

```
Starting Nmap 7.99 ( https://nmap.org ) at 2026-06-30 20:23 +0000
Nmap scan report for dvwa (172.19.0.2)
Host is up (0.000074s latency).
rDNS record for 172.19.0.2: dvwa.lab-net-internal
Not shown: 999 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
80/tcp open  http    Apache httpd 2.4.25 ((Debian))
| http-title: Login :: Damn Vulnerable Web Application (DVWA) v1.10 *Develop...
|_Requested resource was login.php
| http-cookie-flags: 
|   /: 
|     PHPSESSID: 
|_      httponly flag not set
| http-robots.txt: 1 disallowed entry 
|_/
|_http-server-header: Apache/2.4.25 (Debian)
MAC Address: EA:E8:B1:20:0B:26 (Unknown)
No exact OS matches for host (TCP/IP fingerprint below)
Network Distance: 1 hop
Nmap done: 1 IP address (1 host up) scanned in 18.36 seconds
```

### 4.3 Line-by-Line Analysis

**`Nmap 7.99`** — The version of nmap in our Kali image. Released 2026.

**`0.000074s latency`** — 74 microseconds. This is extremely fast because Kali and DVWA are on the same Docker bridge network. No router, no physical cable — just kernel-level packet forwarding. Real-world LAN latency is typically 0.3-3ms. WAN latency is 10-200ms.

**`rDNS record: dvwa.lab-net-internal`** — Docker's embedded DNS (127.0.0.11) performs reverse DNS lookup and returns the container's network-scoped hostname. This confirms Docker DNS is working and the container name registered correctly.

**`999 closed tcp ports (reset)`** — nmap scanned the top 1000 ports. 999 responded with RST (closed — reachable but nothing listening). This means **no firewall** is between Kali and DVWA. If a firewall were present, those ports would show as "filtered" (no response or ICMP unreachable). The absence of filtering tells us the internal network has no packet filtering — it's a flat, open segment.

**`80/tcp open http Apache httpd 2.4.25 ((Debian))`** — This one line contains five pieces of information:
| Element | Meaning | Implication |
|---|---|---|
| Port 80 | Standard HTTP port | Web application attack surface |
| State: open | Service is listening | Can connect and interact |
| Service: http | Web server | Expect HTTP protocol |
| Apache 2.4.25 | Exact version | Released 2017. Old — known CVEs exist. |
| (Debian) | OS base | Target is a Debian-based Linux system |

**`http-title: Login :: Damn Vulnerable Web Application (DVWA) v1.10`** — The `<title>` tag from the HTML. nmap fetched the page and extracted it. This tells us the exact application and version without visiting the page. The `*Develop...` truncation means the full title was longer than nmap's display width.

**`http-cookie-flags: PHPSESSID httponly flag not set`** — NSE script `http-cookie-flags` checked the cookies returned by the server. `PHPSESSID` is the PHP session cookie — used to track authenticated sessions. The `HttpOnly` flag prevents JavaScript from accessing the cookie. Without it, an XSS vulnerability can steal the session cookie directly. This is a common security misconfiguration.

**`http-robots.txt: 1 disallowed entry /`** — NSE script `http-robots.txt` fetched `/robots.txt` and found it disallows all crawlers from `/`. In a real engagement, this tells you what the site wants to hide (often admin panels, config files, or sensitive directories).

**`http-server-header: Apache/2.4.25 (Debian)`** — The `Server:` response header. This confirms the version from the server itself (not guessed from behavior). Banners are configurable — many hardened servers hide or fake this header.

**`MAC Address: EA:E8:B1:20:0B:26 (Unknown)`** — Docker generates random MAC addresses for each container interface. The OUI (Organizationally Unique Identifier — the first 3 bytes of a MAC address, assigned by the IEEE to identify the hardware manufacturer) is `EA:E8:B1`, which is not registered to any manufacturer — confirming this is a Docker-assigned virtual MAC, not a real NIC.

**`No exact OS matches`** — The TCP fingerprint didn't match any OS in nmap's database. This is common for lightweight Docker containers (minimal kernel, tuned network stack). However, `Apache/2.4.25 (Debian)` already told us the OS — the fingerprint just couldn't confirm it independently.

**`Network Distance: 1 hop`** — Directly connected. Kali and DVWA are on the same Layer 2 segment (Docker bridge). No router between them.

**Concept Box — What Is a Layer 2 Segment (L2 Segment)?**

The OSI networking model has 7 layers. Layer 2 (Data Link) handles **direct communication between devices on the same physical or virtual network** using MAC addresses. An L2 segment is the set of devices that can talk to each other without going through a router:

- Devices on the same L2 segment can exchange **ARP** (Address Resolution Protocol — "who has IP 172.19.0.2? Tell me your MAC") and **Ethernet frames** directly
- A **router** is needed to cross between L2 segments (Layer 3 — IP routing)
- Docker bridge networks create one L2 segment per bridge. Containers on `lab-net-internal` are all on the same L2 segment

"1 hop" = the packet went directly from Kali to DVWA with no intermediate router. This means nmap gets the most accurate timing (no router delays skewing RTT), and there's no router doing packet filtering between them — confirming the flat, unfiltered network topology.

**`18.36 seconds`** — Total scan time. 1000 ports + service probes + scripts + OS detection in 18 seconds. Most of the time was spent on service version probes (waiting for responses from each open port's application-layer probes).

---

## 5. What the Attack Surface Looks Like Now

From the nmap scan alone, an attacker knows:

```
TARGET: dvwa (172.19.0.2)
  ├── OS: Linux (Debian-based, confirmed by Apache banner)
  ├── WEB: Apache 2.4.25 (old, known CVEs)
  │     └── DVWA v1.10 (known vulnerable application)
  │           ├── Login page at /login.php
  │           ├── Session cookie lacks HttpOnly flag
  │           └── robots.txt disallows /
  ├── PORTS: 1 open (80), 999 closed
  ├── FIREWALL: None detected on internal network
  └── MYSQL: Not exposed (bound to localhost, good practice)
```

Each finding narrows the attack path:
- Only one entry point → port 80 HTTP
- Must be web application attacks (SQLi, XSS, file upload, command injection)
- Apache 2.4.25 may have known CVEs, but the real target is the PHP app
- No firewall means no rate limiting, no WAF, no IPS between Kali and DVWA

**Concept Box — WAF and IPS**

- **WAF (Web Application Firewall)**: Inspects HTTP traffic at the application layer (Layer 7). Looks for SQL injection patterns (`' OR 1=1--`), XSS payloads (`<script>`), path traversal (`../../etc/passwd`), and blocks malicious requests before they reach the web application. Examples: ModSecurity (open source), Cloudflare WAF, AWS WAF.
- **IPS (Intrusion Prevention System)**: Inspects network traffic at Layers 3–4 (IP, TCP) and sometimes Layer 7. An IPS can detect nmap scans by spotting: rapid connection attempts to many ports, incomplete handshakes (SYN without ACK), unusual TCP flag combinations. It sits **inline** — traffic flows THROUGH it, and it can drop packets in real time. Examples: Snort (in inline mode), Suricata.
- **Detection vs Prevention**: An IDS (Intrusion Detection System) just **alerts** — it sees traffic via a mirror port and can only log, not block. An IPS is placed in the traffic path and can actively **drop** packets. In a lab context, the absence of both means every probe reaches the target unfiltered — what nmap sees is exactly what exists.

---

## 6. Attack/Defense Pairing

### Offensive Use

- `-sV` reveals exact software versions → attacker searches for known CVEs
- `-sC` scripts check for common misconfigurations (missing httponly, disallowed robots.txt entries)
- `-O` narrows the OS → specific exploit targeting
- Closed vs filtered distinction tells attacker whether a firewall exists

### Defensive Countermeasures

- **Banner obfuscation**: Change `Server: Apache/2.4.25 (Debian)` to `Server: Web Server` or a fake value. Slows down but doesn't stop determined attackers (behavioral fingerprinting still works).
- **Port minimization**: DVWA already does this well — only port 80 is open. MySQL is bound to localhost only.
- **Rate limiting**: Fail2ban or similar can detect rapid port scans and block the source IP.
- **Logging**: Every nmap NSE script HTTP request appears in Apache's `access.log`. A burst of GET requests to unusual paths (robots.txt, sitemap.xml, etc.) from one IP is a scanning signature.
- **Firewalling**: Adding iptables rules on the internal network could make ports show as "filtered" instead of "closed," hiding the attack surface.

### Detection

How do you detect an nmap scan from the target's perspective?

| Scan Component | Log Artifact |
|---|---|
| SYN probe | No handshake completes → no Apache log entry. But kernel may log incomplete connections to `conntrack` |
| NSE script HTTP requests | Each script makes HTTP requests → visible in Apache `access.log` |
| Service version probe (`-sV`) | GET / HTTP/1.0 → visible in access log with unusual User-Agent or method |
| OS detection | Unusual TCP packets (out-of-order flags, weird window sizes) → may trigger IDS/IPS |

---

## 7. Evidence Saved

| File | Content |
|---|---|
| `evidence/2026-06-30-nmap-dvwa.txt` | Raw nmap output with all findings |
| `evidence/2026-06-30-connectivity-matrix.txt` | Network isolation verification results |

---

## 8. Key Takeaways

1. **nmap answers four questions in one pass**: what's alive, what's open, what's running, what version. No other tool does all four.

2. **Docker restricts containers at three levels**: seccomp, capabilities, user namespace. Security tools need explicit opt-in via `--security-opt seccomp=unconfined --cap-add=NET_RAW --cap-add=NET_ADMIN`.

3. **The SYN vs Connect distinction matters operationally**: SYN scan is stealthier but needs root. TCP Connect works as any user but leaves more traces.

4. **One open port tells you the entire attack surface**: DVWA has only port 80. The attack MUST be web application layer. No other entry points exist. This focuses the attacker's effort.

5. **Banners reveal everything**: Apache version, OS base, app version, cookie config — all leaked by the server's own responses. Banner obfuscation is a cheap, effective defense.

6. **Evidence from one scan lasts forever**: The output saved to a file can be re-read weeks later. Without saving, you rely on memory. Always use `-oN`.
