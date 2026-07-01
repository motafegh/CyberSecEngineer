# Session 1 — Phase 0, Module 0.1–0.2: Host Safety & Virtualization Foundations

> **Roadmap ref:** `PHASE-0-SECURE-LAB.md` §8–9 (Modules 0.1 + 0.2)
> **Date:** 2026-06-29
> **Status:** [x] Done — Chunks 1-4 completed, Chunks 5-6 deferred (QEMU/libvirt not available on WSL2; Docker isolation verified instead)

---

## Session Goals

- [x] Understand why the host is the root of trust in any lab
- [x] Create a dedicated lab directory structure with safety rules
- [x] Write a host safety checklist (things to never do, things to always do)
- [x] Understand virtualization concepts: VM vs container, hypervisor types, network modes
- [x] Install a virtualization platform (Docker for containers, QEMU/libvirt for VMs — QEMU deferred)
- [x] Configure network isolation and verify it
- [~] Practice snapshot/restore workflow — Deferred (no VMs on WSL2)

---

## Chunk 1: Why the Host Matters

### What We'll Learn

| Concept | Security Relevance |
|---|---|
| Host workstation = root of trust | If host is compromised, all lab boundaries collapse |
| VM/container isolation depends on host integrity | Breakout from guest = attacker controls your machine |
| Shared folders and clipboard | Attack bridge between guest and host |
| Hypervisor layers (Type 1 vs Type 2) | Different attack surfaces for each type |

### The Trust Model

```
YOUR LAPTOP (HOST)
├── Real work (code, crypto wallets, personal data)
├── Lab directory (isolated by convention + permissions)
│   ├── Attack tools
│   ├── Vulnerable targets (assume compromised!)
│   └── Evidence/captures
├── Docker (container runtime)
│   └── Containers (isolated by namespaces + networks)
└── QEMU/libvirt (hypervisor)
    └── VMs (isolated by hardware emulation + networks)
```

### Key Insight

- **Docker containers** share the host kernel. Container breakout = host kernel access.
- **VMs** have their own kernel. VM escape is rarer but possible.
- Both need network isolation — that's the most common failure.

### Hands-on Exercise

```bash
# 1. Inventory your system
echo "=== OS ===" && cat /etc/os-release | head -3
echo "=== CPU ===" && lscpu | grep "Model name"
echo "=== Memory ===" && free -h | grep Mem
echo "=== Disk ===" && df -h / | tail -1

# 2. Check if virtualization is supported (for VMs)
lscpu | grep -i virtualization
# VT-x (Intel) or AMD-V = hardware virtualization available

# 3. Check kernel version (containers share this)
uname -r
```

---

## Chunk 2: Virtualization Concepts

### Containers vs VMs

| Aspect | Docker Container | Virtual Machine |
|---|---|---|
| **Kernel** | Shares host kernel | Own kernel (separate OS) |
| **Isolation** | Namespaces + cgroups | Hardware emulation |
| **Startup** | Seconds | Minutes |
| **Size** | MBs | GBs |
| **OS support** | Linux only (native) | Any OS (Linux, Windows, etc.) |
| **Breakout risk** | Higher (same kernel) | Lower (separate kernel) |
| **Best for** | Linux services, tools | Full OS environments |

### Hypervisor Types

| Type | Example | How It Runs | Security |
|---|---|---|---|
| **Type 1** (bare-metal) | VMware ESXi, Xen | Directly on hardware | Smaller attack surface |
| **Type 2** (hosted) | VirtualBox, QEMU | Runs on host OS | Larger attack surface |

We'll use **Type 2** (QEMU + libvirt) for VMs and Docker for containers.

### Network Modes for Isolation

| Mode | Host can reach guest? | Guest can reach internet? | Guest can reach other guests? |
|---|---|---|---|
| **NAT** | No (one-way) | Yes (via host) | No (by default) |
| **Host-only** | Yes | No | Yes |
| **Bridged** | Yes (same subnet) | Yes (as separate device) | Yes |
| **Internal** | No | No | Yes |

### Which Mode When?

| Use Case | Network Mode | Why |
|---|---|---|
| Kali attack workstation | NAT + host-only | Needs internet for updates, can reach lab targets |
| Vulnerable target VM | Host-only or internal | Never touches internet, only reachable from Kali |
| Docker lab containers | Custom bridge (isolated) | Controlled communication, no internet by default |
| Metasploitable | Host-only | Dead OS, no patches ever |

---

## Chunk 3: Lab Directory Structure + Safety Checklist

### What We'll Build

```
/home/motafeq/projects/CyberSecEngineer/
├── Roadmap/                  # Phase files, reference docs
├── learning/                 # Notes, evidence, session records
│   ├── phases/
│   │   └── phase-0-* /
│   └── ...
└── building/
    ├── labs/                 # Lab configs, Dockerfiles, compose files
    │   ├── iso/              # Downloaded ISO images
    │   ├── configs/          # VM/container configs
    │   └── compose/          # Docker Compose files
    ├── capstones/            # Phase capstone deliverables
    ├── projects/             # Standalone tools and scripts
    ├── portfolio/            # Public-facing portfolio pieces
    └── threat-models/        # Cross-phase threat models
```

### Safety Rules

```markdown
## Hard Rules (never break)

1. NO real passwords, API keys, or secrets in ANY lab directory
2. NO crypto wallet files, seed phrases, or private keys near lab code
3. NO production credentials in packet captures or logs
4. NO exploit code runs on the host — only in containers/VMs
5. EVERY vulnerable target stays in an isolated network
```

### Hands-on Exercise

```bash
# Create lab infrastructure directories
mkdir -p /home/motafeq/projects/CyberSecEngineer/building/labs/{iso,configs,compose}

# Set proper permissions (owner rwx, group rx, others nothing)
chmod 750 /home/motafeq/projects/CyberSecEngineer/building/labs

# WRITE the safety checklist
cat > /home/motafeq/projects/CyberSecEngineer/building/labs/HOST-SAFETY-CHECKLIST.md << 'EOF'
# Host Safety Checklist

## Before Every Lab Session
- [ ] No real credentials visible in shell history
- [ ] No crypto wallets or keys in lab directories
- [ ] Lab directory permissions correct (750)
- [ ] Lab-only credentials used (not real ones)

## During Lab Session
- [ ] Exploit code runs only inside containers/VMs
- [ ] Shared clipboard disabled for dangerous containers
- [ ] Packet captures limited to lab networks
- [ ] Vulnerable targets NOT on bridged network

## After Lab Session
- [ ] Containers/VMs stopped
- [ ] Evidence saved to `building/labs/evidence/`
- [ ] Snapshots taken if state should be preserved
- [ ] Lab networks verified isolated
EOF

echo "Checklist created"
```

---

## Chunk 4: Install Docker (Container Platform)

### Install Docker

```bash
# Update package index
sudo apt update

# Install prerequisites
sudo apt install -y ca-certificates curl

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Add your user to the docker group
sudo usermod -aG docker $USER

# Verify
docker --version
```

### Test Docker

```bash
# Test (after logging back in or with newgrp)
docker run hello-world

# Check Docker info
docker info | grep -E "Containers|Running|Server Version"
```

### Docker Security Note

`docker` group membership is equivalent to root on the host. Docker's CLI can mount any host directory. Only add trusted users to the docker group.

---

## Chunk 5: Install QEMU/libvirt (VM Platform)

### Why QEMU + libvirt

- **QEMU** — the emulator that runs VMs
- **libvirt** — the management layer (start/stop/configure VMs)
- **virt-manager** — GUI for managing VMs (optional)
- All are free, open-source, no KYC

### Install

```bash
# Install QEMU + libvirt
sudo apt install -y qemu-kvm qemu-utils libvirt-daemon-system libvirt-clients bridge-utils virt-manager

# Add your user to libvirt group
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER

# Start and enable libvirt
sudo systemctl enable --now libvirtd

# Verify
virsh list --all
```

### Test VM Platform

```bash
# Check QEMU/KVM is working
virt-host-validate qemu

# Check libvirt is running
systemctl status libvirtd --no-pager | head -5
```

### Default Network

libvirt creates a default NAT network. Check it:

```bash
virsh net-list --all
virsh net-info default
# This is your first isolated lab network
```

---

## Chunk 6: Verify Network Isolation

### Test Docker Isolation

```bash
# Create an isolated Docker network
docker network create --driver bridge --internal lab-net-internal
docker network create lab-net-nat

# Run a container with no network access
docker run --rm -it --network none alpine sh
# In the container: ping google.com  (should fail)
# Exit with Ctrl+D

# Run a container with isolated network
docker run --rm -d --name test1 --network lab-net-internal alpine sleep 300
docker run --rm -it --name test2 --network lab-net-internal alpine sh
# In test2: ping test1  (should work)
# In test2: ping google.com  (should fail)
```

### Test libvirt Network Isolation

```bash
# List networks
virsh net-list --all

# View network config
virsh net-dumpxml default

# Check active networks
ip addr show virbr0
# This is the bridge for the default NAT network
```

### Verify Isolation Matrix

| Source | Destination | Should Work? | How to Test |
|---|---|---|---|
| Host | Internet | Yes | Normal browsing |
| Docker container (NAT) | Internet | Yes | `docker run alpine ping 8.8.8.8` |
| Docker container (internal) | Internet | No | `docker run --network internal alpine ping 8.8.8.8` |
| Docker container (internal) | Another container | Yes | Same internal network |
| VM (NAT) | Internet | Yes | VM reaches internet via NAT |
| VM (host-only) | Internet | No | Isolated VM |

---

## Quiz — Chunk 1 (Why the Host Matters)

1. You download a Kali Linux container image and it contains a malicious script that reads `~/.ssh/id_rsa`. The container mounts your home directory as a volume. How does the attacker get your key?

2. What's the difference between container breakout and VM escape? Which is more likely?

3. Why is the clipboard between host and guest considered a security risk, and how would you mitigate it?

---

## Quiz — Chunk 2 (Virtualization Concepts)

4. A Docker container runs as root. If compromised, what kernel-level access does the attacker gain? What about a VM?

5. A vulnerable VM is configured with a **bridged** network adapter. What can happen that wouldn't happen with host-only?

---

## Quiz — Chunk 3 (Safety)

6. You find your production AWS access key in a Docker Compose file. What's the right immediate action? What's the root cause fix?

7. Name three things you should check BEFORE every lab session.

---

## Quiz — Chunk 4 (Docker)

8. What does `docker network create --driver bridge --internal` do? When would you use it?

9. Why is being in the `docker` group equivalent to root?

---

## Quiz — Chunk 5 (QEMU/libvirt)

10. What is the difference between QEMU and libvirt? Why do we need both?

11. What is `virbr0` and what creates it?

---

## Quiz — Chunk 6 (Isolation Verification)

12. A lab VM is compromised by a worm. The VM is on a host-only network. What can the worm infect? What can it NOT infect?

13. Describe your testing procedure to prove that vulnerable targets cannot reach your real local network.

---

## What We Covered (Completed)

| Chunk | Topic | Key Takeaway |
|---|---|---|
| 1 | Why the host matters | Host is root of trust; containers share kernel, VMs don't |
| 2 | Virtualization concepts | VMs vs containers, hypervisor types, 4 network modes |
| 3 | Lab directory + safety | Hard rules: no real secrets near lab code, ever |
| 4 | Docker isolation | `--internal` blocks internet; containers can reach each other by DNS on same network |

## What Was Deferred

| Chunk | Reason |
|---|---|
| 5 | Install QEMU/libvirt | WSL2 has no nested virtualization. VMs (VirtualBox on Windows) can be added later when needed |
| 6 | Verify network isolation | Covered enough for Docker; full verification matrix deferred to after VM setup |

---

## Next Session (what actually followed)

**Session 2 — Phase 0, Module 0.3–0.4: Kali Workstation & Vulnerable Targets**: Set up Kali as the attack workstation in Docker. Targets deferred to Session 3.
