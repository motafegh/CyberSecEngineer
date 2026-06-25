# Phase 4 — Portfolio & Job Hunt (Months 14–18)

> **Everything built in previous phases comes together here.**  
> **Prerequisites:** All Phase 3 tracks substantially complete  
> **Goal:** First AI/ML/LLM/Security role

---

## Table of Contents

- [4.1 Portfolio Requirements](#41-portfolio-requirements-before-applying)
- [4.2 Visibility Strategy](#42-visibility-no-kyc)
- [4.3 Target Roles](#43-target-roles-by-fit)
- [4.4 Target Employers](#44-target-employers-for-your-profile)
- [4.5 Interview Preparation](#45-interview-preparation-by-role)
- [Job Hunt Checklist](#job-hunt-checklist)

---

## 4.1 Portfolio Requirements Before Applying

### GitHub (Your Primary Resume)

| Requirement | How to Achieve |
|---|---|
| **12+ months of consistent commits** | Weekly commits from Phase 1 onward |
| **Professional README on every repo** | What it does, why it matters, how to use it, results/metrics |
| **6 pinned repos on profile** | Your best work across different skill areas |

### Required Portfolio Pieces

| # | Piece | From Phase | Where |
|---|---|---|---|
| 1 | **SENTINEL** | Track B (extended) | GitHub repo with benchmarks, architecture diagram |
| 2 | **Phase 2 Capstone** | Phase 2 | GitHub PDF — professional pentest report |
| 3 | **Track A Audit Report** | Track A | GitHub — self-directed protocol audit |
| 4 | **Track B AI Red Team Report** | Track B | GitHub + LLM test suite tool |
| 5 | **Track C Cloud Assessment** | Track C | GitHub + misconfiguration lab |
| 6 | **Track D AD Attack Chain** | Track D | GitHub — full AD compromise report |
| 7 | **CTF Write-ups** | All phases | 10+ detailed write-ups |
| 8 | **Technical Blog Posts** | Ongoing | 2+ original posts |

### README Template for Each Repo

```markdown
# Project Name

One-sentence description of what this does and why it matters.

## What It Does
- Feature 1: description
- Feature 2: description

## Results / Metrics
- Found X vulnerabilities
- Achieved Y% accuracy
- Detected Z attack patterns

## How to Use
```bash
# Installation
pip install -r requirements.txt

# Usage
python tool.py --target example.com
```

## Architecture
[Diagram or description]

## What I Learned
[Key takeaways from building this]

## Blog Post / Report
[Link to detailed write-up if applicable]
```

---

## 4.2 Visibility (No KYC)

| Platform | Purpose | Account Needed |
|---|---|---|
| **GitHub** | Consistent public work, primary portfolio | Email only |
| **Technical Blog** | GitHub Pages or dev.to | Email only |
| **Discord Communities** | Networking, learning, job leads | Email only |

### Recommended Discord Communities

| Community | Focus | Link |
|---|---|---|
| **Secureum** | Smart contract security | discord.gg/secureum |
| **Trail of Bits** | General security research | discord.gg/trailofbits |
| **DeFi Security Summit** | DeFi security | Search Discord |
| **Blue Team Labs** | Defensive security | discord.gg/blueteamlabs |

### Twitter/X Strategy

- Follow security researchers in your target domains
- Engage with research: ask questions, share insights
- Share your write-ups with relevant tags:
  - `#web3security` `#smartcontracts`
  - `#ai #llmsecurity` `#redteam`
  - `#cloudsecurity` `#kubernetes`
  - `#activedirectory` `#pentesting`

### Blog Post Ideas

1. "What I learned auditing my first smart contract"
2. "Red-teaming local LLMs: a practical guide"
3. "Building a cloud security lab with LocalStack (no AWS account needed)"
4. "From zero to Domain Admin: my Active Directory journey"
5. "Adversarial attacks on code analysis models"

---

## 4.3 Target Roles by Fit

| Role | Fit | Why | Primary Evidence |
|---|---|---|---|
| **Smart Contract Auditor** | ★★★★★ | Solidity + SENTINEL + audit reports | Track A capstone, competitive audit submissions |
| **AI/ML Security Engineer** | ★★★★★ | SENTINEL + adversarial ML + LLM red team | Track B capstone, adversarial ML suite |
| **Application Security Engineer** | ★★★★☆ | Web + API + code review + Phase 2 capstone | Web scanner, API tester, code review report |
| **Penetration Tester** | ★★★☆☆ | Phase 2 + AD track — needs more CTF wins | Pentest report, AD attack chain |
| **Cloud Security Engineer** | ★★★☆☆ | Track C — add real cloud cert later if needed | Cloud assessment, IaC scanner, K8s attack chain |
| **Security Engineer (general)** | ★★★★☆ | Broad coverage across all phases | Diverse portfolio spanning all domains |

### How to Choose

**Apply to all 5-star and 4-star fits.** The market will tell you where demand is strongest.

---

## 4.4 Target Employers for Your Profile

### Web3 Security Firms

| Company | Type | Notes |
|---|---|---|
| **Trail of Bits** | Audit firm | Gold standard, hires generalists |
| **Spearbit** | Audit collective | Network of independent auditors |
| **Zellic** | Audit firm | Web3 + traditional security |
| **OpenZeppelin** | Audit + tools | Defender, Contracts library |
| **ConsenSys Diligence** | Audit firm | Ethereum-native |
| **Ackee Blockchain** | Audit firm | Prague-based, growing |
| **Certora** | Formal verification | Prover-based, math-heavy |

### AI Security Companies

| Company | Focus | Notes |
|---|---|---|
| **HiddenLayer** | AI/ML security | AISec platform, great for your profile |
| **Protect AI** | AI/ML security | Open-source tools (Guardrails) |
| **Robust Intelligence** | AI risk management | Enterprise-focused |
| **Adversa AI** | AI red teaming | Research-heavy |

### AI Labs (Red Team Roles)

| Company | Notes |
|---|---|
| **OpenAI** | Preparedness team, red team contracts |
| **Anthropic** | Safety research, red teaming |
| **Google DeepMind** | Safety and alignment |
| **Mistral AI** | European, growing fast |

### Security-Forward Startups

- Companies building in AI or Web3 with internal security teams
- Often more flexible on "years of experience" if portfolio is strong
- Check: a16z portfolio, Y Combinator security companies, AngelList

---

## 4.5 Interview Preparation by Role

### Smart Contract Auditor

**Questions to prepare for:**

| Question | Key Points in Answer |
|---|---|
| Explain reentrancy and all its variants | Classic, cross-function, read-only, cross-contract. Emphasize checks-effects-interactions |
| Walk through a flash loan attack | Borrow → manipulate price → trigger action → repay, all atomic |
| Delegatecall vs call | Delegatecall runs in caller's context, access to storage. Proxy pattern use cases |
| Checks-effects-interactions pattern | State changes before external calls, prevents reentrancy |
| Live code review | Start with access control, then external calls, then input validation |
| What do you look at first in a new codebase | Access control → external calls → fund flow → input validation → oracle usage |

### AI/ML Security Engineer

**Questions to prepare for:**

| Question | Key Points in Answer |
|---|---|
| How is FGSM constructed mathematically | `x_adv = x + epsilon * sign(grad_x(L(theta, x, y)))` — gradient ascent on loss |
| Indirect vs direct prompt injection | Direct: user input. Indirect: via RAG/retrieved content. Indirect is harder to detect |
| Red-teaming an LLM with RAG | Test direct injection, indirect via documents, system prompt extraction, tool abuse |
| Model extraction and detection | Query-based reconstruction. Detect via: rate limiting, watermarking, query pattern analysis |
| Pickle deserialization RCE | `pickle.loads()` executes `__reduce__`. Arbitrary code. Use Fickling to scan |
| Adversarial training vs certified robustness | AT: empirical, no guarantees. CR: mathematical bounds (randomized smoothing) |

### Application Security Engineer

**Questions to prepare for:**

| Question | Key Points in Answer |
|---|---|
| SSRF in cloud environments | Metadata endpoint (169.254.169.254), internal services, protocol smuggling |
| Stored vs DOM XSS | Stored: server persists payload. DOM: client-side JavaScript processes it. Different fixes |
| Code review of unfamiliar codebase | Start with entry points → data flow → sinks → auth checks → dependencies |
| CSRF and SameSite=Lax | Lax blocks cross-site POST but not GET. Doesn't protect if attacker uses GET requests |
| Triaging a security alert | Confirm true positive → assess scope → contain → remediate → document |

### General Security Engineering

**Questions to prepare for:**

| Question | Key Points in Answer |
|---|---|
| TLS handshake end-to-end | ClientHello → ServerHello + cert → KeyExchange → Finished → Application data |
| Authentication vs authorization | AuthN = prove who you are. AuthZ = what you're allowed to do |
| SQL injection prevention | Parameterized queries/prepared statements. Never concatenate user input |
| Investigating compromised Linux server | Preserve evidence → check running processes → network connections → logs → timeline |
| Prioritizing pentest findings | CVSS base + business context + exploitability + asset value |

---

## Job Hunt Checklist

### Before Applying
- [ ] 6 repos pinned on GitHub, all with professional READMEs
- [ ] SENTINEL repo has architecture diagram + benchmark results
- [ ] All 4 capstone reports published
- [ ] 10+ CTF write-ups published
- [ ] 2+ technical blog posts published
- [ ] Resume mentions GitHub profile and key projects
- [ ] LinkedIn updated (if you use it) or personal site ready

### Application Phase
- [ ] Apply to 5 companies per week minimum
- [ ] Customize cover letter per role type
- [ ] Follow up after 1 week if no response
- [ ] Continue building public work while applying
- [ ] Participate in at least 1 competitive audit (Code4rena/Sherlock) while job hunting

### Interview Phase
- [ ] Review all capstone projects — be ready to discuss in detail
- [ ] Practice explaining technical concepts to non-technical people
- [ ] Prepare questions to ask interviewers about their security program
- [ ] Have 3 stories ready: a challenge you overcame, a mistake you learned from, a project you're proud of

---

**Prerequisites:** All Phase 3 tracks  
**Back to index:** [ROADMAP-INDEX.md](ROADMAP-INDEX.md)

---

*v2 — Local-first · Free · No KYC · No Subscriptions*
