# Session 6 — SecAudit CLI Capstone

> **Roadmap ref:** `PHASE-1-DEEP-FOUNDATIONS.md` → Capstone
> **Topics:** Combine everything into a Python security tool

## What We're Building

A modular Python CLI tool that does network scanning, web auditing, hash cracking, and report generation.

```
secaudit/
├── secaudit.py          # entry point with argparse
├── modules/
│   ├── network.py       # port scan, banner grab
│   ├── web.py           # header audit, TLS check
│   └── crypto.py        # hash identify, crack
└── requirements.txt
```

## Plan

| Step | What |
|---|---|
| 1 | Scaffold: argparse CLI, module structure |
| 2 | `network.py`: TCP connect scan, banner grab |
| 3 | `web.py`: HTTP header security check |
| 4 | `crypto.py`: Hash type identification |
| 5 | Report output: JSON + human-readable |
| 6 | README, GitHub publish |

## Write-Up
- Code in `CyberSecEngineer/projects/secaudit/`
- Notes on design decisions

## Done When
- `python secaudit.py scan 192.168.56.0/24` works
- `python secaudit.py web --url http://example.com` works
- Published on GitHub with professional README
