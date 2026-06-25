# Reference — Free Resource Library

> **All resources are free. No KYC unless explicitly noted.**  
> **Organized by type, with account requirements noted.**

---

## Hands-On Labs & Practice Platforms

### Linux & Fundamentals

| Resource | Focus | Account | URL |
|---|---|---|---|
| **OverTheWire — Bandit** | Linux fundamentals, SSH, scripting | None | overthewire.org/wargames/bandit |
| **OverTheWire — Leviathan** | Privilege escalation basics | None | overthewire.org/wargames/leviathan |
| **OverTheWire — Natas** | Web security basics | None | overthewire.org/wargames/natas |

### Cryptography

| Resource | Focus | Account | URL |
|---|---|---|---|
| **CryptoPals** | Hands-on crypto attacks | None | cryptopals.com |
| **CryptoHack** | Modern crypto challenges | Email only | cryptohack.org |

### Binary Exploitation & Reverse Engineering

| Resource | Focus | Account | URL |
|---|---|---|---|
| **pwn.college** | Exploit mitigations, system security | Email only | pwn.college |
| **Exploit.education** | Phoenix/Fusion VMs (buffer overflows, heap) | None (VM download) | exploit.education |
| **Protostar** | Stack-based overflows | None (VulnHub VM) | VulnHub |
| **crackmes.one** | Reverse engineering challenges | Email only | crackmes.one |

### Web Application Security

| Resource | Focus | Account | URL |
|---|---|---|---|
| **OWASP WebGoat** | Comprehensive web vulnerability lessons | None (Docker) | owasp.org/www-project-webgoat |
| **DVWA** | Simple web vulnerability practice | None (Docker) | github.com/digininja/DVWA |
| **OWASP Juice Shop** | Modern web app security | None (Docker) | owasp.org/www-project-juice-shop |
| **PortSwigger Web Academy** | Professional-grade web security labs | Email only | portswigger.net/web-security |

### API Security

| Resource | Focus | Account | URL |
|---|---|---|---|
| **crAPI** | Completely Ridiculous API (vulnerable API) | None (Docker) | github.com/OWASP/crAPI |
| **vAPI** | Vulnerable API practice | None (Docker) | github.com/roottusk/vapi |
| **DVWS** | Damn Vulnerable Web Services | None (Docker) | github.com/snoopysecurity/dvws |

### Network Penetration Testing

| Resource | Focus | Account | URL |
|---|---|---|---|
| **VulnHub** | Full machine compromise VMs | None | vulnhub.com |
| **HackTheBox (free tier)** | Machine exploitation | Email only | hackthebox.com |

### CTF Competitions & Practice

| Resource | Focus | Account | URL |
|---|---|---|---|
| **PicoCTF** | Beginner-friendly CTF | None | picoctf.org |
| **CTFtime** | Live CTF aggregator | Email only | ctftime.org |

### Smart Contract Security

| Resource | Focus | Account | URL |
|---|---|---|---|
| **Ethernaut** | Smart contract security levels (OpenZeppelin) | None (local Foundry) | ethernaut.openzeppelin.com |
| **Damn Vulnerable DeFi** | DeFi-specific security challenges | None (Foundry/Hardhat) | damn vulnerable defi.xyz |
| **CaptureTheEther** | Smart contract CTF | None | capturetheether.com |
| **Paradigm CTF** | Advanced DeFi/crypto security | None (past editions public) | github.com/paradigmxyz/paradigm-ctf |

### AI / ML Security

| Resource | Focus | Account | URL |
|---|---|---|---|
| **Garak** | LLM vulnerability scanner | None (local) | github.com/NVIDIA/garak |
| **PyRIT** | Microsoft AI red team toolkit | None (open source) | github.com/Azure/PyRIT |
| **AI Village CTFs** | AI security challenges | Varies | aivillage.org |

---

## Reference & Documentation (No Login Required)

### Technique References

| Resource | Use | URL |
|---|---|---|
| **GTFOBins** | Linux SUID/sudo privilege escalation paths | gtfo bins.github.io |
| **LOLBAS** | Windows living-off-the-land binaries | lolbas-project.github.io |
| **HackTricks** | Comprehensive pentest technique reference | book.hacktricks.xyz |
| **ExploitDB** | Public exploit database | exploit-db.com |
| **PayloadsAllTheThings** | Payload collection for every attack type | github.com/swisskyrepo/PayloadsAllTheThings |

### Frameworks & Standards

| Resource | Use | URL |
|---|---|---|
| **MITRE ATT&CK** | Adversary tactic and technique mapping | attack.mitre.org |
| **MITRE ATT&CK Navigator** | Visualize and customize ATT&CK matrices | mitre-attack.github.io/attack-navigator |
| **OWASP Top 10** | Web vulnerability classification standard | owasp.org/Top10 |
| **OWASP API Security Top 10** | API vulnerability standard | owasp.org/API-Security |
| **OWASP LLM Top 10** | AI/LLM security risks | owasp.org/www-project-top-10-for-large-language-model-applications |

### Smart Contract Audit Reports

| Organization | Repository | URL |
|---|---|---|
| **Trail of Bits** | Public audit reports | github.com/trailofbits/publications |
| **OpenZeppelin** | Security audits | blog.openzeppelin.com/security-audits |
| **Spearbit** | Portfolio | github.com/spearbit/portfolio |
| **ConsenSys Diligence** | Audit reports | consensys.io/diligence/audits |
| **Cyfrin** | Audit reports | github.com/Cyfrin/audit-reports |

### Smart Contract Learning

| Resource | Use | URL |
|---|---|---|
| **Secureum Bootcamp** | Smart contract security curriculum | secureum.xyz |
| **Ethereum Yellow Paper** | Foundational specification | ethereum.github.io/yellowpaper/paper.pdf |
| **Solcurity** | Solidity security checklist | github.com/transmissions11/solcurity |
| **Solodit** | Audit report aggregator and search | solodit.xyz |

---

## Priority Order: When Time Is Limited

If you can only follow part of this roadmap, this is the correct sequence — each item unlocks the next:

```
 1. Linux (OverTheWire Bandit)
 2. Networking (Wireshark on local VMs)
 3. Cryptography (CryptoPals)
 4. Python security tooling (3 tools built from scratch)
 5. Threat modeling (STRIDE on a simple system)
 6. Web application attacks (PortSwigger + DVWA)
 7. API security (crAPI locally)
 8. One VulnHub machine per week with write-up
 9. Binary exploitation intro (pwn.college)
10. Reverse engineering intro (3 crackmes with Ghidra)
11. Secure code review (Semgrep + manual taint tracing)
12. Smart contract vulnerability classes (Ethernaut + DVDF)
13. Adversarial ML (ART on your own models)
14. Windows & Active Directory attacks (local lab)
15. Cloud misconfigurations (LocalStack)
16. Competitive audit (Code4rena)
17. LLM red-teaming (Garak on Ollama)
18. Portfolio polish + job applications
```

### Time Estimates (If Following Priority Order)

| Item | Duration | Cumulative |
|---|---|---|
| 1–5 | ~3 months | Month 3 |
| 6–11 | ~3 months | Month 6 |
| 12–15 | ~4 months | Month 10 |
| 16–17 | ~2 months | Month 12 |
| 18 | ~1 month | Month 13 |

**Total: ~13 months for core skills** (vs 18 for full roadmap)

---

## Weekly Schedule Template (Phase 3)

| Day | Morning (3h) | Afternoon (3h) |
|---|---|---|
| **Monday** | Track A: Read audit reports | Track A: Code review / Foundry testing |
| **Tuesday** | Track B: Read papers / ART docs | Track B: Implement attacks on SENTINEL |
| **Wednesday** | Track C: Terraform / LocalStack | Track C: Kubernetes labs |
| **Thursday** | Track D: AD attack practice | Track D: Tool mastery / automation |
| **Friday** | CTF or competitive audit | Write-up documentation |
| **Saturday** | Deep work: whichever track needs it | Continue deep work |
| **Sunday** | Weekly review | GitHub updates, blog notes |

---

## Resource Evaluation Criteria

When adding new resources to your study plan, verify:

- [ ] **Free** — no payment required for core content
- [ ] **No KYC** — no government ID or real name required
- [ ] **Hands-on** — you do something, not just read
- [ ] **Locally runnable** — no mandatory cloud services
- [ ] **Active** — maintained within the last 2 years
- [ ] **Documented** — clear instructions or community support

---

## Community & Support

### Discord Servers (All Free, Email-Only Registration)

| Server | Best For |
|---|---|
| **Secureum** | Smart contract security questions, audit discussions |
| **Trail of Bits** | General security research, tool discussions |
| **DeFi Security Summit** | Web3 security networking |
| **Blue Team Labs** | Defensive security, SIEM, detection engineering |
| **Hack The Box** | CTF team building, machine discussions |

### Reddit Communities

- r/netsec — general security news and discussion
- r/securityCTF — CTF announcements and write-ups
- r/web3security — smart contract security
- r/LocalLLaMA — local AI/LLM deployment

---

**Back to index:** [ROADMAP-INDEX.md](ROADMAP-INDEX.md)

---

*v2 — Local-first · Free · No KYC · No Subscriptions*
