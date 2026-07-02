# Phase 1 - Chapter 1 & Chapter 2

# Lessons 1-4: Computer, Boot & Kernel Foundations

## Learning Objectives
- Understand the four fundamental hardware components.
- Understand why an operating system exists.
- Understand the high-level boot process.
- Understand firmware, bootloaders and kernels.
- Understand why the kernel is the central manager of an operating system.
- Begin reasoning about architecture and security tradeoffs.

## Core Mental Models
- CPU executes instructions; it does not decide what to execute.
- Programs are stored on persistent storage and loaded into RAM before execution.
- Firmware starts the machine, the bootloader loads the kernel, and the kernel starts the operating system.
- Applications interact with hardware through the kernel rather than directly.

## Responsibilities
| Component | Responsibility | Doesn't Do |
|---|---|---|
| CPU | Execute instructions | Decide what to execute |
| RAM | Temporary working memory | Permanently store files |
| Storage | Persistent storage | Execute programs |
| Firmware | Initialize hardware and locate a bootloader | Understand operating systems |
| Bootloader | Load the kernel | Become the operating system |
| Kernel | Manage hardware, memory, processes, files, networking and security | Provide end-user applications |
| Applications | Solve user tasks | Access hardware directly |

## Architecture Principles Learned
- Separation of Concerns.
- Single Responsibility Principle.
- Layered Architecture.
- Lower Coupling.
- Principle of Least Privilege.
- Assume components may become compromised.
- Balance performance against security and maintainability.

## Key Security Insights
- The kernel is the operating system's policy enforcement point.
- Applications should receive only the permissions they require.
- Trust identities and permissions, not application names.
- Firmware and bootloaders execute before the operating system and therefore form part of the trusted computing base.

## Design Discussions
### Why separate Firmware and Bootloader?
- Easier maintenance.
- Independent evolution of operating systems.
- Lower coupling.
- Simpler debugging.
- Smaller and more stable firmware.
- Reduced security and operational risk.

### Why not allow applications direct hardware access?
Benefits:
- Better performance.
- Fewer software layers.

Risks:
- No centralized access control.
- Easier privilege abuse after application compromise.
- Poor isolation between applications.
- Difficult auditing and policy enforcement.

Compromise:
- Controlled access through the kernel using permission models and least privilege.

## Commands (to practice later)
```bash
lscpu
free -h
lsblk
df -h
ls /sys/firmware
sudo dmidecode -t bios
ls /boot
uname -r
hostnamectl
```

## Teaching Methodology
1. Distinguish simplified models from engineering-level models.
2. Never skip reasoning steps.
3. Challenge assumptions where meaningful.
4. Build complete reasoning chains.
5. Maintain responsibility tables.
6. Capture architecture principles.
7. Record important discussions, not just conclusions.

## Recall Questions
1. Why does a computer need RAM?
2. Why can't storage replace RAM?
3. Why is firmware separate from the bootloader?
4. Why is the kernel the operating system's central manager?
5. What security problems would appear if applications directly controlled hardware?
6. What is the Principle of Least Privilege?
7. What is Separation of Concerns and where have we already seen it?

This document is a living engineering notebook. Future lessons will refine these mental models rather than replace them.