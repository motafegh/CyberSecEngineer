# Linux Basics — Quick Cheatsheet

## Permission String Decoder

```
d    rwx    r-x    r-x
type owner  group  others
     │││    │││    ││└─ t = sticky bit
     │││    │││    │└── x = execute/search
     │││    │││    └─── w = write/create
     │││    ││└── read, parent dir enter
     │││    │└─── x = execute/search
     │││    └──── w = write/create
     ││└────── x = execute
     │└─────── w = write
     └──────── r = read
```

## Security Scans — One-Liners

```bash
# SUID binaries
find / -perm -4000 -type f 2>/dev/null

# SGID binaries
find / -perm -2000 -type f 2>/dev/null

# World-writable files
find / -type f -perm -0002 2>/dev/null

# World-writable directories
find / -type d -perm -0002 2>/dev/null

# Files owned by root but writable by others
find / -user root -perm -o+w -type f 2>/dev/null

# No owner files
find / -nouser -o -nogroup 2>/dev/null

# Recently modified files
find /etc -mtime -7 -type f 2>/dev/null

# All listening ports
ss -tulnp

# Open files for a process
lsof -p PID
```

## Log Investigation

```bash
# Failed SSH attempts
grep "Failed password" /var/log/auth.log | awk '{print $11}' | sort | uniq -c | sort -nr

# Successful logins
grep "Accepted" /var/log/auth.log

# Sudo commands by user
grep "sudo.*COMMAND" /var/log/auth.log

# Users with UID 0 (root-equivalent)
awk -F: '($3 == 0) {print $1}' /etc/passwd

# Users with empty passwords
awk -F: '($2 == "" || $2 == "x") {print $1}' /etc/shadow 2>/dev/null
```
