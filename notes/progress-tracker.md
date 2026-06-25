# Phase 1 — Progress Tracker

> Master status of everything in `Roadmap/PHASE-1-FOUNDATIONS.md`
> ✅ = Done | 🔄 = In Progress | ⏳ = Planned | ⏸️ = Postponed (with note)

---

## 1.1 Linux (~3 weeks)

| Topic | Status | Notes |
|---|---|---|
| Filesystem Hierarchy (FHS) | ✅ | Session 1 done |
| Permissions (rwx, SUID, SGID, sticky) | ✅ | Session 1 done |
| Users & Groups | ✅ | Session 1 done |
| Log Reading (auth.log) | ✅ | Session 1 done |
| SUID/SGID binaries (find & exploit) | ✅ | Session 2 — `02-suid-sgid-deep-dive.md` |
| Processes & Signals (ps, top, kill) | ✅ | Session 2 — `03-processes-complete.md` |
| Cron & Scheduling (crontab) | ✅ | Session 2 — `03-processes-complete.md` |
| Services & systemd (systemctl) | ⏳ | Session 2 (remaining) |
| SSH Key Auth | ⏳ | Session 2 (remaining) |
| Bash Scripting (vars, loops, conditions) | ⏳ | Session 3 |
| **Bandit Levels 0-34** | ⏳ | Session 4 |
| **System Auditor Script** | ⏳ | Build in Session 3 |

---

## 1.2 Networking (~3 weeks)

| Topic | Status | Notes |
|---|---|---|
| OSI 7 Layers | ⏸️ | POSTPONED — needs Kali VM for packet captures |
| TCP/IP Stack | ⏸️ | POSTPONED |
| Wireshark Packet Analysis | ⏸️ | POSTPONED — needs Kali VM |
| **Network Discovery Tool** | ⏸️ | POSTPONED — will build as Python project later |

---

## 1.3 Cryptography (~2 weeks)

| Topic | Status | Notes |
|---|---|---|
| Symmetric/Asymmetric Encryption | ⏸️ | POSTPONED — background knowledge already strong |
| Hashing vs Encryption vs Encoding | ⏸️ | POSTPONED |
| Password Cracking (hashcat/john) | ⏸️ | POSTPONED — revisit when we have Kali |
| **CryptoPals Challenges** | ⏸️ | POSTPONED |

---

## 1.4 Python for Security (~2 weeks)

| Topic | Status | Notes |
|---|---|---|
| Socket Programming, scapy, requests | ⏸️ | POSTPONED — Python skill is already strong, skip teaching |
| **SecAudit CLI (Phase 1 Capstone)** | ⏳ | Session 6 — build directly without teaching |

---

## 1.5 Threat Modeling (~1 week)

| Topic | Status | Notes |
|---|---|---|
| STRIDE Framework | ⏳ | Session 5 |
| DREAD Scoring | ⏳ | Session 5 |
| Attack Trees | ⏳ | Session 5 |
| Data Flow Diagrams | ⏳ | Session 5 |
| **Threat Model Document** | ⏳ | Session 5 deliverable |

---

## Phase 1 Exit Criteria

| Criterion | Status |
|---|---|
| OverTheWire Bandit all 34 levels | ⏳ |
| Explain OSI 7 layers with attack examples | ⏸️ |
| Extract credentials from FTP/HTTP in Wireshark | ⏸️ |
| Explain MD5 danger with rainbow tables | ⏸️ |
| STRIDE threat model for a simple app | ⏳ |
| SecAudit CLI on GitHub | ⏳ |
| System Auditor script | ⏳ |
| Network discovery tool | ⏸️ |
| Password audit tool | ⏸️ |
| All notes committed | ✅ |

---

## Legend

| Symbol | Meaning |
|---|---|
| ✅ | Done — notes written, concept understood |
| 🔄 | In progress — currently working on this |
| ⏳ | Planned — scheduled for an upcoming session |
| ⏸️ | Postponed — intentionally skipped for now, will return later |
