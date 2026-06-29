# Session 4 — OverTheWire Bandit Challenges

> **Roadmap ref:** `PHASE-1-DEEP-FOUNDATIONS.md` → Section 1.1 (Practice)
> **Topics:** Apply Linux skills in a CTF environment

## What We'll Learn

Bandit is a wargame with 34 levels. Each level teaches a specific Linux skill by making you use it to find a password for the next level.

| Levels | Skills |
|---|---|
| 0-10 | SSH, `ls`, `cat`, `file`, `find`, `grep`, `strings`, `base64`, `tr` |
| 11-20 | Compression, `xxd`, `sort`, `uniq`, `netcat`, `openssl`, `diff` |
| 21-34 | Cron jobs, SUID, `sed`, `awk`, privesc concepts |

## How It Works

```bash
ssh bandit0@bandit.labs.overthewire.org -p 2220
# password: bandit0
# find the password for bandit1, then: ssh bandit1@...
```

## Per-Session Plan

| Day | Levels | Target |
|---|---|---|
| Day 1 | 0-10 | Core file operations |
| Day 2 | 11-20 | Data transformation |
| Day 3 | 21-34 | Automation & privesc basics |

## Write-Up
- Notes in `learning/ctf-writeups/pwn-college/` or `learning/cheatsheets/`
- Flag every level you complete

## Done When
- All 34 Bandit levels complete
- You can navigate, search, and extract data in any Linux system
