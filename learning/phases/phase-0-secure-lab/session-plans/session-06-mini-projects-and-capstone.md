# Session 6 — Phase 0 Mini-Projects + Capstone

> **Roadmap ref:** `PHASE-0-SECURE-LAB.md` §14–15 (Mini-Projects + Capstone)
> **Date:** Planned
> **Status:** [ ] Planned

---

## Session Goals

- [ ] Complete all three mini-projects (14.1–14.3)
- [ ] Synthesize everything into the capstone deliverable
- [ ] Mark every Phase 0 exit criterion as satisfied or explicitly deferred
- [ ] Write the capstone README with final architecture summary

---

## Chunk 1 — Mini-Project 14.1: Lab Architecture Package

### What We're Building

A self-contained package that explains the full lab architecture to someone who has never seen it. This is the "handover document" — if you share the lab with a colleague, this tells them everything they need.

### Deliverables

| Artifact | Source Material | Status |
|---|---|---|
| System context diagram | Session 5 diagram work | To finalize |
| Network zone diagram | Existing notes (01, 06, 08) | To finalize |
| Trust boundary diagram | Threat model from Session 5 | To finalize |
| Lab asset inventory | Existing docker images, network list | To write |
| Connectivity matrix | `evidence/2026-06-30-connectivity-matrix.txt` | Exists, needs expansion |
| Safety rules | `notes/01-host-safety.md` §5 | Exists, needs standalone doc |
| Snapshot/restore plan | Docker commit + rebuild docs | To write |
| First ADR | Session 5 ADR work | To finalize |

### The Asset Inventory

What goes in an asset inventory:

| Asset | Type | Purpose | Network | Can Reach Internet? |
|---|---|---|---|---|
| WSL2 (Ubuntu) | Host OS | Runs Docker, stores lab files | Host network | ✅ Yes |
| Docker Desktop | Container runtime | Manages containers, networks | Host network | ✅ Yes |
| `lab-net-nat` | Docker bridge (172.18.0.0/16) | Kali's internet access | Internal to Docker | ✅ Yes (via host NAT) |
| `lab-net-internal` | Docker bridge (172.19.0.0/16) | Target isolation | Internal to Docker | ❌ No (`--internal`) |
| `kali-lab:with-msf` | Docker container | Attack workstation | Both networks | ✅ Yes (via NAT) |
| DVWA | Docker container | Vulnerable web target | Internal only | ❌ Blocked |

### Hands-on Exercise

1. Review all existing notes and extract what's needed for each deliverable
2. Write the asset inventory to `building/capstones/phase-0-local-secure-cyber-range/inventory.md`
3. Finalize the architecture diagrams from Session 5
4. Write the standalone safety rules document to `building/labs/SAFETY-RULES.md`
5. Write the snapshot/restore plan

### Snapshot/Restore Plan Example

```
## Snapshot/Restore Plan

### Images (Docker)
- kali-lab:with-msf (3.51 GB) — committed image with msf installed
  Restore: docker run -dit --name kali ... kali-lab:with-msf
  Rebuild: NOT reproducible from Dockerfile alone (committed layer)

- kali-lab:latest (2.53 GB) — from Dockerfile, 22 tools, no msf
  Restore: docker build --network host -t kali-lab:latest ./building/labs/compose/kali/
  Rebuild: docker build --network host -t kali-lab:latest ./building/labs/compose/kali/

### Targets
- vulnerables/web-dvwa — pulled from Docker Hub
  Restore: docker run -dit --name dvwa --network lab-net-internal vulnerables/web-dvwa
  Rebuild: docker pull vulnerables/web-dvwa
```

---

## Chunk 2 — Mini-Project 14.2: Isolation Verification Report

### What We're Building

A formal report proving the lab's isolation works. This is the evidence that Phase 0 exit criterion "vulnerable systems cannot reach real local devices" is satisfied.

### Deliverables

| Section | Source Material |
|---|---|
| Allowed flow tests | Connectivity matrix from Session 3 |
| Blocked flow tests | Connectivity matrix — `--internal` tests |
| Explanation of results | Why each flow succeeded or failed |
| Risk findings | Host can reach container IPs (Docker bridge property) |
| Fixes applied | No port mapping, `--internal` flag |
| Final isolation statement | One-paragraph summary |

### The Isolation Statement (Template)

```
The lab uses two Docker bridge networks. lab-net-internal uses the --internal flag,
which removes the default gateway. Containers on this network physically cannot
reach the internet — the kernel returns "Network is unreachable" at the routing
level, before any packet is sent.

Targets on lab-net-internal have no port mapping. The WSL2 host has no listeners
on any target port. Even though the host CAN reach container IPs (Docker bridge
design), the absence of port mapping means the host never receives target traffic.

Kali is the only container connected to both networks. It can reach targets on
lab-net-internal and the internet on lab-net-nat through separate interfaces.
Docker's routing handles traffic separation automatically.

The highest-risk remaining gap: if someone adds -p 80:80 to a target container
during a future session, the host will expose port 80. The safety rules prohibit
this, but it is not physically prevented. The connectivity matrix should be
re-verified after any lab configuration change.
```

### Hands-on Exercise

1. Compile all connectivity test results into one report
2. Add the risk findings and fixes applied
3. Write the final isolation statement
4. Save to `building/capstones/phase-0-local-secure-cyber-range/isolation-report.md`

---

## Chunk 3 — Mini-Project 14.3: Evidence Pipeline Starter

### What We're Building

The evidence system that ensures every future session preserves its output. This is the process, not just the files.

### Deliverables

| Artifact | Source Material | Status |
|---|---|---|
| Log collection structure | `building/labs/evidence/` directory | Exists, needs confirmation |
| Packet capture sample | tcpdump from Session 4 | To run |
| Application log sample | DVWA Apache log from Session 4 | To run |
| Evidence naming convention | Session 4 Chunk 4 | To finalize and save |
| Sensitive log handling rule | Session 4 Chunk 5 | To finalize and save |

### Hands-on Exercise

1. Ensure `building/labs/evidence/` follows the naming convention
2. Copy any Session 4 evidence files into the capstone directory
3. Write a one-paragraph evidence-handling summary:
   ```
   Evidence is collected inside the Kali container via bind mounts to
   building/labs/evidence/. After each session, evidence is copied to
   learning/phases/phase-N-*/evidence/ and the Kali copy is deleted.
   Evidence files follow the YYYY-MM-DD-tool-target-description.ext
   naming convention. Sensitive data (passwords, tokens) found in
   evidence is flagged in a companion .notes.txt file, never edited
   in place.
   ```

---

## Chunk 4 — Capstone Synthesis

### What We're Doing

Checking every Phase 0 exit criterion against the actual lab. If it's done, mark it. If not, decide: do it now, defer with a reason, or accept the gap.

### The Exit Criteria Checklist

From `Roadmap/PHASE-0-SECURE-LAB.md` §17:

- [ ] Every core lab zone is built (0.1–0.6)
- [ ] Network isolation is verified
- [ ] Vulnerable systems cannot reach real local devices
- [ ] Clean snapshots or rebuild paths exist
- [ ] Documentation system exists
- [ ] Evidence handling process exists
- [ ] Architecture diagrams exist
- [ ] Lab threat model exists
- [ ] Safety rules are written
- [ ] Can explain full lab architecture without notes
- [ ] Can explain Lab Extension Protocol without notes

### The Capstone README

Update `building/capstones/phase-0-local-secure-cyber-range/README.md` to reflect the final state:

1. Which components are built and which are deferred
2. How to start the lab from scratch (commands)
3. The one-sentence architecture summary
4. The highest-risk mistake
5. Links to key artifacts (ADR, threat model, diagrams, inventory)

### Architecture Summary (One Sentence)

```
Two Docker bridge networks (one with --internal) separate Kali (attack workstation
with internet access) from vulnerable targets (no internet, no host exposure).
Kali bridges both networks. Targets are containerized and run without port mapping.
```

---

## Quiz — Session 6 (Phase 0 Final)

1. Someone asks: "Can a compromised DVWA attack your WSL2 host?" Walk through the full path: what would need to be true for that to work?

2. Someone asks: "Why didn't you use Docker Compose?" What's the honest answer? Is it a gap worth fixing?

3. Someone asks: "Your Kali container has seccomp disabled. Isn't that dangerous?" How do you answer?

4. You need to add a new target (Metasploitable 2) to the lab. Walk through the exact steps: network, container, verification, documentation.

5. After 6 months away, you come back to the lab. What commands do you run to get back to the exact state it was in? (Start from `docker images`.)

---

## What We'll Produce

| Artifact | Location |
|---|---|
| Lab Architecture Package | `building/capstones/phase-0-local-secure-cyber-range/` |
| Isolation Verification Report | `building/capstones/phase-0-local-secure-cyber-range/isolation-report.md` |
| Evidence Pipeline Starter | `building/labs/EVIDENCE-HANDLING.md` + capstone evidence/ |
| Asset Inventory | `building/capstones/phase-0-local-secure-cyber-range/inventory.md` |
| Snapshot/Restore Plan | `building/capstones/phase-0-local-secure-cyber-range/inventory.md` |
| Safety Rules (standalone) | `building/labs/SAFETY-RULES.md` |
| Capstone README (updated) | `building/capstones/phase-0-local-secure-cyber-range/README.md` |
| Learning note | `notes/11-phase-0-capstone.md` |
| Phase 0 marked complete | Everything updated and archived |

---

## After Session 6

Phase 0 exit criteria are met. The lab is built, documented, and verifiable.

Next: **Phase 1 — Deep Technical Foundations.** Every concept we touched at the operational level (networking, Linux, Docker, containers) gets the mechanical treatment.
