# Linux Processes — Complete Guide

> Reference: `Roadmap/PHASE-1-FOUNDATIONS.md` → Section 1.1 (Processes & signals)
> Prerequisites: `01-linux-foundations-complete.md`, `02-suid-sgid-deep-dive.md`

---

## 1. What Is a Process?

A **process** is a running instance of a program. Every program you run — your terminal, the browser, Docker containers, this AI assistant — is represented as one or more processes on the system.

**Program vs Process:**
| | Program | Process |
|---|---|---|
| What it is | A file on disk (binary/script) | A running instance loaded in memory |
| Example | `/usr/bin/python3` | Python PID 1234 consuming RAM |
| Analogy | A recipe book | Actually cooking the recipe |

---

## 2. `ps aux` — The Process Snapshot Command

`ps aux` is the most common command to view processes.

```bash
ps aux
```

### Word-by-Word

| Part | Meaning |
|---|---|
| `ps` | **P**rocess **S**tatus — show running processes |
| `a` | **A**ll users — show processes from every user, not just you |
| `u` | **U**ser-oriented format — show the user column, CPU%, MEM% |
| `x` | Include processes without a terminal (background daemons) |

Without these flags, `ps` only shows processes in your current terminal (very few).

### The Columns

```
USER   PID  %CPU %MEM   VSZ    RSS   TTY  STAT START   TIME     COMMAND
│      │    │    │      │      │     │    │    │       │        │
│      │    │    │      │      │     │    │    │       │        └── The command that started this process
│      │    │    │      │      │     │    │    │       └── Total CPU time used (mm:ss)
│      │    │    │      │      │     │    │    └── When the process started
│      │    │    │      │      │     │    └── Process state (see STAT codes below)
│      │    │    │      │      │     └── Terminal (pts/X = pseudo terminal, ? = no terminal = daemon)
│      │    │    │      │      └── RSS (Resident Set Size) — actual physical RAM in KB
│      │    │    │      └── VSZ (Virtual Memory Size) — total allocated virtual memory in KB
│      │    │    └── %MEM — percentage of total RAM
│      │    └── %CPU — CPU usage percentage
│      └── PID (Process ID) — unique number identifying this process
└── Who owns this process
```

### STAT (Process State) Codes

| Code | Meaning | When You See It |
|---|---|---|
| `R` | **R**unning | Actively using CPU right now |
| `S` | **S**leeping | Idle, waiting for something (most common) |
| `D` | **D**isk sleep | Waiting for disk I/O (uninterruptible) |
| `Z` | **Z**ombie | Finished but parent never collected its status |
| `T` | **T**raced/stopped | Paused (e.g., by a debugger) |
| `X` | **D**ead | Should never be seen (freed instantly) |

**Additional flags in STAT:**

| Flag | Meaning |
|---|---|
| `s` | Session leader (first process in a group) |
| `l` | Multi-threaded |
| `N` | Low priority (niced) |
| `<` | High priority |
| `+` | In foreground process group |

Example: `Ssl+` = Sleeping + session leader + multi-threaded + foreground.

---

## 3. PID 1 — `/sbin/init` (The First Process)

```
PID 1  →  /sbin/init  →  symlink to systemd
```

### What It Is

PID 1 is the **first process** the kernel starts after boot. The kernel doesn't start anything else — it starts PID 1, and PID 1 starts everything else.

```
Linux Kernel boots
  └── Starts PID 1 (/sbin/init = systemd)
        ├── PID 22 (cron)
        ├── PID 64 (systemd-journald)
        ├── PID 244 (dbus-daemon)
        ├── PID 250 (redis-server)
        ├── PID 318 (postgres)
        └── All other processes...
```

### Why It's Special

- **Immortal:** If PID 1 dies, the kernel panics and the system crashes
- **Protected:** You cannot kill PID 1 with `kill -9` (kernel protects it)
- **Orphan reaper:** When any process's parent dies, the orphan becomes a child of PID 1
- **Modern init:** On Ubuntu, `/sbin/init` is a symlink to `systemd` — the standard init system

### Security Relevance

- Rootkits sometimes replace or hook PID 1 to maintain persistence
- Container escape exploits sometimes target PID 1
- Any process whose parent dies becomes a child of PID 1 — useful to remember when tracing process ancestry

---

## 4. The Process Tree

Every process has a parent. You can see the family tree:

```bash
ps -ejH
```

This shows processes as a tree, indented by parent-child relationships.

### Orphan Processes

If a parent process dies, its children become **orphans**. PID 1 (`systemd`) automatically **adopts** them. This ensures no process is ever without a parent (except PID 1 itself).

### Zombie Processes

A **zombie** is a process that has finished but whose parent never collected its exit status.

```
1. Parent creates child
2. Child runs and exits
3. Child sends SIGCHLD to parent: "I'm done"
4. Parent calls wait() to collect exit status → child removed from process table
5. If parent NEVER calls wait() → child stays as ZOMBIE (STAT = Z)
```

**Zombie characteristics:**
- `VSZ: 0, RSS: 0` — no memory (already freed)
- `%CPU: 0.0, %MEM: 0.0` — doesn't run or use resources
- `STAT: Z` — zombie
- The only thing left is an entry in the process table (tiny)

**Security relevance:**
- Zombies themselves can't execute code (they're dead)
- But an attacker could fill the process table with thousands of zombies → DoS (no new processes can start)
- Long-term zombies indicate a buggy parent process

### Reaping Zombies

You can't kill a zombie (it's already dead). Instead:
- Kill the parent process → orphan zombie gets adopted by PID 1 → PID 1 reaps it (cleans it up)
- Or: fix the parent process to properly call `wait()`

---

## 5. Cron — Scheduled Tasks (Persistence Vector)

### What It Is

The **cron daemon** (`/usr/sbin/cron`) is a scheduler. It runs commands at specified times — like an alarm clock for your system.

### How Cron Jobs Work

**System-wide crontab** (`/etc/crontab`):
```
# minute hour day-of-month month day-of-week user  command
   17     *       *          *        *       root  run-parts /etc/cron.hourly
```

- `*` = every (wildcard)
- `17 * * * *` = at minute 17 of every hour, every day
- `25 6 * * *` = at 6:25 AM every day
- `47 6 * * 7` = at 6:47 AM every Sunday
- `52 6 1 * *` = at 6:52 AM on the 1st of every month

**Per-user crontab:**
Each user can have their own crontab:
| Command | Purpose |
|---|---|
| `crontab -l` | List your cron jobs |
| `crontab -e` | Edit your cron jobs |
| `sudo crontab -l -u root` | View root's cron jobs |

**Cron directories** — scripts placed here run automatically:
```
/etc/cron.hourly/
/etc/cron.daily/
/etc/cron.weekly/
/etc/cron.monthly/
```

### Why Security Cares

Cron is one of the **most abused persistence mechanisms**. Attackers plant a reverse shell in cron:

**Malicious cron entry** (checks every 5 minutes):
```
*/5 * * * * /tmp/.hidden/rev.sh
```

Even if you remove the attacker's access, `rev.sh` runs again 5 minutes later.

### Where to Check for Cron Persistence

```bash
# System crontab
cat /etc/crontab

# User crontabs
crontab -l
sudo crontab -l -u root

# Cron directories
ls -la /etc/cron.hourly/
ls -la /etc/cron.daily/
ls -la /etc/cron.weekly/
ls -la /etc/cron.monthly/
ls -la /etc/cron.d/        # Drop-in files for cron
```

---

## 6. `ss` — Socket Statistics (Network Connections)

### The Command

```bash
ss -tulnp
```

### Word-by-Word

| Flag | Meaning |
|---|---|
| `-t` | **T**CP connections |
| `-u` | **U**DP connections |
| `-l` | **L**istening sockets only (not established connections) |
| `-n` | **N**umeric — don't resolve IPs to hostnames |
| `-p` | **P**rocess — show which program owns each socket |

"Show me all listening TCP and UDP connections with the process names, no DNS lookups."

### Reading the Output

```
LISTEN 0   511   127.0.0.1:6379  0.0.0.0:*
│      │    │       │              │
│      │    │       │              └── Accepting from any IP (0.0.0.0 = any)
│      │    │       └── Local address and port
│      │    └── Backlog (pending connections allowed)
│      └── Recv-Q (bytes waiting to be received)
└── Socket state: LISTEN = waiting for connections
```

**Key distinction:**
| Binding | Meaning |
|---|---|
| `127.0.0.1:6379` | Only localhost can connect (safe) |
| `0.0.0.0:6379` | **Any** network interface — anyone can try to connect (risky if not intended) |

### Related Commands

```bash
# Show all active connections (not just listening)
ss -tunap

# Show Unix domain sockets (for local IPC)
ss -lxp

# Filter by port
ss -tulnp | grep 6379
```

---

## 7. Security Relevance of Each Process We Analyzed

| Process | What It Does | Security Concern |
|---|---|---|
| **PID 1 (init/systemd)** | First process, starts everything | Rootkit targets, container escape |
| **cron** | Scheduled tasks | **Persistence** — attackers plant reverse shells |
| **redis-server** | In-memory database | Common misconfig: exposed with no auth |
| **zombie (PID 12)** | Dead uncolllected process | DoS via process table exhaustion |
| **systemd-journald** | Logging daemon | Attackers clear logs here after breach |
| **postgresql** | SQL database | Another common exposed service |
| **tailscaled** | Tailscale VPN | Creates mesh network — each node is reachable |

---

## 8. Cheatsheet: Process Commands

```bash
# View processes
ps aux                       # All processes, detailed
ps -ejH                      # Process tree
ps -o pid,ppid,stat,cmd      # Custom columns
top                          # Interactive live view (press q to quit)
htop                         # Better top (install separately)

# Find specific processes
pgrep -a python              # Find all Python processes with full command
ps aux | grep python         # Same but more detail

# Process info
pidof program_name           # Get PID by name
lsof -p PID                  # Open files for a process
lsof -i :PORT                # What's using this port

# Killing processes
kill PID                     # Graceful shutdown (SIGTERM)
kill -9 PID                  # Force kill (SIGKILL) — last resort
killall program_name         # Kill all processes with this name
pkill -f "pattern"           # Kill processes matching pattern

# Background/foreground
Ctrl+Z                       # Suspend foreground process to background
bg                           # Resume suspended job in background
fg                           # Bring background job to foreground
jobs                         # List background jobs
nohup command &              # Run immune to hangups (survives terminal close)

# Priorities
nice -n 10 command           # Start with low priority
renice -n 5 -p PID           # Change priority of running process
```
