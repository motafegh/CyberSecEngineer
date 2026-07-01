# Phase 0 Progress Tracker — Secure Lab and Cyber Range

> Phase 0 detail. Root summary: `learning/progress-tracker.md`
> Roadmap source: `Roadmap/ROADMAP-INDEX.md`
> Only Ali marks modules complete — no auto-marking.

---

### Module 0.1 — Host Workstation Safety
**Status:** ✅ Complete (confirmed by Ali)
**Sessions:** Session 1

**Concepts covered:**
- Host trust model: Windows → WSL2 → Docker. Host is the root of trust — if compromised, all lab boundaries weaken.
- System inventory: Ubuntu 24.04, i7-12700H, 50Gi RAM, kernel 6.18.33.2, Docker 29.5.3
- Lab directory structure: `building/labs/` with `iso/`, `configs/`, `compose/`, `evidence/`
- Docker isolation model: containers share host kernel but are namespace-isolated (PID, network, mount, user)
- NAT vs bridge vs host vs internal network modes
- Host safety rules: (1) never port-map vulnerable targets, (2) never run targets on host/NAT networks, (3) always run Kali as non-root, (4) verify isolation after starting containers, (5) delete evidence after sessions

**Key decisions:**
- No nested VMs — Docker only (WSL2 limitation)
- No bridged networking for vulnerable targets
- All lab files stay inside CyberSecEngineer project directory

**Artifacts:**
- `learning/phases/phase-0-secure-lab/notes/01-host-safety.md` — full educational doc with host safety rules embedded

**Problems encountered:**
- None — straightforward

---

### Module 0.2 — Virtualization and Isolation
**Status:** ✅ Complete (confirmed by Ali)
**Sessions:** Session 1

**Concepts covered:**
- Docker network modes: bridge (default NAT, 172.17.x.x), host (shares host stack), none (loopback only), internal (no gateway)
- `--internal` flag: creates a network with no default gateway — containers cannot reach the internet
- `lab-net-internal` (--internal) vs `lab-net-nat` (regular bridge) — Kali gets both, targets get only internal
- Single Kali container with two network interfaces (eth0 on NAT, eth1 on internal)
- How `ping 8.8.8.8` succeeds from NAT but fails from internal — verifies isolation
- Docker DNS: containers resolve each other by name on user-defined networks

**Key decisions:**
- Use Docker `--internal` networks instead of VM host-only adapters
- Kali needs two networks: one for internet (updates/downloads), one for attacking targets
- Targets get only the internal network — no internet, no host access

**Artifacts:**
- `learning/phases/phase-0-secure-lab/notes/02-network-isolation.md` — Docker-specific network architecture
- `learning/phases/phase-0-secure-lab/evidence/2026-06-29-session-1-docker-isolation.txt` — ping test results

**Problems encountered:**
- None — Docker handles routing automatically when a container is on multiple networks

---

### Module 0.3 — Linux Attack/Defense Workstation
**Status:** ✅ Complete (confirmed by Ali)
**Sessions:** Session 2 (main), Session 3 review

**Concepts covered:**

*Docker fundamentals:*
- Image vs Container (class/instance analogy)
- Docker layers: additive, immutable, `apt clean` must be in same RUN to avoid wasted space
- Layer caching: what gets cached on success, what doesn't on failure
- `docker commit`: saving container state as a new image layer
- BuildKit: cache mounts (`--mount=type=cache`) that persist across failed builds
- Multi-stage builds: builder stage (compile) + runtime stage (minimal)
- Pre-built images: building once, committing, using forever

*Build strategies (6 approaches documented):*
1. Single Dockerfile RUN — failed (bridge NAT timeouts)
2. BuildKit cache mounts — not tried, documented for future
3. Split RUNs (layered install) — discovered during debugging
4. Lean Dockerfile + container CLI + commit — WORKED
5. Multi-stage builds — not tried, documented for future
6. Pre-built base images — not tried, documented for future

*Network debugging:*
- `--network host` bypasses Docker bridge NAT for reliable mirror access
- `Ign:` means apt tried but connection didn't respond — will retry
- `Err:` means all retries exhausted — package unreachable
- Same package failing across different networks means the package is the problem, not the network
- Two-failure rule: if same approach fails twice the same way, switch methods

*Metasploit installation (6 failed approaches, 1 working):*
1. apt from Dockerfile → mirror timeout (522 MB deb unreachable)
2. `gem install metasploit-framework` → empty stub (v6.0.33, 0 files extracted)
3. Rapid7 apt repo + GPG → gpg missing, then apt ignored the new repo
4. Direct .deb from GitHub Releases → wrong URL, downloaded 9 bytes
5. `git clone` + `bundle install` → missing C headers (libyaml-dev, libffi-dev, libpq-dev)
6. Same but with -dev packages installed → SUCCESS (msf 6.4.142, 250 gems)

*The 22 tools and their categories:*
- Recon: nmap, gobuster, dirb, ffuf
- Web scanning: nikto, sqlmap
- Credential attacks: hydra, john
- Network/utility: tcpdump, ncat, socat, curl, wget, netcat-openbsd
- Development: python3, python3-pip, git, jq
- System: sudo, iproute2, dnsutils, iputils-ping

**Key decisions:**
- `metasploit-framework` excluded from apt in Dockerfile (unreliable mirrors) — installed via `git clone` + `bundle install` in a committed layer
- Build with `--network host`, but run with `--internal` for isolation
- `analyst` user with sudo for defense-in-depth
- Image saved as `kali-lab:with-msf` (3.51 GB) — cannot rebuild from Dockerfile alone, must use committed image

**Artifacts:**
- `building/labs/compose/kali/Dockerfile` — final Dockerfile (22 tools, no msf)
- `kali-lab:with-msf` image — committed, has full msf
- `learning/phases/phase-0-secure-lab/notes/03-kali-build-trial-and-error.md` — full failure log
- `learning/phases/phase-0-secure-lab/notes/04-docker-deep-dive-images-layers-caching.md`
- `learning/phases/phase-0-secure-lab/notes/05-docker-build-strategies-complete-guide.md`
- `learning/phases/phase-0-secure-lab/notes/06-current-lab-state-and-architecture.md`

**Problems encountered:**
1. Docker bridge NAT drops long apt downloads — fixed with `--network host`
2. Kali mirrors don't carry the 522 MB msf deb reliably — switched to `git clone` + `bundle install`
3. `gem install` produced empty stub (v6.0.33) — detected via `ls` on gem directory
4. Rapid7 repo needed `gpg` and `ca-certificates` — not in base image
5. `bundle install` failed on 3 missing C headers — fixed with `apt install -dev` packages
6. `xmlrpc` gem missing from Ruby 3.3 stdlib — installed manually

---

### Module 0.4 — Vulnerable Target Zone
**Status:** 🔄 In Progress (DVWA deployed and scanned; WebGoat, Juice Shop pending)
**Sessions:** Session 3

**Concepts covered:**
- Target deployment on `--internal` network: `docker run --network lab-net-internal` with no `-p` flag
- Docker DNS resolution by container name on user-defined bridges
- Kali dual-network architecture: `docker network connect` attaches second interface
- Connectivity matrix methodology: ping in both directions, curl, nmap
- `ss -tlnp` on host to verify no exposed ports
- Docker seccomp/capability limitation: `--security-opt seccomp=unconfined --cap-add=NET_RAW --cap-add=NET_ADMIN` needed for nmap raw sockets
- nmap scan against DVWA: service detection (`-sV`), NSE scripts (`-sC`), OS detection (`-O`)
- Evidence capture: connectivity matrix + nmap output saved to `evidence/`

**Key decisions:**
- Targets run with DEFAULT Docker security restrictions (no `--cap-add`, no seccomp override) — blocks lateral movement if compromised
- Kali needs two capability overrides for raw sockets: `NET_RAW` (ICMP, raw IP) and `NET_ADMIN` (interface config for tcpdump)
- Connectivity matrix saved as plain text; nmap scan saved as `.txt` (`.pcap` capture deferred)

**Artifacts:**
- `learning/phases/phase-0-secure-lab/notes/07-nmap-reconnaissance.md` — full scan analysis
- `learning/phases/phase-0-secure-lab/notes/08-target-deployment-and-isolation.md` — deployment and verification
- `learning/phases/phase-0-secure-lab/evidence/2026-06-30-connectivity-matrix.txt`
- `learning/phases/phase-0-secure-lab/evidence/2026-06-30-nmap-dvwa.txt`

**Problems encountered:**
1. Docker seccomp profile blocks raw socket syscalls (`socket: Operation not permitted`) even with correct capabilities — fixed with `--security-opt seccomp=unconfined`
2. WebGoat and Juice Shop not yet deployed — deferred to next session

---

### Module 0.5 — Telemetry and Evidence Zone
**Status:** ✅ Complete (confirmed by Ali) — all 5 chunks done across Sessions 6-7
**Sessions:** Session 6 (Chunks 1-2), Session 7 (Chunks 3-5)

**Session plan:** `session-plans/session-04-telemetry-and-evidence.md`

**Concepts covered:**
- Container ephemerality: writable layer dies with `docker rm`, evidence is state and must live outside
- Bind mounts: `-v /host/path:/container/path` maps host directory into container, survives container destruction
- Bind mount security: pinhole principle — mount only the narrowest path needed
- Docker networking constraint: `--network none` prevents attaching other networks — start with NAT, attach internal after
- Bind mount ownership: Docker auto-creates host dir as root — must `chown` to analyst UID
- tcpdump mechanism: raw socket (`AF_PACKET/SOCK_RAW`), promiscuous mode, pcap format
- Capability sets: `--cap-add` adds to **permitted** set; non-root users need **effective** set — `docker exec -u 0` or `setcap`
- Packet capture analysis: ARP resolution, SYN scan (SYN→SYN-ACK→RST = never completes handshake), service version detection (`GET / HTTP/1.0`), NSE script probes (unique User-Agent, unusual TCP options)
- Evidence pipeline: container writes → bind mount → host dir → copied to `learning/.../evidence/`
- Attacker vs defender perspective: same event, two views — pcap (attacker's network traffic) vs access.log (target's server log)
- `docker cp`: copy files from/to containers without needing a shell inside
- Evidence naming convention: `YYYY-MM-DD-tool-target-description.ext` — date-first sorts chronologically
- Chain of custody principle: raw evidence must never be edited; flag sensitive data in companion notes
- Evidence flow: bind mount (working) → phase archive (permanent) → delete from container (cleanup)
- 7 evidence handling rules written to `building/labs/EVIDENCE-HANDLING.md`

**Key decisions:**
- Kali container rebuilt with bind mount evidence directory instead of creating a new one from scratch
- `--network lab-net-nat` on `docker run` instead of `--network none` (allows adding lab-net-internal after)
- tcpdump runs as root via `docker exec -u 0` rather than setting file capabilities on binary (simpler for lab)

**Artifacts:**
- `learning/phases/phase-0-secure-lab/notes/09-telemetry-and-evidence.md` — full learning note
- `learning/phases/phase-0-secure-lab/session-plans/session-04-telemetry-and-evidence.md` — session plan (status updated)
- `learning/phases/phase-0-secure-lab/session-plans/session-07-telemetry-evidence-part-2.md` — session plan part 2 (complete)
- `learning/phases/phase-0-secure-lab/evidence/2026-07-01-nmap-dvwa.pcap` — captured packet trace
- `learning/phases/phase-0-secure-lab/evidence/2026-07-01-dvwa-access-log.txt` — DVWA Apache access log (defender's view)
- `building/labs/EVIDENCE-HANDLING.md` — 7 rules for evidence handling

**Evidence files so far:**
- `learning/phases/phase-0-secure-lab/evidence/2026-06-29-session-1-docker-isolation.txt`
- `learning/phases/phase-0-secure-lab/evidence/2026-06-29-session-2-kali-build.txt`
- `learning/phases/phase-0-secure-lab/evidence/2026-06-30-connectivity-matrix.txt`
- `learning/phases/phase-0-secure-lab/evidence/2026-06-30-nmap-dvwa.txt`
- `learning/phases/phase-0-secure-lab/evidence/2026-07-01-nmap-dvwa.pcap`

**Problems encountered:**
1. `--network none` + `docker network connect` fails — Docker doesn't allow attaching networks to a container started with `--network none`. Fixed by starting with `--network lab-net-nat`.
2. Bind mount host directory owned by root — `analyst` cannot write. Fixed by `chown 1000:1000` via Alpine container.
3. `analyst` user cannot tcpdump despite `--cap-add=NET_RAW` — Docker adds to permitted set only, non-root needs effective. Fixed by `docker exec -u 0`.

---

### Module 0.6 — Documentation System
**Status:** ⏳ Planned (session plan written)
**Sessions:** Session 5 (planned)

**Session plan:** `session-plans/session-05-documentation-system.md`

**What will be covered:**
- Documentation directory structure (ADR, diagrams, threat models)
- Architecture diagram with trust boundaries
- ADR-001: Lab network isolation strategy
- Lab threat model (risks, mitigations, gaps)
- Phase 0 recall checklist

**What exists so far:**
- Session records: `SESSION-001.md` through `SESSION-005.md`
- Session plans for Phase 0: 6 plans (session-01 through session-06)
- Learning notes for Phase 0: 9 notes (00 through 08)
- `learning/phases/phase-0-secure-lab/PLAN.md`
- `learning/phases/phase-0-secure-lab/phase-0-progress-tracker.md` (this file)

**Missing (not yet created — planned for Sessions 5–6):**
- Architecture diagram
- Architecture Decision Record (ADR)
- Lab threat model
- Target inventory
- Standalone safety rules document
- Snapshot/restore plan
- Capstone artifacts

---

*Legend: ✅ = Complete & confirmed by Ali | ⏳ = Planned | 🔄 = In progress | ⏸️ = Postponed with reason*
