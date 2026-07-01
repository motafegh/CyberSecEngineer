# Phase 0 Lab Architecture

> **Status:** Living document. Last updated: 2026-07-01.
> **Purpose:** Visual representation of the local cyber range. Shows all
> components, networks, and trust boundaries. Read this first to understand
> what the lab looks like and what can talk to what.

## Legend

| Symbol | Meaning |
|---|---|
| ┌─...─┐ | Box around a component |
| ▼ │ ► | Direction of data flow |
| ═══ | Trust boundary (thick line) |
| ─── | Network connection (thin line) |
| ✅ | Allowed flow |
| ❌ | Denied flow |

---

## Full Architecture

```
╔════════════════════════════════════════════════════════════════╗
║  LAPTOP (HOST)                                                  ║
║  OS: Linux 24.04 · RAM: 50Gi · Docker 29.5.3                   ║
║                                                                  ║
║  ┌──────────────────────────────────────────────────────────┐  ║
║  │  DOCKER ENGINE                                            │  ║
║  │                                                            │  ║
║  │  ┌──────────────────┐      ┌──────────────────┐          │  ║
║  │  │ lab-net-nat       │      │ lab-net-internal  │          │  ║
║  │  │ (bridge, gateway  │      │ (bridge, --internal│         │  ║
║  │  │  enabled)         │      │  NO gateway)      │          │  ║
║  │  └────┬──────────────┘      └────┬──────────────┘          │  ║
║  │       │                          │                          │  ║
║  │       │ eth0                     │ eth1                     │  ║
║  │  ┌────▼────────────────────┐     │                          │  ║
║  │  │  kali-lab:with-msf       │     │                          │  ║
║  │  │  (Kali attack box)       │     │                          │  ║
║  │  │  22 tools + Metasploit   │     │                          │  ║
║  │  │  Bind mount: evidence/   │     │                          │  ║
║  │  └────┬─────────────────────┘     │                          │  ║
║  │       │ nmap, sqlmap, hydra...    │                          │  ║
║  │       └───────────────────────────┘                          │  ║
║  │                           │                                  │  ║
║  │                           ▼                                  │  ║
║  │                  ┌──────────────────┐                        │  ║
║  │                  │  vulnerables/    │                        │  ║
║  │                  │  web-dvwa         │                        │  ║
║  │                  │  Apache 2.4.25    │                        │  ║
║  │                  │  Port 80 (internal)                       │  ║
║  │                  └──────────────────┘                        │  ║
║  │                                                            │  ║
║  └──────────────────────────────────────────────────────────┘  ║
║                                                                  ║
║  STORAGE:                                                        ║
║  • building/labs/evidence/   (bind mount)                       ║
║  • learning/.../evidence/    (permanent archive)                 ║
║                                                                  ║
║  DOCUMENTATION:                                                  ║
║  • building/adr/             (Architecture Decision Records)     ║
║  • building/diagrams/        (this file lives here)             ║
║  • building/threat-models/   (risk assessments)                  ║
╚════════════════════════════════════════════════════════════════╝
```

---

## Trust Boundaries

```
═══════════════════════════════════════════════════════════════
  TRUST BOUNDARY 1: HOST ↔ DOCKER ENGINE
═══════════════════════════════════════════════════════════════
  Direction: bidirectional
  Risk: A compromised container could attack the host
  Control: bind mount pinhole (narrow paths only), no
           -p port mapping, no privileged containers,
           targets run with default Docker security
  Status: partially mitigated (no port mapping eliminates
           the primary attack path)

═══════════════════════════════════════════════════════════════
  TRUST BOUNDARY 2: CONTAINERS ↔ INTERNET
═══════════════════════════════════════════════════════════════
  Direction: Kali YES, DVWA NO
  Mechanism: --internal flag removes default gateway
             at the kernel routing level
  Verification: ping 8.8.8.8 from DVWA returns
                "Network is unreachable"
  Status: enforced at kernel level
```

---

## Allowed Flows (✅)

| From | To | Mechanism | Purpose |
|---|---|---|---|
| Kali (eth0) | Internet | lab-net-nat + Docker NAT | apt updates, tool downloads |
| Kali (eth1) | DVWA | lab-net-internal (peer-to-peer) | attack traffic (nmap, sqlmap) |
| Container | bind mount | -v flag (UID-mapped) | evidence persistence |
| Host | container IPs | Docker bridge (default) | management (docker exec) |

---

## Denied Flows (❌)

| From | To | Why blocked |
|---|---|---|
| DVWA | Internet | --internal removes gateway; kernel returns "Network is unreachable" |
| DVWA | Host filesystem | No shared volumes; only bind mount exists for evidence |
| Internet | DVWA | --internal has no route back from outside |
| Host | DVWA port 80 | No `-p` flag → no host-side listener |

---

## Connectivity Matrix (cross-reference)

| From → To | Kali (eth0) | Kali (eth1) | DVWA | Internet |
|---|---|---|---|---|
| **Kali (eth0)** | — | ❌ different NIC | ❌ | ✅ |
| **Kali (eth1)** | ❌ different NIC | — | ✅ | ❌ |
| **DVWA** | ❌ no route | ❌ no route | — | ❌ (no gateway) |
| **Internet** | ✅ (NAT) | ❌ unreachable | ❌ unreachable | — |
| **Host (WSL2)** | ✅ bridge | ✅ bridge | ✅ bridge (no -p) | ✅ |

---

## File Reference

- This diagram: `building/diagrams/phase-0-lab-architecture.md`
- Lab net isolation decision: `building/adr/ADR-001-lab-networking.md` (pending)
- Lab risk assessment: `building/threat-models/phase-0-lab-threat-model.md` (pending)
- Evidence handling rules: `building/labs/EVIDENCE-HANDLING.md`
