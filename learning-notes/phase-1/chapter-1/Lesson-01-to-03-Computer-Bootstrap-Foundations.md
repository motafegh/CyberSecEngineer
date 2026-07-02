# Phase 1 - Chapter 1

# Lessons 1-3: Computer & Boot Foundations

## Learning Objectives
- Understand the four fundamental hardware components.
- Understand why an operating system exists.
- Understand the high-level boot process.
- Understand firmware, bootloaders, and the separation of responsibilities.

---

## Fundamental Components

### CPU
- Executes machine instructions.
- Does not understand Windows, Linux, Python, or files.
- Executes whatever instructions it is given.

### RAM
- Temporary working memory.
- Holds running programs and active data.
- Fast and volatile.

### Storage (SSD/HDD)
- Persistent storage.
- Stores operating systems, applications and user files.
- Programs are loaded from storage into RAM before execution.

### Input / Output
- Allows interaction with the outside world.
- Examples: keyboard, mouse, display, network card.

---

## Program Execution Model

Storage -> RAM -> CPU

The CPU executes instructions from RAM. Storage is persistent, not execution memory.

---

## Virtual Memory / Swap

- Android: RAM Expansion / RAM Plus.
- Windows: Page File.
- Linux: Swap.

Storage never becomes real RAM. The operating system moves inactive memory pages between RAM and storage.

---

## Bootstrapping Problem

Software is needed to load software.

Boot sequence:
1. Power button pressed.
2. CPU reset.
3. Firmware (BIOS/UEFI) starts.
4. POST initializes and checks hardware.
5. Firmware finds a bootloader.
6. Bootloader loads the operating system kernel.
7. Kernel initializes the operating system.
8. User applications start.

---

## Responsibilities

| Component | Responsibility | Doesn't Do |
|---|---|---|
| CPU | Execute instructions | Decide what to execute |
| Firmware | Initialize hardware and locate bootloader | Understand operating systems |
| Bootloader | Load the kernel | Become the operating system |
| Kernel | Manage hardware/resources | Initialize motherboard firmware |
| Applications | Perform user tasks | Access hardware directly |

---

## Architecture Principles Learned

- Separation of Concerns.
- Layered Architecture.
- Lower Coupling.
- Single Responsibility.

---

## Security Notes

- Firmware executes before the OS.
- A compromised bootloader can compromise the entire system.
- Secure Boot exists to establish trust during boot.

---

## Commands (for later lab)

```bash
lscpu
free -h
lsblk
df -h
ls /sys/firmware
sudo dmidecode -t bios
ls /boot
```

---

## Teaching Rules Agreed

1. Distinguish simplified vs engineering-level explanations.
2. No hidden reasoning steps.
3. Challenge assumptions when meaningful.
4. Build complete reasoning chains.
5. Maintain responsibility tables.
6. Record architecture principles throughout the journey.

---

## Questions for Self Review

1. What is the CPU's primary responsibility?
2. Why is RAM required?
3. Why can't storage replace RAM?
4. What is firmware?
5. Why does a bootloader exist?
6. Why is separating firmware and bootloader good architecture?
7. What responsibilities belong to the kernel?

---

This document is the canonical study note for the first three lessons and should be extended rather than replaced as future lessons refine the mental model.
