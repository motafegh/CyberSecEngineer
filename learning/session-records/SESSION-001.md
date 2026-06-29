# Session 001 — Kickoff & Roadmap Orientation

**Date:** 2026-06-25  
**Mentor:** Perplexity AI (Security Architecture Mentor)  
**Student:** Ali (ML Engineer & Solidity Dev)  
**Session Type:** Planning & Orientation  

> **Status:** Historical record. The roadmap structure referenced below was the v2 design (5 phases, 4-track Phase 3, fixed monthly timelines). It has since been replaced by the current quality-gated Phase 0–6 design — see `Roadmap/ROADMAP-INDEX.md`. Earlier plans in this document are kept for context only; do not treat them as current.

---

## Roadmap Reference (at time of session)

- 📌 **[ROADMAP-INDEX.md](../../Roadmap/ROADMAP-INDEX.md)** — Master index (replaced since; see current index)
- 🔧 **PHASE-0-LAB-SETUP.md** — Was the next active phase at session time; later replaced by `PHASE-0-SECURE-LAB.md`

**Current Phase at the time:** Phase 0 — Lab Setup (Weeks 1–2)

---

## Session Goals

- [x] Review the full roadmap structure and phases
- [x] Understand how existing skills (Solidity, ML, Python, LLMs) map to roadmap shortcuts
- [ ] Understand Phase 0 lab architecture and tooling decisions
- [ ] Set up the local security lab environment

---

## What We Will Learn & Build (planned in this session)

### Phase 0 — Lab Setup (Active)

| Task | Tool / Resource | Status |
|---|---|---|
| Hypervisor setup | VirtualBox or QEMU | 🔲 Pending |
| Attacker machine | Kali Linux VM | 🔲 Pending |
| Target VMs | Metasploitable 2, Ubuntu Server | 🔲 Pending |
| Windows lab | Windows Server 2019 + Windows 10 | 🔲 Pending |
| Network isolation | NAT + Host-Only adapter config | 🔲 Pending |
| Web app lab | Docker + DVWA / crAPI | 🔲 Pending |
| Note-taking system | Obsidian + local git repo | 🔲 Pending |

### Phase 1 — Foundations (Upcoming, Months 1–3)

| Module | Duration | Key Build / Outcome |
|---|---|---|
| Linux | ~3 weeks | Complete OverTheWire Bandit 34 levels |
| Networking | ~3 weeks | Capture & analyze live traffic in Wireshark |
| Cryptography | ~2 weeks | Crack hashes, complete CryptoPals Set 1 |
| Python for Security | ~2 weeks | Build socket scanner + scapy scripts |
| Threat Modeling | ~1 week | STRIDE model for a sample app |
| **Capstone** | End of Phase 1 | **SecAudit CLI** — Python recon tool (published to GitHub) |

### Phase 2 — Core Attack & Defense (Upcoming, Months 3–7)

| Module | Key Build / Outcome |
|---|---|
| Web App Security | Complete all PortSwigger SQLi, XSS, Access Control labs |
| API Security | Deploy & exploit crAPI locally |
| Network Pentesting | Root Metasploitable 2 via 3+ paths |
| Exploitation | Metasploit + privesc Linux paths |
| Binary Exploitation | 3 CTF write-ups with pwntools |
| Reverse Engineering | 3 crackmes reversed with Ghidra |
| Secure Code Review | Manual audit report on an open-source app |
| Blue Team / SIEM | 5 custom Wazuh detection rules |
| **Capstone** | Full pentest report on a VulnHub machine |

### Phase 3 — Specializations (Months 7–14)

Four parallel tracks run on a weekly schedule:

| Day | Track | Primary Goal |
|---|---|---|
| Monday | **Track A — Web3 / Smart Contracts** | Competitive audit + audit workbench extensions |
| Tuesday | **Track B — AI/ML Security** | Adversarial attack lab + LLM red team suite |
| Wednesday | **Track C — Cloud Security** | Cloud misconfiguration lab + assessment report |
| Thursday | **Track D — Windows & Active Directory** | Zero-to-DA AD attack chain + hardening report |
| Friday | CTF / competitive audits / write-ups | — |

> Ali's Solidity background → fast-track into Track A  
> Ali's ML/DL background → fast-track into Track B  

### Phase 4 — Portfolio & Job Hunt (Months 14–18)

- 12+ months of consistent GitHub commits
- 6 pinned portfolio repositories
- 2+ technical blog posts (no KYC, pseudonymous-friendly)
- Applications to target employers

---

## Constraints & Principles

- ✅ Free, open-source, and self-hosted tools only
- ✅ No KYC-gated platforms
- ✅ No paid subscriptions or cloud free trials
- ✅ Local-first lab (VirtualBox/QEMU, Docker)
- ✅ All builds published to GitHub

---

## Tools Referenced This Session

See **[REFERENCE-TOOLS.md](../../Roadmap/REFERENCE-TOOLS.md)** for the full categorized list (current version).

---

## Next Steps

1. Open **[PHASE-0-SECURE-LAB.md](../../Roadmap/PHASE-0-SECURE-LAB.md)** (current file) and walk through the lab architecture
2. Install VirtualBox or QEMU on host machine
3. Download Kali Linux ISO (official: https://www.kali.org/get-kali/)
4. Configure NAT + Host-Only network adapters
5. Snapshot baseline VMs before any exploitation work

---

*Session records track learning progress, session plans, and build outcomes across the full roadmap journey.*
