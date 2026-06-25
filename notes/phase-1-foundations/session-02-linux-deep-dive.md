# Session 2 — Linux: SUID, Processes & Services

> **Roadmap ref:** `PHASE-1-FOUNDATIONS.md` → Section 1.1
> **Topics:** SUID/SGID, processes, systemd, cron

## What We'll Learn

| Topic | Status | Notes |
|---|---|---|
| SUID/SGID binaries | ✅ Done | Notes: `02-suid-sgid-deep-dive.md` |
| `ps aux` breakdown | ✅ Done | Understanding every column |
| Process analysis (PID 1, cron, redis) | ✅ Done | Deep-dive into real running processes |
| Zombie processes | ✅ Done | What they are, why they exist |
| `ss -tulnp` | ✅ Done | Socket statistics command |
| Cron & persistence | ✅ Done | Where attackers plant reverse shells |
| `systemctl`, services | ⏳ | Next topic |
| SSH key auth | ⏳ | Next topic |

## Commands Mastered

```bash
find / -perm -4000 -type f 2>/dev/null   # find SUID
ps aux                                     # all processes
ss -tulnp                                  # listening ports
ss -lxp                                    # Unix sockets
ss -tlnp | grep PORT                       # Filter by port
crontab -l                                 # your scheduled tasks
cat /etc/crontab                           # system-wide cron
redis-cli CLIENT LIST                      # who's connected to Redis
redis-cli INFO server                      # Redis config
ps -o pid,ppid,stat,cmd -p PID            # Process details by PID
```

## Still to Do in Session 2
- [ ] `systemctl` — start/stop services, check what's running
- [ ] SSH key auth — key-based auth, authorized_keys, security
- [ ] Write-up: `03-processes-complete.md` ✅
