# Phase 1 — Session Plan

> Reference: `Roadmap/PHASE-1-FOUNDATIONS.md`
> Timeline: ~10 weeks total
> Prerequisites: Phase 0 (minimal lab - Docker running, VirtualBox installing)

## Structure

Each session follows this pattern:
1. **Concept** — What we're learning and why it matters for security
2. **Hands-on** — You do it in your terminal
3. **Write-up** — Note it down in your cheatsheet
4. **Quiz** — Verify you understand before moving on

---

## Session 1 — Linux Foundations (Filesystem & Navigation)

**Roadmap ref:** Section 1.1 — Linux

| Topic | Time | Security Relevance |
|---|---|---|
| Filesystem Hierarchy (FHS) | 20min | Know where attackers hide things |
| `pwd`, `ls`, `cd`, `cat`, `less` | 15min | Basic navigation |
| File types & permissions (`rwx`) | 25min | SUID/SGID = privesc vectors |
| Hidden files & directories | 10min | Malware persistence spots |
| **Mini-task:** Explore `/etc`, `/var/log`, `/tmp` | 15min | See real system layout |

**Exit:** You can explain where configs, logs, and user data live.

---

## Session 2 — Linux Permissions Deep Dive

**Roadmap ref:** Section 1.1 — Linux

| Topic | Time | Security Relevance |
|---|---|---|
| `chmod`, `chown`, `umask` | 20min | Permission misconfig = vuln |
| SUID, SGID, Sticky bit | 25min | Classic privesc (GTFOBins) |
| User/group management | 15min | Lateral movement paths |
| **Mini-task:** Find all SUID binaries on your system | 15min | `find / -perm -4000` |

**Exit:** You can audit a system's permission weaknesses.

---

## Session 3 — Text Processing & Log Analysis

**Roadmap ref:** Section 1.1 — Linux

| Topic | Time | Security Relevance |
|---|---|---|
| `grep`, `awk`, `sed`, `cut` | 30min | Parse logs, extract IPs |
| `sort`, `uniq`, `wc` | 10min | Analyze patterns |
| `find` with `-exec` | 15min | Automated file hunting |
| **Mini-task:** Parse `/var/log/auth.log` for failed SSH attempts | 20min | Real incident response skill |

**Exit:** You can extract attackers' IPs from logs manually.

---

## Session 4 — Processes, Services & Networking

**Roadmap ref:** Section 1.1 — Linux

| Topic | Time | Security Relevance |
|---|---|---|
| `ps`, `top`, `kill`, signals | 15min | Spot malicious processes |
| `systemctl`, `service` | 15min | Persistence via services |
| `ss`, `netstat`, `lsof` | 20min | Recon — what's listening? |
| Cron jobs (`crontab`, `/etc/cron*`) | 20min | Persistence & task scheduling |
| **Mini-task:** List all listening ports + their processes | 15min | `ss -tulnp` |

**Exit:** You can audit running services and scheduled tasks.

---

## Session 5 — Bash Scripting for Security

**Roadmap ref:** Section 1.1 — Linux

| Topic | Time | Security Relevance |
|---|---|---|
| Variables, conditionals, loops | 20min | Automate everything |
| Scripting with `find`, `grep`, `awk` | 20min | Build audit tools |
| Exit codes & error handling | 10min | Reliable automation |
| **Mini-task:** Write the System Auditor script from roadmap | 45min | **First portfolio piece** |

**Exit:** System Auditor script working — committed to notes.

---

## Sessions 6-7 — OverTheWire Bandit Challenges

**Roadmap ref:** Section 1.1 — Practice

We tackle Bandit levels 0-34, ~5 levels per session. Each level teaches a specific Linux skill used in real attacks.

| Session | Levels | Skill Focus |
|---|---|---|
| 6 | 0-10 | SSH, file reading, `find`, `grep`, base64 |
| 7 | 11-20 | Compression, tr, passwords in files |
| 8 | 21-34 | Cron jobs, SUID, scripting, final challenges |

---

## Sessions 9-11 — Networking (Section 1.2)

Covered when Kali + Metasploitable are ready for packet captures.

---

## Sessions 12-13 — Cryptography (Section 1.3)

Python-based hash cracking, CryptoPals challenges all from WSL2.

---

## Sessions 14-16 — Python for Security (Section 1.4)

Build the Phase 1 capstone: SecAudit CLI. Network discovery, web audit, hash cracker.

---

## Session 17 — Threat Modeling (Section 1.5)

STRIDE, PASTA, DREAD on a sample app. One session theory, one session practice.

---

## Session 18 — Capstone Integration

Combine all mini-projects into the SecAudit CLI. Final polish, README, GitHub publish.

---

## How Sessions Work

1. I explain the concept + its security relevance
2. You type commands in your terminal
3. You write notes into the relevant cheatsheet
4. I quiz you briefly before moving to next topic
5. You decide when to stop or continue

> Adjustable pace — if something clicks fast, we accelerate.
> If something doesn't click, we stay until it does.
