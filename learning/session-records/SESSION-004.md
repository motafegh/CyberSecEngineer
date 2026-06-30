# Session 004

> **Date:** 2026-06-29
> **Module:** Phase 0, Module 0.3 (Kali Attack Workstation)
> **Status:** Complete

## What Was Done

Built a Kali Linux attack workstation Docker image through extensive trial and error:

1. Dockerfile created with 22 tools (nmap, nikto, sqlmap, hydra, john, etc.)
2. `--network host` flag discovered as fix for apt mirror timeouts
3. Six failed approaches for Metasploit install documented:
   - Build with msf in apt → mirror timeout (522 MB deb unreachable)
   - `gem install metasploit-framework` → empty stub (version 6.0.33, 0 files)
   - Rapid7 apt repo with GPG → gpg missing, then keyring broken
   - Direct .deb from GitHub → wrong URL, downloaded 9 bytes
   - `bundle install` with missing C headers → failed 3 times
   - Working: `git clone` + `apt install -dev` packages + `bundle install`
4. Image committed as `kali-lab:with-msf` (3.51 GB)
5. Chunk teaching on Docker networking, apt mirror architecture, Ruby gem system

## Outcomes

- `kali-lab:with-msf` image ready with all tools + msf 6.4.142 + analyst user + sudo
- Evidence file: `evidence/2026-06-29-session-2-kali-build.txt`
- Learning note: `notes/03-kali-build-trial-and-error.md`
- Vulnerable targets (0.4) deferred to next session

## Next Steps

- Session 3: Deploy DVWA, WebGoat, Metasploitable on `--internal` networks
- Verify isolation matrix
- Connectivity matrix document
