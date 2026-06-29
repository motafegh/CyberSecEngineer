# Session Summary — Day 1 (June 25, 2026)

## What We Did

1. **Explored the roadmap** — Reviewed all 11 files in `Roadmap/`, understood the 5-phase structure
2. **Checked your system** — Ubuntu 24.04 on WSL2, Docker + Python + Git available
3. **Chose the approach** — VirtualBox on Windows for VMs, Docker in WSL2 for web labs
4. **Installed Python tools** — pwntools, scapy, requests, beautifulsoup4, semgrep in a venv at `~/security-env`
5. **Created the notes system** — Full directory structure at `CyberSecEngineer/notes/`
6. **Set up Docker labs** — `CyberSecEngineer/labs/web-labs/docker-compose.yml` with DVWA, WebGoat, Juice Shop (all running on ports 8080-8082)
7. **Wrote educational notes** — 6 files covering everything learned so far

## Concepts Learned

| Concept | Key Takeaway |
|---|---|
| Lab isolation | Host-Only network keeps target VMs from escaping to your real network |
| Snapshots | Save points that let you reset a VM in seconds |
| Docker containers | Lightweight app environments that start in seconds |
| Project structure | Single repo for roadmap + notes + code + labs |

## Problems Encountered

| Problem | Resolution |
|---|---|
| crAPI Docker image removed from Docker Hub (`crapi/crapi-all`) | Removed from compose file — will revisit when API security module starts |
| Python pip blocked by PEP 668 | Created virtual environment (`~/security-env`) with `python3 -m venv` |
| Docker compose deprecated `version` attribute | Removed it from the YAML file |

## Current Lab Status

| Component | Status |
|---|---|
| Docker (WSL2) | ✅ 3 containers running (DVWA, WebGoat, Juice Shop) |
| Python venv | ✅ Tools installed |
| Notes system | ✅ Directory structure created |
| VirtualBox (Windows) | ⏳ Pending — user needs to install |
| Kali Linux (Windows) | ⏳ Pending |
| Metasploitable 2 (Windows) | ⏳ Pending |
| Host-Only network | ⏳ Pending |

## Next Steps

1. Install VirtualBox on Windows
2. Import Kali Linux + Metasploitable 2
3. Configure Host-Only network
4. Take first snapshots
5. Start Phase 1 foundations (Linux, networking)

## Notes Created

| File | Topic |
|---|---|
| `01-lab-architecture.md` | The 3-layer lab structure and why it matters |
| `02-network-isolation.md` | Host-Only vs Bridged explained |
| `03-snapshots.md` | Why and how to use VM snapshots |
| `04-docker-setup.md` | Docker compose file, each app, the crAPI problem |
| `05-project-structure.md` | Repo layout, note-taking rules, roadmap phases |
| `tools/cheatsheets/docker.md` | Quick Docker command reference |
