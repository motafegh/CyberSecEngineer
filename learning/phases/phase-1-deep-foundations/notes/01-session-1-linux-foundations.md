# Session 1 — Linux Foundations (Filesystem & Navigation)

> Date: June 25, 2026
> Reference: `Roadmap/PHASE-1-DEEP-FOUNDATIONS.md` Section 1.1

## Concepts Covered

### 1. Filesystem Hierarchy (FHS)
The standard Linux directory layout:

| Directory | Purpose | Security Note |
|---|---|---|
| `/` | Root | Everything starts here |
| `/etc` | System configuration | Passwords, service configs |
| `/var/log` | Log files | auth.log, syslog — incident response goldmine |
| `/home` | User data | SSH keys, personal files |
| `/tmp` | World-writable temp | Attackers drop payloads here |
| `/root` | Root's home | Private — only root can enter |

### 2. Permissions Model
Each file/directory has a permission string like `drwxrwxrwt`:

| Symbol | Position | Meaning |
|---|---|---|
| `d` `-` `l` | 1 | Type: directory, file, symlink |
| `r` | 2,5,8 | Read |
| `w` | 3,6,9 | Write |
| `x` | 4,7,10 | Execute (files) / Enter (directories) |
| `s` | 4 or 7 | SUID/SGID — runs as owner, NOT as you |
| `t` | 10 | Sticky bit — only owner can delete |

**Three groups:** Owner — Group — Others (in that order).

### 3. Groups
Users belong to groups. Group membership determines what you can access.

Command: `groups` — shows your groups.
File: `/etc/group` — lists all groups on the system.

### 4. Log Analysis (auth.log)
`/var/log/auth.log` records authentication events:
- SSH login attempts (Failed / Accepted)
- sudo usage (who, when, what command, which directory)
- cron job executions

## Commands Learned

```bash
ls -la /           # List all directories with permissions
ls -la /var/log    # List logs
find / -perm -4000 # Find SUID binaries (weekness)
grep "Failed password" /var/log/auth.log  # Check for intrusion attempts
grep "sudo" /var/log/auth.log             # Review admin actions
groups             # Your group memberships
cat /etc/group     # All system groups
```

## Security Connections

- **Permission misconfig** = vulnerabilities (world-writable files, SUID on wrong binaries)
- **Log monitoring** = detecting breaches (unexpected SSH logins, suspicious sudo commands)
- **`/tmp` abuse** = attackers write scripts there because it's writable by everyone
- **Group mismanagement** = privilege escalation (user in wrong group gets extra access)

## Commands to Practice

- `find / -perm -4000 2>/dev/null` — find SUID binaries
- `ss -tulnp` — list listening ports
- `ps aux` — list running processes
- `cat /etc/passwd` — list all users
