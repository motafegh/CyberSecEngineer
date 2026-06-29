# Phase 3 — Track A: Web3 & Smart Contract Security

> **Your fastest path to income. Solidity background means you're already ahead of most auditors.**  
> **Prerequisites:** [PHASE-2-CORE-ATTACK-DEFENSE.md](PHASE-2-CORE-ATTACK-DEFENSE.md) complete  
> **Schedule:** Every Monday + deep work Saturdays  
> **Duration:** ~7 months (parallel with other tracks)

---

## Table of Contents

- [A.1 Vulnerability Classes](#a1-vulnerability-classes)
- [A.2 Core Concepts](#a2-core-concepts)
- [A.3 Skills to Develop](#a3-skills-to-develop)
- [A.4 Tools](#a4-tools)
- [A.5 Mini Projects](#a5-mini-projects)
- [A.6 CTF Practice](#a6-ctf-practice)
- [A.7 Reading List](#a7-reading-list)
- [Track A Capstone](#track-a-capstone--public-protocol-audit)

---

## A.1 Vulnerability Classes

Master in this order:

| # | Vulnerability | Key Concept |
|---|---|---|
| 1 | **Reentrancy** | State update after external call — classic, cross-function, read-only, cross-contract |
| 2 | **Access Control** | Missing modifiers, `tx.origin` vs `msg.sender`, role confusion |
| 3 | **Integer Overflow/Underflow** | Pre-0.8.0 wrapping, SafeMath, checked arithmetic |
| 4 | **Oracle Manipulation** | Spot price vs TWAP, on-chain vs Chainlink |
| 5 | **Flash Loan Attacks** | Single-transaction fund amplification for price manipulation |
| 6 | **Denial of Service** | Gas griefing, push vs pull payment, unbounded array loops |
| 7 | **Signature Issues** | `ecrecover` misuse, replay attacks, signature malleability, EIP-712 |
| 8 | **Frontrunning / MEV** | Sandwich attacks, commit-reveal schemes |
| 9 | **Delegatecall & Storage Collision** | Proxy pattern risks, unstructured storage |
| 10 | **Randomness Manipulation** | `block.timestamp`, `blockhash` entropy weaknesses |
| 11 | **Improper Initialization** | Uninitialized proxies, constructor vs initializer |
| 12 | **Price Manipulation** | AMM pool ratio abuse, collateral inflation |
| 13 | **Logic & Business Flaws** | Incorrect accounting, rounding errors, invariant violations |

### Detailed Breakdown: Top 5

#### 1. Reentrancy (ALL variants)
```solidity
// VULNERABLE — classic reentrancy
function withdraw() public {
    uint256 amount = balances[msg.sender];
    (bool success, ) = msg.sender.call{value: amount}("");  // external call FIRST
    require(success, "Transfer failed");
    balances[msg.sender] = 0;  // state update AFTER — attacker can re-enter
}

// FIXED — checks-effects-interactions
function withdraw() public {
    uint256 amount = balances[msg.sender];
    require(amount > 0, "No balance");
    balances[msg.sender] = 0;  // effect FIRST
    (bool success, ) = msg.sender.call{value: amount}("");  // interaction LAST
    require(success, "Transfer failed");
}
```

**Variants to master:** Classic, cross-function, read-only (view reentrancy via callbacks), cross-contract.

#### 2. Access Control
- `tx.origin` is NEVER safe for authorization — always use `msg.sender`
- Missing `onlyOwner` / role modifiers
- Incorrect role assignments

#### 3. Integer Overflow/Underflow
- Solidity < 0.8.0: no automatic checks, must use SafeMath
- Solidity >= 0.8.0: checked arithmetic, but unchecked blocks bypass

#### 4. Oracle Manipulation
- AMM spot prices can be manipulated in a single transaction
- Always use TWAP (Time-Weighted Average Price) or Chainlink
- Understand flash loan → price manipulation → liquidation flow

#### 5. Flash Loan Attacks
- Borrow massive funds without collateral
- Manipulate price oracles
- Profit from arbitrage or liquidations
- Repay loan within same transaction (atomic)

---

## A.2 Core Concepts

- **EVM execution model:** Stack machine, gas metering, opcodes
- **Storage layout:** Slots (32 bytes), packing, mapping hash locations
- **Calldata vs Memory vs Storage:** Where data lives, gas costs, security implications
- **Gas mechanics:** Gas limits, griefing, optimization vs security tradeoffs
- **Proxy patterns:** Transparent Proxy, UUPS, Diamond/EIP-2535 — risks of each
- **ABI encoding/decoding:** How function calls are serialized
- **Events:** Their limitations as security signals (logs can be forged)
- **DeFi primitives:** AMMs (Uniswap V2/V3), lending (Aave/Compound), vaults (ERC-4626), staking, bridges
- **Cross-chain bridge security:** The #1 target by value at risk
- **Checks-Effects-Interactions:** The golden rule for reentrancy prevention

---

## A.3 Skills to Develop

1. **Manual Solidity code review** — read line by line, don't trust tools alone
2. **Writing PoC exploit contracts in Foundry** — prove the bug, prove the fix
3. **Running and interpreting static analysis output** — Slither, Echidna, Mythril
4. **Differential analysis** — comparing two contract versions for introduced bugs
5. **Writing formal audit reports** — severity classification, PoC, remediation
6. **Participating in competitive audit contests** — Code4rena, Sherlock, Immunefi

---

## A.4 Tools

| Tool | Purpose | Local? |
|---|---|---|
| **Slither** | Static analysis (vulnerability detection) | Yes |
| **Echidna** | Property-based fuzzing | Yes |
| **Mythril** | Symbolic execution | Yes |
| **Manticore** | Symbolic execution (more complex) | Yes |
| **Foundry** (`forge`, `cast`, `anvil`) | Testing, PoC development, local chain | Yes |
| **Hardhat** | Alternative dev environment | Yes |
| **Remix IDE** | Online IDE (use locally) | Local version available |
| **abi-decompiler** | Reverse ABI from bytecode | Yes |
| **ethervm.io decompiler** | Online decompiler | Web |
| **Tenderly** | Transaction simulation, debugging | Free tier (email) |

---

## A.5 Mini Projects

### A.5.1 — Exploit Library

For each of the 13 vulnerability classes:
1. Write a **vulnerable contract**
2. Write the **exploit contract** (Foundry test)
3. Write a **Foundry test proving the exploit works**
4. Write a **fixed version** of the contract
5. Write a **Foundry test proving the fix holds**

**13 pairs = 26 contracts.** This becomes your permanent reference library.

```solidity
// Example structure for each vulnerability:
// src/vulnerabilities/Vuln01Reentrancy.sol
// src/exploits/Exploit01Reentrancy.sol
// test/Reentrancy.t.sol
// src/fixeds/Fixed01Reentrancy.sol
// test/FixedReentrancy.t.sol
```

### A.5.2 — Custom Slither Detector

1. Identify a pattern not covered by existing Slither detectors
2. Write the detector using Slither's Python API
3. Document: detector logic, AST patterns matched, false positive rate
4. Test on a corpus of contracts

### A.5.3 — SENTINEL Extension

Extend your SENTINEL project with one of:
- Natural language vulnerability explanation (LLM integration)
- Foundry PoC auto-generation for detected findings
- Differential analysis between two contract versions
- Benchmark comparison against Slither + Mythril on a public dataset

---

## A.6 CTF Practice

| Platform | Challenges | Setup | Account |
|---|---|---|---|
| **Ethernaut** | All 25+ levels | Local with Foundry | None |
| **Damn Vulnerable DeFi** | All DeFi challenges | Foundry/Hardhat | None |
| **CaptureTheEther** | All categories | Web3 provider | None |
| **Paradigm CTF** | Past editions (public) | Foundry | None |

### Ethernaut Level Order (suggested)
```
0. Hello → 1. Fallback → 2. Fallout → 3. Coin Flip → 4. Telephone
→ 5. Token → 6. Delegation → 7. Force → 8. Vault → 9. King
→ 10. Re-entrancy → 11. Elevator → 12. Privacy → 13. Gatekeeper One
→ 14. Gatekeeper Two → 15. Naught Coin → 16. Preservation
→ 17. Recovery → 18. MagicNumber → 19. Alien Codex → 20. Denial
→ 21. Shop → 22. Dex → 23. Dex Two → 24. Puzzle Wallet
→ 25. Motorbike → 26. DoubleEntryPoint → 27. Good Samaritan
→ 28. Gatekeeper Three → 29. Switch → 30. Higher Order
→ 31. Stake → 32. Impersonator → 33. Retirement Fund
```

---

## A.7 Reading List

### Real Audit Reports (Free, Public)

Download and study 20+ reports from:
- **Trail of Bits:** https://github.com/trailofbits/publications
- **OpenZeppelin:** https://blog.openzeppelin.com/security-audits
- **Spearbit:** https://github.com/spearbit/portfolio
- **ConsenSys Diligence:** https://consensys.io/diligence/audits

### Curriculum Content
- **Secureum Bootcamp:** https://secureum.xyz/ (substack, free)
- **Ethereum Yellow Paper:** https://ethereum.github.io/yellowpaper/paper.pdf

### Reading Protocol
1. Read the report summary first
2. Read each finding — understand the vulnerability
3. Open the referenced contract code
4. Trace through the exploit path yourself
5. Write a 1-paragraph summary of each finding

---

## Track A Capstone — Public Protocol Audit

### What It Is
A real, formal audit of an open-source DeFi protocol that has not been recently audited.

### Deliverable

Professional audit report (15–20 pages) including:
1. **Scope** — contracts reviewed, commit hash
2. **Executive Summary** — risk profile in plain language
3. **Methodology** — manual review + tool-assisted analysis
4. **Findings Table** — severity (Critical/High/Medium/Low), CVSS, file:line
5. **Per-finding:** description, PoC (Foundry test), fix recommendation
6. **Architectural recommendations** — design-level improvements

### Finding Targets

| Source | How to Search |
|---|---|
| GitHub | Search Solidity repos with no `audit/` folder, sorted by recently updated |
| DeFiLlama | Recent launches with no listed audits |

### Responsible Disclosure

1. Complete your audit
2. Send findings to the protocol team privately (GitHub issue with "security" label, or email)
3. Allow reasonable time for fixes before publishing
4. Publish your report on GitHub (redact sensitive details if requested)

### Where It Goes
- GitHub as your first real-world security contribution
- Linked from your resume
- Mentioned in competitive audit applications

---

*v2 — Local-first · Free · No KYC · No Subscriptions*
