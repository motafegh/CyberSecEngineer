# Session 006

> **Date:** 2026-07-01
> **Module:** Phase 0, Module 0.5 (Telemetry and Evidence Zone) — Chunks 1-3
> **Status:** Partially complete (Chunks 3-5 postponed)

## What Was Done

1. **Chunk 1 — The Ephemerality Problem** — Explained why container writable layers are temporary: `docker rm` destroys the writable layer entirely. Evidence must be stored outside the container. Walked through which actions preserve vs destroy evidence (`docker stop` ✅, `docker rm` ❌, `docker run --rm` ❌).

2. **Chunk 2 — Bind Mounts** — Recreated Kali container with `-v /home/motafeq/.../building/labs/evidence:/home/analyst/evidence` (bind mount). Problems encountered: (a) `--network none` blocks attaching other networks — Docker restriction, had to start with `--network lab-net-nat`. (b) Evidence directory auto-created as root — fixed with `chown 1000:1000` via temporary Alpine container. Verified: file created in container → visible on host; container destroyed → file survives; new container with same mount → file accessible.

3. **Chunk 3 — tcpdump Packet Capture** — Problems encountered: `analyst` user cannot run tcpdump even with `--cap-add=NET_RAW` because Docker only adds capabilities to the **permitted** set, non-root users need them in **effective** set. Fixed by running as root via `docker exec -u 0`. Captured nmap SYN scan + service detection + NSE scripts against DVWA (218 KB pcap). Walked through all 4 packet phases in hex dump: ARP (L2 resolution), SYN scan (999 closed ports RST, port 80 open SYN-ACK then nmap sends RST — handshake never completes), HTTP service detection (`GET / HTTP/1.0` → `Apache/2.4.25 (Debian)` + `PHPSESSID`), NSE script probes (window size 1 for OS fingerprinting, `/robots.txt` probe).

4. **Corrected belief logged** — Capability permitted vs effective distinction (logged to `mistakes/phase-0.md`).

## Outcomes

- Evidence survival proven: bind mount survives `docker rm` + container recreate
- First pcap captured and analyzed at packet level
- Kali container now has bind mount + dual networks (lab-net-nat + lab-net-internal)

## Deferred / Not Done

- DVWA Apache access.log extraction (Chunk 3 in plan)
- Evidence naming convention (Chunk 4 in plan)
- Evidence handling rules document (Chunk 5 in plan)
- Chunks 3-5 postponed because Chunk 3 (tcpdump) required extensive mechanism walkthrough

## Next Steps

- Extract DVWA Apache logs (identify nmap scan signatures)
- Write evidence naming convention
- Write evidence handling rules document (`building/labs/EVIDENCE-HANDLING.md`)
- Deploy WebGoat and Juice Shop
- Architecture diagram + ADR + threat model (Module 0.6)
