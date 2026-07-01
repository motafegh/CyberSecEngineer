# ADR-001: Lab Network Isolation Strategy

> **Status:** Accepted
> **Date:** 2026-07-01
> **Deciders:** Ali (with session 6-7 build context)

## Context

The local cyber range needs to run intentionally vulnerable targets (DVWA, WebGoat, Juice Shop) that can be safely attacked from a Kali workstation. Two conflicting requirements exist:

1. **Targets must be fully isolated** — they cannot reach the internet (data exfiltration risk) and cannot be reached from the host's network (attack bridge to real devices).
2. **The attack workstation needs internet access** — for tool updates (apt), downloading new tools, and C2 framework updates (Metasploit).

The lab runs on a Windows host with WSL2 (Ubuntu), using Docker as the container runtime. No nested virtualization is available.

## Decision

Use two Docker user-defined bridge networks with the `--internal` flag for the target network:

| Network | Flag | Default gateway | Purpose |
|---|---|---|---|
| `lab-net-nat` | (none) | Yes (NAT via Docker host) | Kali's internet access |
| `lab-net-internal` | `--internal` | **No** | Target isolation |

Kali (`kali-lab:with-msf`) connects to **both** networks, getting two interfaces:
- `eth0` on `lab-net-nat` — for internet
- `eth1` on `lab-net-internal` — for talking to targets

Targets (DVWA, WebGoat, Juice Shop) connect to **only** `lab-net-internal`.

**Targets are started with no `-p` flag** — no host-side port mapping. This means even though the host's network stack can reach container IPs (default Docker bridge behavior), the host has no listener on the target's port.

## Alternatives Considered

1. **VM-based isolation (VirtualBox/QEMU)** — rejected: not available on WSL2, would require switching OS/hypervisor
2. **Single Docker network + iptables rules** — rejected: more complex, easier to misconfigure, rules can be lost on container restart
3. **Docker Compose with custom networks** — considered but not yet adopted: would centralize config but adds abstraction layer and a YAML file to maintain
4. **Host networking (`--network host`)** — rejected: completely breaks isolation, container shares host's network stack
5. **No isolation (default bridge only)** — rejected: targets would be reachable from host and from the internet

## Consequences

### Positive

- Targets physically cannot reach the internet — the kernel returns "Network is unreachable" at the routing level, before any packet is sent
- No port mapping means the host has no listener for target services
- Architecture is verifiable: a single `ping 8.8.8.8` from a target proves isolation
- Simple mental model: two networks, two rules (Kali on both, targets on internal only)

### Negative

- **IP-level host-to-container reachability** — Docker bridges make container IPs reachable from the host. Isolation relies on the *absence of port mapping*, not on IP blocking. If someone adds `-p 80:80` to a target, the host will be exposed. This is a *human discipline* control, not an OS-enforced one.
- **Docker seccomp profile** blocks raw sockets by default. nmap on Kali required `--security-opt seccomp=unconfined` and `--cap-add=NET_RAW --cap-add=NET_ADMIN`. This is a security weakening for Kali specifically.
- **Manual `docker run` commands** instead of Docker Compose. More typing, no central config. Will be revisited when the lab is stable.
- **Both networks required** — forgetting `docker network connect lab-net-internal kali` after `docker run` means Kali can't reach targets. The two-step start is error-prone.

## Supersession Conditions

This ADR is superseded when any of the following becomes true:
- Lab is migrated to Docker Compose (config becomes a YAML file, not ad-hoc commands)
- Lab is migrated to Kubernetes (Phase 3) — networks become `NetworkPolicy` resources
- Lab needs a third network tier (e.g., separate log collector network)
- New isolation requirement appears that `--internal` cannot satisfy

## Related

- Diagram: `building/diagrams/phase-0-lab-architecture.md`
- Threat model: `building/threat-models/phase-0-lab-threat-model.md`
- Evidence: `learning/phases/phase-0-secure-lab/evidence/2026-06-30-connectivity-matrix.txt`
