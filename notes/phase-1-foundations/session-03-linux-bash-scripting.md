# Session 3 — Linux: Bash Scripting for Security

> **Roadmap ref:** `PHASE-1-FOUNDATIONS.md` → Section 1.1 (Mini Project)
> **Topics:** Variables, loops, conditionals, automation

## What We'll Learn

| Topic | Security Relevance |
|---|---|
| Bash variables & args | Parameterize your audit scripts |
| Conditionals (`if`, `test`) | Check conditions before acting |
| Loops (`for`, `while`) | Iterate over hosts, users, ports |
| `find` with `-exec` | Batch operations |
| Exit codes & error handling | Write reliable tools |

## Commands to Master

```bash
#!/bin/bash
var="value"
for i in {1..10}; do echo $i; done
if [ -f /etc/passwd ]; then echo "exists"; fi
find / -name "*.conf" -exec grep "password" {} \;
```

## Mini-Task
Build the **System Auditor** script from the roadmap:
- SUID binaries, world-writable files, cron jobs, open ports, users with no password

## Write-Up
- Save the script in `CyberSecEngineer/projects/system-auditor.sh`
- Run it, save the output

## Done When
- System Auditor script works and produces a structured report
- You can write a basic bash script from scratch
