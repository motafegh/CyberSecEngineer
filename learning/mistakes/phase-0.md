# Phase 0 Mistakes — Secure Lab and Cyber Range

> Misconceptions encountered while building the local lab. See `Roadmap/MISTAKE-LOG-SYSTEM.md` for the entry format and recall protocol.

## Entry 001 — 2026-07-01
**Topic:** Capability sets: permitted vs effective
**What I thought:** `--cap-add=NET_RAW` gives the container's processes raw socket access.
**What's actually true:** `--cap-add` adds the capability to the **permitted** set. Root processes automatically promote permitted → effective. Non-root processes (like `analyst`) DO NOT — the capability is permitted (allowed to use) but not effective (actively available). The kernel checks the **effective** set on syscall, so `socket()` is denied.
**Fix:** `docker exec -u 0` (run as root), or `setcap cap_net_raw,cap_net_admin+eip /usr/sbin/tcpdump` on the binary.
**Source:** tcpdump failing as analyst user even with `--cap-add=NET_RAW --cap-add=NET_ADMIN`.
**Impact:** tcpdump, nmap, and any raw-socket tool must run as root or have file capabilities set.
