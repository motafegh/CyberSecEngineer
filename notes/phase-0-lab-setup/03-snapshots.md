# VM Snapshots

## What Is a Snapshot?

A frozen point-in-time copy of your virtual machine's entire state — disk, memory, settings, everything.

Think of it like a **save point in a video game before a boss fight**.

## Why Snapshots Are Critical

When you attack a VM, things can go wrong:
- A privilege escalation script crashes the OS
- You install something that breaks the configuration
- An exploit leaves the system in an unstable state
- You accidentally delete a critical file

Without a snapshot → reinstall the entire VM (30+ minutes)
With a snapshot → restore in **5 seconds** and it's back to factory fresh

## The Discipline

```
BEFORE every attack:   Take snapshot → "Pre-Attack [attack name]"
AFTER attack complete: Restore snapshot → clean state
BEFORE any config:     Take snapshot → "Pre-Config [change name]"
```

## Best Practices

1. **Name snapshots descriptively** — "Fresh Install", "Pre-Attack SMB Exploit", "DC Configured"
2. **Don't keep too many** — delete old ones once the lesson is done
3. **Initial snapshot** — take one right after installing/importing the VM (clean baseline)

## Example Flow

```
1. Import Kali Linux
2. Update + install tools
3. Take snapshot → "Fresh Install — Phase 0"
4. Do Phase 1 learning (nmap scans, bash scripting, etc.)
5. Before Phase 2 attacks → restore to the fresh snapshot
6. Metasploitable stays perpetually fresh, ready for every session
```

## Common Mistake

"Just this once I'll skip the snapshot..."
— Famous last words before spending 45 minutes reinstalling a VM
