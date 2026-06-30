# Session 1 — Linux Foundations: FHS, Users, Permissions, Hidden Files, Logs

> **Roadmap ref:** `PHASE-1-DEEP-FOUNDATIONS.md` → Module 1.1 (Linux and OS Security)
> **Date:** 2026-06-29
> **Status:** [ ] Planned

---

## Session Goals

- [ ] Navigate and map the Linux filesystem hierarchy (FHS)
- [ ] Understand users, groups, UID/GID, and their security relevance
- [ ] Master file permissions (rwx, octal notation)
- [ ] Understand hidden files and stealth mechanisms
- [ ] Read and interpret system logs for security events

---

## Chunk 1: Filesystem Hierarchy Standard (FHS)

### What We'll Learn

| Concept | Security Relevance |
|---|---|
| / (root), /etc, /var, /tmp, /home, /proc | Where attackers hide, where configs live, where logs go |
| /etc/passwd vs /etc/shadow | Password storage evolution, why shadow exists |
| /tmp world-writable nature | Temp file race conditions, symlink attacks |
| /proc filesystem | Process information leakage, kernel parameters |

### Key Directories

| Path | Purpose | Security Note |
|---|---|---|
| `/` | Root of the filesystem tree | Only root should write here |
| `/etc` | System configuration files | WRONG perms = system compromise |
| `/var` | Variable data (logs, spools) | Logs live here — critical for forensics |
| `/tmp` | Temporary files, world-writable | Anyone can write here — race conditions |
| `/home` | User home directories | User data, SSH keys, configs |
| `/root` | Root user's home | Should be readable only by root |
| `/proc` | Virtual filesystem for processes | /proc/PID/environ leaks env vars |
| `/usr` | User binaries and libraries | Most system binaries live here |

### Key Commands

```bash
# Navigate and explore
ls /
ls -la /etc
ls -la /var/log

# See where a command lives
which ls
whereis nginx

# Check filesystem usage
df -h
du -sh /var/log

# Find world-writable directories
find / -type d -perm -o+w 2>/dev/null
```

### Hands-on Exercise

```bash
# 1. Map your filesystem
ls -la / | head -20

# 2. Check /tmp permissions
ls -la / | grep tmp

# 3. Look at /etc/passwd (USERS, not passwords)
head -5 /etc/passwd
# Format: username:password_placeholder:UID:GID:comment:home:shell

# 4. Look at /etc/shadow (ACTUAL passwords — needs root)
sudo head -5 /etc/shadow
# Format: username:hashed_password:last_change:min:max:warn:inactive:expire

# 5. Explore /proc
ls /proc/1/   # PID 1 is always init/systemd
cat /proc/1/cmdline | tr '\0' ' '
```

---

## Chunk 2: Users, Groups, UID/GID

### What We'll Learn

| Concept | Security Relevance |
|---|---|
| UID 0 = root | Unlimited system access |
| UID 1-999 = system users | Service accounts, no login shell |
| UID 1000+ = regular users | Normal user accounts |
| Primary vs supplementary groups | Group-based access control |
| /etc/group | Defines groups |

### Key Files

| File | Purpose |
|---|---|
| `/etc/passwd` | User accounts (world-readable) |
| `/etc/shadow` | Password hashes (root only) |
| `/etc/group` | Group definitions |
| `/etc/login.defs` | Password aging, UID ranges |

### Key Commands

```bash
# Show all users
cat /etc/passwd

# Current user info
id
whoami
who
w

# User creation (root)
sudo useradd -m -s /bin/bash alice
sudo passwd alice

# Group operations
groups               # Show my groups
groupadd devteam      # Create group (root)
usermod -aG devteam alice  # Add user to group (root)

# Who is online now
last
lastlog
```

### Security Audit Points

1. **UID 0 check** — any user with UID 0 is effectively root
   ```bash
   awk -F: '$3 == 0 { print $1 " has UID 0" }' /etc/passwd
   ```

2. **Users without passwords** — login without auth
   ```bash
   sudo awk -F: '$2 == "" || $2 == "!" { print $1 " has no password set" }' /etc/shadow
   ```

3. **Users with login shells** — who can actually log in
   ```bash
   grep -v "nologin\|/bin/false" /etc/passwd
   ```

4. **Empty password field** in /etc/shadow means no password required
   ```bash
   sudo awk -F: 'length($2) < 2 { print $1 ": NO PASSWORD or locked" }' /etc/shadow
   ```

### Hands-on Exercise

```bash
# 1. Identify your current user
id
echo "UID: $(id -u), GID: $(id -g)"

# 2. List all users on the system
cut -d: -f1,3,7 /etc/passwd | head -20

# 3. Find all users with UID 0 (should only be root)
awk -F: '$3 == 0 { print $1 }' /etc/passwd

# 4. Find users who can login (have a shell)
grep -E "/bin/(bash|sh|zsh)" /etc/passwd

# 5. Check your groups
groups
```

---

## Chunk 3: File Permissions (rwx, Octal Notation)

### What We'll Learn

| Concept | Security Relevance |
|---|---|
| rwx permissions | Read, write, execute — who can do what |
| Owner / Group / Other | Three permission sets |
| Octal notation (755, 644, 777) | Compact numeric representation |
| umask | Default permissions for new files |
| chmod, chown, chgrp | Change permissions and ownership |

### The Permission Triplet

```bash
-rwxr-xr-x  1 root root  12345 Jun 25 10:00 /bin/ls
^ ^^^ ^^^ ^^^
| |   |   +--- Other permissions (r-x)
| |   +------- Group permissions (r-x)
| +----------- Owner permissions (rwx)
+------------- File type (- = file, d = directory, l = symlink)
```

### Octal Reference

| Octal | Binary | Perms | Meaning |
|---|---|---|---|
| 0 | 000 | --- | No permissions |
| 1 | 001 | --x | Execute only |
| 2 | 010 | -w- | Write only |
| 3 | 011 | -wx | Write + Execute |
| 4 | 100 | r-- | Read only |
| 5 | 101 | r-x | Read + Execute (common for binaries) |
| 6 | 110 | rw- | Read + Write (common for files) |
| 7 | 111 | rwx | All (dangerous for files, needed for dirs) |

### Key Commands

```bash
# View permissions
ls -la filename

# Change permissions (octal)
chmod 755 script.sh     # rwxr-xr-x
chmod 644 notes.txt     # rw-r--r--
chmod 600 private.key   # rw------- (SSH private key)
chmod 700 private_dir   # rwx------ (SSH directory)

# Change permissions (symbolic)
chmod u+x script.sh     # Add execute for owner
chmod g-w file          # Remove write for group
chmod o+r file          # Add read for others
chmod a+x script.sh     # Add execute for all

# Change ownership
chown alice:devteam file    # Change owner:group
chown -R alice:devteam dir  # Recursive

# Default permissions
umask                    # Show current umask
umask 022                # Set umask (files: 644, dirs: 755)
```

### Directory Permissions — Different from Files!

| Permission | On a File | On a Directory |
|---|---|---|
| r | Read file content | List directory contents (ls) |
| w | Modify file | Create/delete files inside |
| x | Execute file | Enter directory (cd), access files inside |

**CRITICAL:** A directory without execute permission cannot be entered, even with read permission.

### Security Audit Points

1. **Files with 777 permissions** — anyone can modify
   ```bash
   find / -perm -0777 -type f 2>/dev/null
   ```

2. **World-writable directories** — anyone can drop files
   ```bash
   find / -type d -perm -o+w 2>/dev/null | head -20
   ```

3. **SSH keys with wrong permissions** — too permissive = ignored
   ```bash
   ls -la ~/.ssh/
   # authorized_keys must be 600
   # id_rsa must be 600
   # .ssh dir must be 700
   ```

### Hands-on Exercise

```bash
# 1. Check permissions of your home directory
ls -la ~/

# 2. Create a test file and experiment
touch /tmp/test_perms
ls -la /tmp/test_perms
chmod 777 /tmp/test_perms
ls -la /tmp/test_perms

# 3. Try directory permissions
mkdir /tmp/testdir
chmod 000 /tmp/testdir
ls /tmp/testdir    # Should fail (no r)
cd /tmp/testdir    # Should fail (no x)
chmod 755 /tmp/testdir  # Fix it

# 4. Check your umask
umask -S           # Symbolic format
echo "Files created with: $(umask) mask"

# 5. Find any 777 files (security scan)
find / -perm -0777 -type f 2>/dev/null
```

---

## Chunk 4: Hidden Files and Stealth

### What We'll Learn

| Concept | Security Relevance |
|---|---|
| Dot files (.filename) | Standard hiding convention — common for configs |
| .ssh directory | SSH keys, authorized_keys — critical secrets |
| .bashrc, .bash_history | Commands executed, history mining |
| Hidden processes and filesystem tricks | Malware hiding techniques |
| ls -a to reveal hidden files | Detection of stealth |

### Common Hidden Files

| File/Dir | Purpose | Security Note |
|---|---|---|
| `~/.ssh/` | SSH keys, authorized hosts | Keys here = gateway to systems |
| `~/.bashrc` | Shell config (per-user) | Can contain aliases, env vars |
| `~/.bash_history` | Command history | Everything typed, including passwords |
| `~/.profile` | Login shell config | Environment setup |
| `~/.gitconfig` | Git configuration | May contain credentials |
| `~/. local/` | Local user installations | User-level binaries |
| `~/.config/` | Application configs | Various app secrets |
| `~/.cache/` | Cached data | Could contain sensitive cached data |

### Key Commands

```bash
# Show hidden files (all files)
ls -la

# Show ONLY hidden files (not . and ..)
ls -ld .*

# Find all hidden directories in home
find ~ -name ".*" -type d 2>/dev/null

# Check .bash_history for leaked secrets
grep -i "password\|secret\|token\|key" ~/.bash_history 2>/dev/null

# Check what aliases are set (could mask commands)
alias
```

### Security Implications

**1. Attacker hiding spots:**
```bash
# Attacker creates hidden directory
mkdir ~/.config/.systemd-update/
# Drops malicious binary there
# Sets up persistence via .bashrc or cron
```

**2. History mining:**
```bash
# Attacker reads bash history for passwords
cat ~/.bash_history | grep -i "password\|PASSWD\|SECRET"
```

**3. Aliased commands (phishing via aliases):**
```bash
# Attacker adds to .bashrc
alias sudo='sudo '   # This is actually legit (trailing space)
alias ls='ls --color=auto'  # Normal
# EVIL: alias ssh='cat ~/.ssh/id_rsa; ssh'  # Would leak key
```

### Hands-on Exercise

```bash
# 1. List all hidden files in your home
ls -la ~/ | head -30

# 2. Check your bash history for sensitive info
history | grep -i "passw\|secret\|token\|key" | tail -10

# 3. Look at your .bashrc
cat ~/.bashrc

# 4. Check .ssh directory permissions
ls -la ~/.ssh/ 2>/dev/null || echo "No .ssh directory"

# 5. Find all .gitconfig files (potential credential exposure)
find /home -name ".gitconfig" 2>/dev/null
```

---

## Chunk 5: Logs and Audit Trails

### What We'll Learn

| Concept | Security Relevance |
|---|---|
| /var/log/ | Central log directory |
| auth.log | Authentication attempts (success/failure) |
| syslog | System-wide logging |
| journalctl | systemd's log management |
| Log rotation | Logs don't grow forever |
| Timestamps | Chronological event reconstruction |

### Key Log Files

| Log File | Contains | Security Value |
|---|---|---|
| `/var/log/auth.log` | Login attempts, sudo usage | Brute-force attempts, unauthorized access |
| `/var/log/syslog` | General system messages | Errors, warnings, service issues |
| `/var/log/kern.log` | Kernel messages | Driver issues, kernel exploits |
| `/var/log/dmesg` | Kernel ring buffer | Boot-time messages, hardware issues |
| `/var/log/faillog` | Failed login attempts | Brute-force detection |
| `/var/log/lastlog` | Last login per user | Unusual login times/IPs |
| `/var/log/btmp` | Bad login attempts | Failed auth tracking |

### Key Commands

```bash
# View logs
sudo cat /var/log/auth.log        # Authentication log
sudo tail -f /var/log/auth.log    # Watch live (new lines appear)
sudo less /var/log/syslog         # Scroll through system log

# systemd journal (replaces some traditional logs)
journalctl                        # All logs
journalctl -u sshd                # Logs for sshd service
journalctl --since "1 hour ago"   # Recent logs
journalctl -p err                 # Error level only
journalctl -f                     # Follow (live view)

# View last logins
last
lastb                             # Bad login attempts
lastlog                           # All users' last login

# Failed login analysis
sudo grep "Failed password" /var/log/auth.log
sudo grep "Accepted password" /var/log/auth.log

# Sudo usage audit
sudo grep "sudo" /var/log/auth.log
```

### Log Entry Anatomy

```
Jun 25 14:30:15  webserver  sshd[12345]:  Failed password  for  root  from  192.168.1.100  port 22 ssh2
^               ^          ^     ^          ^               ^      ^     ^               ^
|               |          |     |          |               |      |     |               |
Date/Time       Hostname   Proc  PID        Event           User   IP    Port            Protocol
```

### Security Audit Points

1. **Brute-force detection:**
   ```bash
   # Count failed attempts per IP
   sudo grep "Failed password" /var/log/auth.log | \
     awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | head -10
   ```

2. **Sudo abuse:**
   ```bash
   # Monitor sudo usage
   sudo grep "sudo" /var/log/auth.log | tail -20
   ```

3. **Unusual login times:**
   ```bash
   # Last logins with timestamp
   last -10
   ```

4. **User switching (su):**
   ```bash
   sudo grep "su:" /var/log/auth.log
   ```

### Hands-on Exercise

```bash
# 1. Check available logs
ls -la /var/log/

# 2. View auth log for failed attempts
sudo grep "Failed password" /var/log/auth.log | tail -10

# 3. View auth log for successful logins
sudo grep "Accepted password" /var/log/auth.log | tail -10

# 4. Use journalctl for a specific service
journalctl -u sshd --since "today" | tail -15

# 5. Find brute-force attempts (top IPs)
sudo grep "Failed password" /var/log/auth.log | \
  awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | head -5

# 6. Check last time each user logged in
lastlog | head -20
```

---

## Quiz — Chunk 1 (FHS)

1. Where does the system store authentication logs on most Linux distributions, and why is that directory's permission configuration security-relevant?

2. You find a file in `/tmp` that looks like it belongs to a service. Why is `/tmp` dangerous for storing service data?

3. A binary is located at `/usr/local/bin/custom-tool`. You type `which custom-tool` and get no result. What does this tell you about PATH configuration?

4. What's the difference between `/etc/passwd` and `/etc/shadow`, and why was the split made?

---

## Quiz — Chunk 2 (Users and Groups)

5. You see UID 0 in `/etc/passwd` for a user named `backup`. Why is this immediately a critical finding?

6. What does it mean if a user's shell is `/sbin/nologin` or `/bin/false`?

7. A service runs as user `www-data` (UID 33). Can this user write to `/var/www/html` if the directory is owned by `root:root` with permissions 755?

---

## Quiz — Chunk 3 (File Permissions)

8. A directory has permissions `drw-rw-rw-` (666). Can you enter it with `cd`? Can you list files inside it? Can you delete files inside it?

9. A file has permissions `-rwxr-x---` (750) and is owned by `root:admin`. User `alice` is NOT in the `admin` group. What can alice do with this file?

10. You find a private SSH key with permissions `-rw-rw-r--` (664). When you try to use it to connect, SSH refuses. Why?

---

## Quiz — Chunk 4 (Hidden Files)

11. You run `ls -la` and see `.` and `..` entries. What do these represent?

12. An attacker adds `alias ssh='cat ~/.ssh/id_rsa; ssh'` to your `.bashrc`. What happens next time you run `ssh`?

---

## Quiz — Chunk 5 (Logs)

13. You see this log entry:
    `Jun 25 03:15:22 server sshd[24567]: Failed password for root from 10.0.0.50 port 22 ssh2`
    repeated 500 times in 2 minutes. What is happening and what should you do?

14. What is the difference between `last` and `lastb`?

15. A user claims they never logged in at 2 AM. How would you verify or refute this claim?

---

## What We Covered

| Chunk | Topic | Key Takeaway |
|---|---|---|
| 1 | FHS | Know where attackers hide (tmp), where configs live (etc), where logs go (var/log) |
| 2 | Users and Groups | UID 0 is root; system users have UIDs < 1000; any user with a shell can log in |
| 3 | File Permissions | 777 = anyone modifies; directory needs x to enter; SSH keys must be 600 |
| 4 | Hidden Files | Dot files hide configs and secrets; .bash_history leaks everything typed |
| 5 | Logs | auth.log tracks auth events; journalctl queries service logs; brute-force = many Faileds per IP |

---

## Next Session

**Session 2 — Linux Deep Dive**: SUID/SGID, processes and signals, cron jobs, sticky bit, trust boundaries.
