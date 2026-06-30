# Session 3 — Linux: Services, SSH, and Environment Variables

> **Roadmap ref:** `PHASE-1-DEEP-FOUNDATIONS.md` → Module 1.1 (Linux Security)
> **Date:** 2026-06-29
> **Status:** [~] In Progress

---

## Session Goals

- [ ] Understand systemd services, unit files, and security implications
- [ ] Audit SSH configuration for common misconfigurations
- [ ] Understand environment variables and credential leakage risks
- [ ] Inspect running services for privilege escalation vectors

---

## Chunk 1: systemd Services and Unit Files

### What We'll Learn

| Concept | Security Relevance |
|---|---|
| systemd basics (systemctl, unit files) | Misconfigured services = privilege escalation |
| Service states (enabled, disabled, running, failed) | Attackers enable services for persistence |
| Unit file structure (ExecStart, User, WorkingDirectory) | Writable paths, wrong users = RCE |
| Service dependencies (After, Requires) | Dependency confusion attacks |

### Key Commands

```bash
# List all running services
systemctl list-units --type=service --state=running

# Check if a service is enabled (starts on boot)
systemctl is-enabled nginx

# View a service's unit file
systemctl cat nginx.service

# Check service status and recent logs
systemctl status nginx

# View unit file location on disk
systemctl show nginx -p FragmentPath
```

### Unit File Structure

```ini
[Unit]
Description=Nginx HTTP Server
After=network.target
Requires=network.target

[Service]
Type=simple
User=www-data
Group=www-data
WorkingDirectory=/var/www/html
ExecStart=/usr/sbin/nginx -g 'daemon off;'
ExecReload=/bin/kill -s HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

### Security Audit Points

1. **Who runs the service?** (`User=` field)
   - If root → full system access if compromised
   - Check: `systemctl show <service> -p User`

2. **Is the working directory writable?** 
   - Attacker can drop malicious scripts
   - Check: `ls -la $(systemctl show <service> -p WorkingDirectory | cut -d= -f2)`

3. **Is the binary path writable?**
   - Attacker replaces the binary
   - Check: `ls -la $(which <binary>)`

4. **Can non-root users start/stop the service?**
   - `systemctl stop <service>` — if no polkit error, anyone can stop it
   - PolicyKit misconfigs are common privesc vectors

5. **Are there ExecStartPre/ExecStartPost scripts?**
   - These run as the service user — check for injection

### Hands-on Exercise

```bash
# 1. List all running services
systemctl list-units --type=service --state=running

# 2. Pick 3 services and check their unit files
for svc in sshd nginx docker; do
    echo "=== $svc ==="
    systemctl show $svc -p User,WorkingDirectory,ExecStart,FragmentPath 2>/dev/null
done

# 3. Check if any service runs as root (empty User = root)
systemctl list-units --type=service --state=running --no-pager | while read line; do
    svc=$(echo "$line" | awk '{print $1}')
    user=$(systemctl show "$svc" -p User 2>/dev/null | cut -d= -f2)
    [ -z "$user" ] && echo "ROOT: $svc"
done
```

---

## Chunk 2: SSH Configuration Security

### What We'll Learn

| Concept | Security Relevance |
|---|---|
| SSH key authentication | Password brute-force is the #1 attack vector |
| authorized_keys format and permissions | Wrong perms = key ignored or leaked |
| sshd_config options | Misconfigs = unauthorized access |
| SSH tunneling (LocalForward, ProxyJump) | Attackers use SSH for pivoting |

### Key Files

| File | Purpose |
|---|---|
| `/etc/ssh/sshd_config` | Server configuration |
| `~/.ssh/authorized_keys` | Public keys allowed to log in |
| `~/.ssh/id_rsa` | Private key (NEVER share) |
| `~/.ssh/id_rsa.pub` | Public key (safe to share) |
| `/etc/ssh/ssh_host_*_key` | Host keys |

### Critical sshd_config Options

```bash
# /etc/ssh/sshd_config

# Disable password auth (keys only)
PasswordAuthentication no

# Disable root login (require sudo)
PermitRootLogin no

# Restrict to specific users/groups
AllowUsers ali admin
AllowGroups sshusers

# Use only strong algorithms
KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group16-sha512
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com

# Disable empty passwords
PermitEmptyPasswords no

# Set login grace period (seconds to authenticate)
LoginGraceTime 60

# Max auth tries per connection
MaxAuthTries 3

# Disable X11 forwarding (unless needed)
X11Forwarding no
```

### authorized_keys Security

```bash
# Check permissions
ls -la ~/.ssh/
# -rw------- 1 user user  570 Jun 25 10:00 authorized_keys
# -rw------- 1 user user 1675 Jun 25 10:00 id_rsa
# -rw-r--r-- 1 user user  398 Jun 25 10:00 id_rsa.pub

# Fix permissions if wrong
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub

# authorized_keys format
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... user@host
# command="...",no-pty,no-port-forwarding ssh-ed25519 AAAA...
# ↑ Restricts what this key can do
```

### Hands-on Exercise

```bash
# 1. Check current SSH config
sudo grep -E "^(PasswordAuthentication|PermitRootLogin|AllowUsers|MaxAuthTries)" /etc/ssh/sshd_config

# 2. Check who has keys
sudo cat /root/.ssh/authorized_keys
cat ~/.ssh/authorized_keys

# 3. Check SSH logins
sudo journalctl -u sshd --since "1 hour ago" | grep "Accepted"
sudo journalctl -u sshd --since "1 hour ago" | grep "Failed"

# 4. Check for weak key types
sudo ssh-keygen -l -f /etc/ssh/ssh_host_rsa_key
# Should be >= 4096 bits
```

---

## Chunk 3: Environment Variables and Credential Leakage

### What We'll Learn

| Concept | Security Relevance |
|---|---|
| Environment variables | Secrets leaked in process listings |
| PATH manipulation | Attacker hijacks commands |
| /etc/environment vs .bashrc vs .profile | Global vs per-user vars |
| Export vs non-export | Non-exported = subprocess only |
| /proc/PID/environ | Read other processes' env vars |

### Key Files

| File | Scope | When Loaded |
|---|---|---|
| `/etc/environment` | System-wide | Every login |
| `/etc/profile` | System-wide | Login shells |
| `/etc/profile.d/*.sh` | System-wide | Login shells |
| `~/.bashrc` | User | Interactive non-login shells |
| `~/.profile` or `~/.bash_profile` | User | Login shells |
| `~/.env` | User/project | Application-specific |

### Security Risks

#### 1. Secrets in Environment Variables

```bash
# BAD: Secrets in shell history
export DATABASE_PASSWORD="supersecret"  # Saved in .bash_history

# BAD: Secrets visible in /proc
cat /proc/$$/environ | tr '\0' '\n' | grep PASSWORD
# Any user can read their own process env

# BETTER: Use a secrets manager or .env files with restricted perms
chmod 600 .env
```

#### 2. PATH Hijacking

```bash
# Check your PATH
echo $PATH
# /usr/local/bin:/usr/bin:/bin

# Attacker creates malicious binary in /tmp
echo '#!/bin/bash' > /tmp/ls
echo 'cat /etc/shadow >> /tmp/stolen' >> /tmp/ls
chmod +x /tmp/ls

# If /tmp is before /usr/bin in PATH...
export PATH="/tmp:$PATH"
ls  # Runs the malicious /tmp/ls instead of /usr/bin/ls

# Defense: Never prepend user-writable dirs to PATH
# Check for PATH issues:
echo $PATH | tr ':' '\n' | while read dir; do
    [ -w "$dir" ] && echo "WRITABLE: $dir"
done
```

#### 3. Leaked Secrets via Environment

```bash
# Docker containers inherit env vars
docker run alpine env  # Shows host env vars if passed through

# Systemd services can expose env
systemctl show <service> -p Environment

# Check for secrets in process listings
ps eww -p $PID  # Shows full environment of a process
```

### Hands-on Exercise

```bash
# 1. View your current environment (look for secrets)
env | grep -iE "(password|secret|token|key|api)" | head -5

# 2. Check if /tmp is in PATH (it shouldn't be)
echo $PATH | grep -q "/tmp" && echo "WARNING: /tmp in PATH" || echo "PATH OK"

# 3. Check which directories in PATH are world-writable
echo $PATH | tr ':' '\n' | while read dir; do
    [ -w "$dir" ] && echo "WRITABLE: $dir"
done

# 4. Check environment of running processes (need root for others)
sudo cat /proc/1/environ 2>/dev/null | tr '\0' '\n' | head -10

# 5. Check systemd service environment
systemctl show sshd -p Environment
```

---

## Quiz — Chunk 1 (systemd)

1. You find a service running as root with `ExecStart=/usr/local/bin/backup.sh`. The working directory is `/var/backups` which is world-writable. What's the risk and how do you fix it?

2. An attacker wants to maintain persistence. They can't create new services (no root), but they notice that `systemctl enable custom.timer` works for their user. Why is this dangerous?

3. What's the difference between `Type=simple` and `Type=forking` in a unit file, and why does it matter for security monitoring?

---

## Quiz — Chunk 2 (SSH)

4. You see `PasswordAuthentication yes` and `PermitRootLogin prohibit-password` in sshd_config. What attack is still possible against root?

5. You find a public key in `~/.ssh/authorized_keys` with `command="/bin/bash"` prepended. What does this key do when used to connect?

---

## Quiz — Chunk 3 (Environment)

6. An application reads `DATABASE_URL` from an environment variable. The process runs as `www-data`. Another user on the system can read `/proc/$(pgrep -u www-data app)/environ`. Is this a vulnerability? Why or why not?

7. You run `which python3` and it resolves to `/usr/local/bin/python3`. How would you verify this isn't a PATH hijack?

---

## What We Covered

| Chunk | Topic | Key Takeaway |
|---|---|---|
| 1 | systemd services | Audit unit files for wrong users, writable paths, weak permissions |
| 2 | SSH configuration | Keys-only, no root login, strong algorithms |
| 3 | Environment variables | Never store secrets in env, check PATH for writable dirs |

---

## Next Session

**Session 4 — Shell Scripting → System Auditor**: Build a bash script that automates SUID/SGID audit, world-writable detection, listening ports, and produces a structured report.
