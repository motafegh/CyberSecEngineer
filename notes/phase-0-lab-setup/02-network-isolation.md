# Network Isolation — Host-Only vs Bridged

## The Core Question

How should our VMs connect to each other and to the internet?

## Three Network Modes

### NAT (Network Address Translation)
- VM shares your host's IP address for outbound traffic
- VM can reach the internet
- Internet **cannot** reach the VM
- **Use for**: Kali's internet access (downloading tools, updates)

### Host-Only
- VMs are on a private virtual switch
- VMs can talk to each other
- VMs **cannot** reach the internet or your home network
- **Use for**: All target VMs (Metasploitable, Windows, etc.)

### Bridged
- VM gets its own IP on your **real** home network (like another physical machine)
- VM can reach everything on your LAN
- Everything on your LAN can reach the VM
- **Not used in this lab** — too dangerous

## The Analogy

| Mode | Analogy |
|---|---|
| Bridged | Your VMs are neighbors on your street |
| Host-Only | Your VMs are in a soundproof room in your basement |

## Real-World Risk Scenario

Metasploitable 2 has default credentials (`msfadmin:msfadmin`) and dozens of known vulnerabilities.

- **With Bridged mode**: Anyone on your Wi-Fi can scan port 22 and SSH into it. A worm on the VM could spread to your real Windows PC.
- **With Host-Only mode**: Only Kali can reach it. Your Wi-Fi can't see it. It can't see your Wi-Fi.

## Our Network Architecture

```
Kali Linux
  Adapter 1: NAT (for internet)
  Adapter 2: Host-Only (192.168.56.0/24, for attacking)

All target VMs
  Adapter 1: Host-Only (same 192.168.56.0/24 network)
  No other adapters
```

## Verification Command

From Kali:
```bash
ping 192.168.56.x   # should reach target VMs
ping 8.8.8.8        # should reach internet (via NAT)
```
