# Session 2 — Linux: SUID, Processes & Services

> **Roadmap ref:** `PHASE-1-FOUNDATIONS.md` → Section 1.1
> **Topics:** SUID/SGID, processes, systemd, cron

## What We'll Learn

| Topic | Security Relevance |
|---|---|
| SUID/SGID binaries | Classic privilege escalation — find them, understand them |
| `ps`, `top`, `kill` | Spot malicious processes on a compromised machine |
| `systemctl`, services | See what's running, start/stop, persistence |
| `cron` & scheduling | Attackers use cron for persistence |
| SSH key auth | How remote access works, key management |

## Commands to Master

```bash
find / -perm -4000 -type f 2>/dev/null   # find SUID
ps aux                                     # all processes
ss -tulnp                                  # listening ports
systemctl list-units --type=service        # all services
crontab -l                                 # scheduled tasks
```

## Mini-Task
Run `find / -perm -4000` on your WSL2. Identify what each binary does.

## Write-Up
- Add findings to `tools/cheatsheets/linux-basics.md`
- Document each SUID binary you found

## Done When
- You can explain what SUID means and why it's dangerous
- You can list all running services and open ports
- You can explain what cron persistence looks like
