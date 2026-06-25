# Linux Foundations — Complete Reference

> Phase 1, Section 1.1 | ~3 weeks | Reference: `Roadmap/PHASE-1-FOUNDATIONS.md`
>
> **Why this matters:** The Linux operating system powers 96% of servers, most cloud infrastructure, Android, and embedded devices. As a security professional, you will live in the terminal. You need to know the map before you can navigate the battlefield.

---

## 1. The Filesystem Hierarchy Standard (FHS)

Linux has a standard directory layout. Memorize these paths — you'll use them every single day.

### Root Directory (`/`)

Everything in Linux starts at `/`. There are no drive letters (C:, D:) like Windows. All storage is mounted somewhere under `/`.

```
/ ← the root of everything
├── bin  → usr/bin   (symlink)
├── boot              (kernel, bootloader)
├── dev               (devices: disks, terminals, etc.)
├── etc               (configuration files) ← IMPORTANT
├── home              (user home directories) ← IMPORTANT
├── lib  → usr/lib    (symlink)
├── media             (removable media mount points)
├── mnt               (temporary mounts)
├── opt               (optional 3rd-party software)
├── proc              (virtual filesystem for processes) ← IMPORTANT
├── root              (root user's home directory)
├── sbin → usr/sbin   (symlink)
├── snap              (Snap packages)
├── srv               (service data)
├── sys               (kernel & hardware info)
├── tmp               (temporary files, world-writable) ← IMPORTANT
├── usr               (user system resources)
└── var               (variable data: logs, databases) ← IMPORTANT
```

### Security-Relevant Directories (Must-Know)

#### `/etc` — Configuration Files
Everything that configures your system lives here.

| File | Purpose | Security Relevance |
|---|---|---|
| `/etc/passwd` | User accounts (names, UIDs, home dirs) | Lists all users on the system |
| `/etc/shadow` | Encrypted passwords | **Restricted to root** — password hashes |
| `/etc/group` | Group definitions | Who has which permissions |
| `/etc/sudoers` | Sudo access rules | Who can run commands as root |
| `/etc/crontab` | Scheduled tasks | Attackers add persistence here |
| `/etc/ssh/sshd_config` | SSH server config | Controls who can SSH in |
| `/etc/hosts` | Static hostname resolution | Can be used for DNS poisoning |
| `/etc/resolv.conf` | DNS server config | Where your DNS queries go |

#### `/var/log` — Log Files (Incident Response Goldmine)

| File | Records |
|---|---|
| `auth.log` | Authentication: SSH logins, sudo, cron |
| `syslog` | General system messages |
| `kern.log` | Kernel messages |
| `dmesg` | Kernel ring buffer (boot messages) |
| `dpkg.log` | Package installations |
| `lastlog` | Last login times for each user |
| `btmp` | Failed login attempts (binary) |
| `wtmp` | Login/logout history (binary) |

#### `/tmp` — World-Writable Temp Space
- **Anyone** can create files here (permission `drwxrwxrwt`)
- The **sticky bit** (`t`) means only the file owner can delete their own files
- **Attackers love `/tmp`** because they can write scripts here without needing special permissions
- Common attack: write a payload to `/tmp/exploit.sh`, then find a way to execute it

#### `/proc` — Process Information (Virtual)
This is not a real directory — it's a virtual filesystem the kernel creates to show running processes.

```bash
ls /proc
```

Each number is a running process's PID. Inside each numbered directory:
- `cmdline` — the command that started the process
- `environ` — environment variables (might contain passwords!)
- `fd/` — open file descriptors
- `maps` — memory mappings

**Security use:** Read `/proc/sys/net/ipv4/ip_forward` to check if the machine is acting as a router.

---

## 2. Understanding the Permission String

### The Map

Every file and directory has a permission string like this:

```
d   r w x   r - x   r - x
│   │ │ │   │ │ │   │ │ │
│   └─┬─┘   └─┬─┘   └─┬─┘
│     │       │       └── Others (everyone else)
│     │       └────────── Group (everyone in the file's group)
│     └────────────────── Owner (the user who owns the file)
│
└── Type
    d = directory
    - = regular file
    l = symlink (shortcut)
    c = character device
    b = block device
```

### The Three Letters: r, w, x

| Letter | Stands For | On a File | On a Directory |
|---|---|---|---|
| `r` | Read | Read file contents | List directory contents |
| `w` | Write | Modify file | Create/delete files inside |
| `x` | Execute | Run as a program | Enter the directory (cd into it) |

### Special Permission Bits

| Symbol | Name | Effect |
|---|---|---|
| `s` (in owner's x slot) | **SUID** | File runs as the **owner**, not as you |
| `s` (in group's x slot) | **SGID** | File runs as the **group**, not as you |
| `t` (in others' x slot) | **Sticky Bit** | Only the file owner can delete their files |

### Reading Real Examples From Your System

#### Example 1: A normal directory
```
drwxr-xr-x  31 root root    4096 Jun 24 21:19 .
```
- **Type:** `d` (directory)
- **Owner (root):** `rwx` — read, write, enter
- **Group (root):** `r-x` — read, enter, but **cannot write**
- **Others:** `r-x` — same as group
- **Security:** Only root can modify content here. Good.

#### Example 2: A symlink
```
lrwxrwxrwx   1 root root       7 Apr 22  2024 bin -> usr/bin
```
- **Type:** `l` (symlink)
- **Permission:** Always `rwxrwxrwx` (symlinks have their own permissions, but the actual file's permissions are what matter)
- **Arrow:** `->` shows where it points

#### Example 3: An executable file
```
-rwxr-xr-x   1 root root 2836528 Jun  6 06:46 init
```
- **Type:** `-` (regular file)
- **Everyone** can read and execute it, but only root can modify it
- This is the Linux kernel's initial process (PID 1)

#### Example 4: A private directory
```
drwx------   7 root root    4096 Jun 17 00:17 root
```
- Owner=`rwx`, Group=`---`, Others=`---`
- **Only root can enter.** If you `ls /root` without sudo, you get "Permission denied."
- This is how `/root` stays private

#### Example 5: World-writable with sticky bit
```
drwxrwxrwt  80 root root   28672 Jun 25 23:47 tmp
```
- **`w` for others:** anyone can write files
- **`t` for sticky:** but only the owner can delete their own files
- Without the sticky bit, user A could delete user B's files

---

## 3. Users, Groups, and Permissions in Practice

### How Permission Checks Work

When you try to access a file, the kernel checks in this order:

```
1. Are you the owner?      → Apply owner permissions (first 3 chars)
2. Are you in the group?   → Apply group permissions (middle 3 chars)
3. Neither?                → Apply others permissions (last 3 chars)
```

The **first match wins**. It doesn't accumulate — if you're the owner but your permissions are `rw-`, you can't execute even if the group has `--x`.

### The `groups` Command

Shows all groups you belong to:

```bash
$ groups
motafeq adm cdrom sudo dip plugdev users docker
```

Each group lets you do different things:
- `adm` → read system logs (`/var/log/auth.log`)
- `sudo` → run commands as root
- `docker` → run Docker commands

### The `/etc/group` File

Lists all groups on the system:

```
groupname:password:GID:members
```

Example from your system:
```
adm:x:4:syslog,motafeq
```

- Group `adm` has GID 4
- Members: `syslog` (the system logger) and `motafeq` (you)
- The `x` means the password is stored in `/etc/gshadow` (rarely used)

---

## 4. Log Analysis — Reading auth.log

`/var/log/auth.log` is the most important log file for security.

### What Gets Logged

| Event | Log Line Contains |
|---|---|
| SSH login attempt | `sshd` + `Failed password` or `Accepted password` |
| sudo command | `sudo` + `COMMAND=` |
| cron job | `CRON` + `session opened` |
| User login | `login` + `session opened` |
| su command | `su` + `authentication failure` or `successful` |

### Reading a Log Entry

```
2026-06-25T23:15:39.879335+03:30 ARlenovo sudo:  motafeq : TTY=pts/5 ; PWD=/home/motafeq/projects/sentinel ; USER=root ; COMMAND=/sbin/sysctl --system
```

| Part | Meaning |
|---|---|
| `2026-06-25T23:15:39` | Timestamp |
| `ARlenovo` | Hostname |
| `sudo:` | The program generating the log |
| `motafeq` | Who did it |
| `TTY=pts/5` | Which terminal (pts = pseudo-terminal) |
| `PWD=...` | Working directory at the time |
| `COMMAND=...` | Exact command that was run |

### Key Security Queries

```bash
# Check for failed SSH logins (brute force attempts)
grep "Failed password" /var/log/auth.log

# Check for successful SSH logins (who got in)
grep "Accepted password" /var/log/auth.log

# Check all sudo usage
grep "sudo" /var/log/auth.log

# Check for su (switch user) attempts
grep "su:" /var/log/auth.log

# Check for root logins
grep "root" /var/log/auth.log
```

### Incident Response Scenario

If you suspect a breach:
1. `grep "Accepted" /var/log/auth.log` — find all successful logins and their IPs
2. `grep "COMMAND=" /var/log/auth.log` — see what commands were run
3. Check for gaps in logs — attackers often delete logs to hide their tracks
4. `last` — shows recent login history from `/var/log/wtmp`

---

## 5. Cheatsheet: Commands Covered

```bash
# Navigation & Listing
ls -la /            # List root with all details
ls -la /var/log     # List logs with permissions
ls -la ~            # List home directory (including dotfiles)
pwd                 # Print working directory
cd /etc             # Change to /etc
ls ..               # List parent directory

# Permission & Ownership
chmod 755 file      # Change permissions (rwxr-xr-x)
chmod u+s file      # Set SUID bit
chown user:group file  # Change owner and group
umask               # View default permission mask

# Finding Things
find / -perm -4000 2>/dev/null       # Find SUID binaries
find / -writable -type f 2>/dev/null # Find world-writable files
find /etc -mtime -7 -type f          # Files modified in last 7 days

# Process & Network
ps aux              # List all running processes
ss -tulnp           # List listening ports with process names
top                 # Interactive process viewer
kill -9 PID         # Force kill a process

# Users & Groups
groups              # Show your groups
id                  # Show your UID, GID, and groups
cat /etc/passwd     # List all users
cat /etc/group      # List all groups
whoami              # Current username
who                 # Who's logged in
last                # Login history

# Text Processing
grep "pattern" file        # Search for pattern in file
grep -v "pattern" file     # Exclude lines matching pattern
grep -r "pattern" dir/     # Recursive search
head -n 20 file            # First 20 lines
tail -n 20 file            # Last 20 lines
tail -f file               # Follow file in real time
cut -d: -f1 /etc/passwd    # Extract first field (usernames)
sort file                  # Sort lines
uniq -c file               # Count unique lines
awk '{print $1}' file      # Print first column
sed 's/old/new/g' file     # Replace text

# System Info
uname -a            # Kernel version
df -h               # Disk space
free -h             # Memory usage
uptime              # How long since boot
dmesg | tail        # Recent kernel messages
```

---

## 6. Quick Reference: File Types

| Permission Start | Meaning |
|---|---|
| `d` | Directory |
| `-` | Regular file |
| `l` | Symbolic link (shortcut) |
| `c` | Character device (e.g., terminal) |
| `b` | Block device (e.g., disk) |
| `s` | Socket |
| `p` | Named pipe |

---

## 7. Security Connections Summary

| Linux Concept | How Attackers Abuse It | How Defenders Catch It |
|---|---|---|
| SUID bit | Find misconfigured SUID binaries → execute as root | `find / -perm -4000` — audit regularly |
| World-writable files | Drop scripts in `/tmp` | Monitor `/tmp` for unexpected executables |
| Log files | Delete or edit `auth.log` to hide actions | Send logs to remote server (cannot be modified locally) |
| Cron jobs | Add a reverse shell to cron to maintain access | Check `/etc/cron*` and `crontab -l` for all users |
| SSH keys | Add their public key to `~/.ssh/authorized_keys` | Check for unexpected SSH keys, audit auth.log |
| Sudo misconfig | If a script in `/etc/sudoers` can be exploited → root | Audit `/etc/sudoers` for dangerous entries |
| `/etc/passwd` | Add a new user with UID 0 (root) | `awk -F: '$3 == 0 {print $1}' /etc/passwd` |
| Process hiding | Name processes to look legitimate (`[kworker]` fake) | Compare `ps aux` output to known baselines |

---

*Next session: Processes, services, cron, and the System Auditor mini-script.*
