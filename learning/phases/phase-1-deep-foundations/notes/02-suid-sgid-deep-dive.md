# SUID & SGID — Privilege Escalation Vectors

> Reference: `Roadmap/PHASE-1-DEEP-FOUNDATIONS.md` → Section 1.1 (Permissions)
> Covers: What SUID/SGID are, how to find them, attack scenarios, GTFOBins

---

## 1. The Problem: Why Normal Permissions Aren't Enough

On Linux, when you run a program, it runs with **your** permissions. You are `motafeq`. The program is `motafeq`. It can only do what `motafeq` is allowed to do.

But some actions require **root** privileges, even when started by a normal user:

```
You (motafeq) runs passwd
   └─ passwd needs to write to /etc/shadow (owned by root)
   └─ Without SUID → permission denied. You can never change your password.
   └─ With SUID → passwd runs as root, succeeds, then exits.
```

This is the **Set User ID (SUID)** mechanism. It temporarily elevates the program to run as its file owner, not as the user who launched it.

---

## 2. The Name

| Abbreviation | Stands For | What It Does |
|---|---|---|
| **SUID** | **S**et **U**ser **ID** | File runs as the **owner** (usually root), not as you |
| **SGID** | **S**et **G**roup **ID** | File runs as the **group**, not as you |

Common misconception: "SUID" does NOT stand for "Super User ID." It's "Set User ID" — the owner could be anyone, not just root.

---

## 3. How to Spot Them in `ls -la` Output

Look at the owner's execute position:

```
-rwsr-xr-x   → SUID (s replaces x in owner position)
-rwxr-sr-x   → SGID (s replaces x in group position)
-rwsr-sr-x   → Both (SUID + SGID)
-rwxr-xr-t   → Sticky bit (t replaces x in others position)
```

The `s` is lowercase when execute (`x`) is also present. If there's no execute permission, it shows as capital `S` (which means it's set but won't work — a misconfiguration).

---

## 4. The Octal Permission Values

Permissions in Linux use octal (base-8) numbers:

| Value | Permission |
|---|---|
| `0` | `---` |
| `1` | `--x` |
| `2` | `-w-` |
| `3` | `-wx` |
| `4` | `r--` |
| `5` | `r-x` |
| `6` | `rw-` |
| `7` | `rwx` |

The permission string is built from **four** octal digits:

```
Example: 4755
││││
│││└── Others permissions (5 = r-x)
││└─── Group permissions (5 = r-x)
│└──── Owner permissions (7 = rwx)
└───── Special permissions (4 = SUID)
```

| Special Digit | Meaning |
|---|---|
| `0` | No special bits |
| `1` | Sticky bit only |
| `2` | SGID only |
| `3` | SGID + Sticky |
| `4` | SUID only |
| `5` | SUID + Sticky |
| `6` | SUID + SGID |
| `7` | SUID + SGID + Sticky |

So:

| Command Flag | Meaning |
|---|---|
| `-perm -4000` | Match files with SUID set (at minimum) |
| `-perm -2000` | Match files with SGID set |
| `-perm -6000` | Match files with SUID or SGID set |
| `-perm /4000` | Match files with SUID set (OR logic, newer find) |

---

## 5. The Command: How to Find SUID Binaries

Command we ran:

```bash
find / -perm -4000 -type f 2>/dev/null
```

### Word-by-Word Breakdown

| Part | Type | Meaning |
|---|---|---|
| `find` | command | Search for files/directories |
| `/` | argument | Start searching from root directory (the entire filesystem) |
| `-perm` | option | Match by permission (short for "permission") |
| `-4000` | value | The permission to match. `4000` = SUID bit. The `-` prefix means "at least these bits" |
| `-type` | option | Match by type |
| `f` | value | Regular files (not directories, not symlinks) |
| `2>/dev/null` | redirect | Send error messages (stderr, file descriptor 2) to the void |

### Why `2>/dev/null` Is Necessary

Without it, you'll see hundreds of lines like:

```
find: '/root': Permission denied
find: '/etc/ssl/private': Permission denied
```

These are normal — you're searching as a regular user and can't enter certain directories. The `2>/dev/null` hides these and shows only the actual results.

### Why We Added `-not -path`

The original command was slow because `find` was searching inside:
- `/snap/` — contains large snap packages with many files
- `/proc/` — virtual filesystem with thousands of process entries
- `/sys/` — another virtual filesystem

```bash
find / -perm -4000 -type f \
  -not -path "/snap/*" \
  -not -path "/proc/*" \
  -not -path "/sys/*" \
  2>/dev/null
```

---

## 6. The SUID Binaries We Found on Your System

### Results

```
-rwsr-xr-x  root  /usr/bin/passwd
-rwsr-xr-x  root  /usr/bin/su
-rwsr-xr-x  root  /usr/bin/sudo
-rwsr-xr-x  root  /usr/bin/mount
-rwsr-xr-x  root  /usr/bin/umount
```

### Why Each One Needs SUID

#### `/usr/bin/passwd` — Change User Passwords

```
You type:    passwd
passwd runs as root (SUID)
passwd reads /etc/shadow (only root can read/write this)
passwd updates your password hash
passwd exits, returns to your normal privileges
```

Without SUID, only root could change passwords. Every user would need to call the sysadmin to reset their password.

#### `/usr/bin/su` — Switch User

```
You type:    su john
su runs as root (SUID)
su authenticates you (checks password against /etc/shadow)
su spawns a shell as john
```

The SUID lets `su` read `/etc/shadow` to verify your password, then switch your UID.

#### `/usr/bin/sudo` — Execute Commands as Root

```
You type:    sudo whoami
sudo runs as root (SUID)
sudo checks /etc/sudoers (only root can read this)
sudo verifies you're allowed to run the command
sudo spawns whoami as root
Output: root
```

`sudo` is the most security-critical SUID binary. The `/etc/sudoers` file controls exactly who can run what as root.

#### `/usr/bin/mount` — Mount Filesystems

```
You type:    mount /dev/sdb1 /mnt/usb
mount runs as root (SUID)
mount calls the kernel to attach a filesystem
mount succeeds, USB drive is now accessible
```

Mounting requires kernel-level access. Without SUID, only root could mount USB drives.

#### `/usr/bin/umount` — Unmount Filesystems

Same as mount but for detaching filesystems.

### What About `ping`?

```
/bin/ping  →  -rwxr-xr-x (NO SUID)
```

`ping` doesn't have SUID on modern systems because it uses **capabilities** instead — a more secure alternative:

```bash
getcap /bin/ping
# Output: /bin/ping = cap_net_raw+ep
```

Capabilities give a binary exactly the privilege it needs (in this case: raw network access) without full root. This is the modern, more secure approach. You'll learn more about this later.

---

## 7. The Attack: Privilege Escalation via SUID

### The Problem

What if a sysadmin accidentally leaves SUID on a dangerous binary?

```bash
# Administrator does this by mistake:
chmod u+s /usr/bin/vim
# Now ANY user running vim can edit ANY file as root
```

### The Attack Scenario

```
1. You gain access as a low-privilege user (www-data, nobody, etc.)
2. Run: find / -perm -4000 -type f 2>/dev/null
3. Find: /usr/bin/find  (has SUID, owned by root)
4. Use GTFOBins technique:

   find . -exec /bin/sh -p \; -quit
   
   This spawns a root shell because find runs as root (SUID)
5. You are now root. Game over.
```

### GTFOBins

**GTFOBins** (https://gtfobins.github.io/) is a curated list of Unix binaries that can be exploited for privilege escalation when they have SUID.

Common SUID abuse examples from GTFOBins:

| Binary | Command to Escalate |
|---|---|
| `vim` | `vim -c ':!/bin/sh'` |
| `python3` | `python3 -c 'import os; os.execl("/bin/sh", "sh", "-p")'` |
| `find` | `find . -exec /bin/sh -p \; -quit` |
| `less` | `less /etc/passwd` then `!/bin/sh` |
| `nano` | `nano` then `Ctrl+R`, `Ctrl+X`, `reset; sh -p 2>&-` |
| `awk` | `awk 'BEGIN {system("/bin/sh")}'` |
| `cp` | Copy `/etc/shadow` to a readable location, crack passwords |

### Why This Is #1 on Every Pentest

1. **Easy to find** — one `find` command
2. **Easy to exploit** — GTFOBins gives you the exact command
3. **High impact** — gives you root immediately
4. **Common mistake** — sysadmins accidentally leave SUID on things

---

## 8. The Audit: How Defenders Check for SUID

If you're defending a system:

```bash
# Step 1: Find all SUID binaries
find / -perm -4000 -type f 2>/dev/null

# Step 2: Compare against a known-good list
# Save a baseline after OS installation:
find / -perm -4000 -type f 2>/dev/null > suid-baseline.txt

# Step 3: Periodically diff against baseline
diff suid-baseline.txt <(find / -perm -4000 -type f 2>/dev/null)

# Any unexpected binary in the diff = potential backdoor
```

---

## 9. Cheatsheet: SUID/SGID Commands

```bash
# Find SUID files
find / -perm -4000 -type f 2>/dev/null

# Find SGID files
find / -perm -2000 -type f 2>/dev/null

# Find SUID + SGID
find / -perm -6000 -type f 2>/dev/null

# Find SUID owned by root
find / -user root -perm -4000 -type f 2>/dev/null

# Find recent SUID changes (last 7 days)
find / -perm -4000 -type f -mtime -7 2>/dev/null

# Check capabilities (modern alternative to SUID)
getcap -r / 2>/dev/null

# List files with SUID in specific directories
ls -la /usr/bin/ | grep rws

# Check if a specific file has SUID
stat /usr/bin/passwd | grep Access

# Remove SUID from a file (if you find an accidental one)
sudo chmod u-s /path/to/binary
```

---

## 10. Summary

| Concept | Key Point |
|---|---|
| SUID | Set User ID — runs as file owner |
| SGID | Set Group ID — runs as file group |
| `s` in permission | SUID or SGID is set |
| `4000` | Octal value for SUID |
| `2000` | Octal value for SGID |
| GTFOBins | Database of SUID exploitation techniques |
| First step after access | Always check for SUID binaries |
| Defensive measure | Baseline your SUID files and audit changes |
