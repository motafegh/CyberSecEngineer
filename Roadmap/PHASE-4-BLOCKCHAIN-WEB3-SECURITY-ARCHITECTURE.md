# Phase 4 — Blockchain and Web3 Security Architecture

> Purpose: Move beyond smart contract auditing into blockchain protocol, node, validator, bridge, wallet, governance, and cryptoeconomic security architecture using Rust, Go, Solidity, and secure distributed systems thinking.

---

## 1. Phase Goal

This phase treats blockchain as a secure distributed systems problem. Solidity matters, but blockchain security is not only Solidity. The primary engineering languages are Rust and Go, with Solidity used for Ethereum smart contract security.

**Blockchain:** a distributed ledger where participants agree on ordered state transitions through consensus and cryptographic verification.

---

## 2. Prerequisites

- [ ] Phase 1 cryptography, networking, Go, Rust, and threat modeling.
- [ ] Phase 2 web/API/security engineering and secure code review.
- [ ] Phase 3 distributed systems, service identity, policy, observability, and resilience.

---

## 3. Outcomes

By the end of this phase, you should be able to:

- [ ] Explain blockchain as a distributed system.
- [ ] Build simple blockchain components in Go and/or Rust.
- [ ] Explain peer-to-peer networking and consensus risks.
- [ ] Review smart contracts for vulnerability classes using a real audit toolchain.
- [ ] Threat model bridges, oracles, wallets, validators, and governance.
- [ ] Explain MEV and transaction-ordering risk.
- [ ] Design key management and custody controls.
- [ ] Read and write findings in formal audit report format.
- [ ] Produce a protocol security architecture review.

**MEV — Maximal Extractable Value:** value extracted by reordering, inserting, or censoring blockchain transactions.

---

## 4. Module 4.1 — Blockchain System Model

### Why This Matters

A blockchain is not magic trust. It replaces some trusted parties with cryptography, consensus, incentives, and replicated validation. Each replacement creates new attack surfaces.

### Lab Setup Note

Before this module, apply the Lab Extension Protocol from Phase 0 (Section 6) to build the blockchain development zone.

### Core Concepts

- Blocks
- Transactions
- State transitions
- Accounts and addresses
- Hash-linked data structures
- Merkle trees
- Digital signatures
- Mempools
- Full nodes
- Light clients
- Validators/miners
- Finality

### Hands-On Exercises

- [ ] Hash a sequence of blocks manually with a small script.
- [ ] Build a toy Merkle tree.
- [ ] Sign and verify a toy transaction.
- [ ] Simulate invalid transaction rejection.
- [ ] Draw transaction lifecycle from wallet to finality.
- [ ] Write a trust-boundary diagram for a blockchain node.

### Attack Surface

- Invalid state transitions
- Signature verification bugs
- Weak randomness
- Mempool manipulation
- Node denial of service
- Chain reorganization assumptions

### Defensive Controls

- Deterministic validation
- Signature verification
- Peer reputation controls
- Resource limits
- Finality assumptions
- Monitoring chain events

### Recall Checks

- What does a full node verify?
- What does a signature prove?
- Why does finality matter for security?

---

## 5. Module 4.2 — Go Blockchain and Peer-to-Peer Foundations

### Why This Matters

Go is used heavily in blockchain clients and distributed infrastructure. Building a simple system teaches the security consequences of networking and state replication.

### Hands-On Exercises

- [ ] Build a simple block structure in Go.
- [ ] Add transaction validation.
- [ ] Add a basic peer-to-peer message format.
- [ ] Broadcast blocks between two local nodes.
- [ ] Reject malformed messages.
- [ ] Add request timeouts and message size limits.
- [ ] Log peer events.
- [ ] Simulate a malicious peer sending bad data.

### Mini Project — Go Toy Blockchain Network

Build:

- [ ] Local two- or three-node network
- [ ] Transaction format
- [ ] Block validation
- [ ] Peer message validation
- [ ] Basic fork handling note
- [ ] Attack simulation report

### Security Lessons

- Never trust peers by default.
- Validate every message.
- Bound memory and CPU usage.
- Design logs before incidents.

### Recall Checks

- Why are peer messages untrusted input?
- How can malformed messages become denial of service?
- Why does fork handling affect security?

---

## 6. Module 4.3 — Rust for Blockchain and High-Assurance Components

### Why This Matters

Rust is common in high-assurance blockchain systems and reduces many memory safety risks, but logic bugs still remain.

### Hands-On Exercises

- [ ] Implement transaction validation in Rust.
- [ ] Implement a safe binary parser for a toy block format.
- [ ] Add malformed input tests.
- [ ] Fuzz the parser.
- [ ] Review dependencies.
- [ ] Identify where unsafe code would require special review.

### Mini Project — Rust Block Parser and Validator

Deliver:

- [ ] Parser
- [ ] Validation rules
- [ ] Unit tests
- [ ] Fuzz or property tests
- [ ] Malformed input corpus
- [ ] Security assumptions document

### Recall Checks

- What security risks remain even with Rust?
- Why is parsing dangerous?
- Why is fuzzing useful for blockchain clients?

---

## 7. Module 4.4 — Consensus and Validator Security

### Why This Matters

Consensus is the mechanism that lets distributed participants agree. Attacks often target assumptions around network partitions, validator incentives, equivocation, and key compromise.

### Core Concepts

- Proof of Work
- Proof of Stake
- Byzantine fault tolerance
- Leader/proposer selection
- Validator keys
- Slashing
- Finality
- Network partitions
- Long-range attacks concept
- Client diversity

### Hands-On Exercises

- [ ] Simulate majority voting consensus.
- [ ] Simulate a network partition.
- [ ] Simulate equivocation in a toy model.
- [ ] Document validator key lifecycle.
- [ ] Write a validator hardening checklist.
- [ ] Design monitoring for missed blocks or suspicious behavior.

### Attack Surface

- Validator key theft
- Double signing
- Denial of service against validators
- Centralized validator infrastructure
- Consensus client bugs
- Poor monitoring

### Defensive Controls

- Key isolation
- Remote signing
- Slashing protection
- Redundant monitoring
- Client diversity
- Network hardening
- Incident runbooks

### Recall Checks

- What is Byzantine behavior?
- Why is validator key management critical?
- How does slashing change security incentives?

---

## 8. Module 4.5 — Smart Contract Security with Solidity

### Why This Matters

Smart contracts hold value and encode irreversible logic. Solidity remains essential for Ethereum and Decentralized Finance security.

**DeFi — Decentralized Finance:** financial applications built on blockchain smart contracts without traditional intermediaries.

### Core Vulnerability Classes

- Reentrancy
- Access control failures
- Oracle manipulation
- Flash loan abuse
- Integer and precision bugs
- Denial of service
- Signature replay
- Front-running and MEV
- Delegatecall and proxy risks
- Initialization flaws
- Business logic errors

### Hands-On Exercises

For each important vulnerability class:

- [ ] Write or study a vulnerable contract.
- [ ] Write an exploit test.
- [ ] Explain root cause.
- [ ] Write a fixed version.
- [ ] Test the fix.
- [ ] Write detection/audit checklist item.
- [ ] Write architecture lesson.

### Audit Toolchain

Vulnerability classes only become an audit practice once paired with the toolchain real auditors use.

- **Foundry/Forge** — primary testing and exploit-writing framework for Solidity.
- **Slither** — primary static analyzer for fast, automated vulnerability class detection.
- **Echidna** — property-based fuzzer for invariant testing.
- **Mythril / Semgrep-for-Solidity** — supplemental symbolic execution and pattern-based analysis.

> **Audit Workflow Note:** Slither moves from a general code-quality signal into the primary first-pass tool of a real audit workflow: run Slither first to triage vulnerability classes, then write Foundry/Forge exploit tests to prove or disprove exploitability, then use Echidna to test invariants Slither cannot reason about (e.g., economic invariants across multiple calls).

Hands-On Exercises:

- [ ] Set up Foundry (`forge init`) for the vulnerable contract set already built in this module.
- [ ] Run Slither against each vulnerable contract and record every flagged finding, including false positives.
- [ ] Write a Foundry/Forge exploit test that proves exploitability for at least three vulnerability classes from this module.
- [ ] Write an Echidna property test for one invariant (e.g., total supply conservation) and demonstrate it failing against a vulnerable contract.
- [ ] Run Mythril or a Semgrep Solidity ruleset against the same contracts and compare findings against Slither's output.
- [ ] Document, for each tool, what it caught, what it missed, and why.

### Mini Project — Smart Contract Exploit/Fix Library

Deliver:

- [ ] Vulnerable contracts
- [ ] Exploit tests
- [ ] Fixed contracts
- [ ] Fix validation tests
- [ ] Audit notes
- [ ] Severity explanations
- [ ] Tool output (Slither, Foundry/Forge, Echidna, and Mythril/Semgrep) per vulnerability class

### Recall Checks

- Why does reentrancy happen?
- Why are oracle spot prices dangerous?
- Why are proxy initializers risky?
- Why does Slither alone not replace a Foundry exploit test?
- Why is an invariant test (Echidna) able to catch bugs that a single-transaction exploit test cannot?

---

## 9. Module 4.5b — Audit Report Reading and Competitive Audit Practice

### Why This Matters

Synthetic labs teach mechanism. Real audit reports teach pattern recognition at the speed and ambiguity of production code. For the Smart Contract Auditor path, reading Code4rena, Sherlock, and Immunefi reports — and eventually competing in a live contest — is primary training material, not supplementary reading.

### Core Concepts

- Audit report structure (severity classification, finding description, proof of concept, recommendation)
- Severity classification systems (Critical/High/Medium/Low, or contest-specific scales)
- Competitive audit platforms: Code4rena, Sherlock, Immunefi
- Finding methodology: how experienced auditors search for a vulnerability class
- Duplicate/unique finding judging in contest formats

### Hands-On Exercises

- [ ] Read 5–10 real audit reports spanning at least four different vulnerability classes covered in Module 4.5.
- [ ] For each report, extract: vulnerability class, root cause, exploit path, fix, and severity rationale.
- [ ] Pick one finding and reproduce the vulnerability in a local Foundry project, independent of the original report's code where possible.
- [ ] Write your own finding in formal audit report format (title, severity, description, impact, proof of concept, recommendation) for one bug you found in this phase's exercises.
- [ ] Register for one live or archived contest on Code4rena or Sherlock and submit at least one finding, even if it does not place.
- [ ] After the contest closes, compare your submitted findings against the judged findings and log what you missed.

### Recall Checks

- Why does reading real audit reports teach pattern recognition faster than synthetic labs alone?
- What makes a finding "Critical" rather than "Medium" in most severity frameworks?
- Why is participating in a real contest a stronger validation signal than completing a synthetic lab?

### Exit Criteria

- [ ] At least 5 real audit reports read and logged with extracted methodology notes.
- [ ] One original finding written in formal audit report format.
- [ ] One contest entry submitted (Code4rena or Sherlock).
- [ ] Post-contest review completed, with gaps logged into the mistake log.

---

## 10. Module 4.6 — Oracles, Bridges, and Cross-Chain Trust

### Why This Matters

Many of the largest losses happen where blockchain systems trust external data or other chains.

### Core Concepts

- Oracle trust model
- Price feeds
- Time-weighted average price
- Bridge lock/mint model
- Light-client bridges
- Multisig bridges
- Relayers
- Message verification
- Cross-chain replay
- Finality mismatch

### Hands-On Exercises

- [ ] Manipulate a toy oracle price in a local lab.
- [ ] Compare spot price and time-weighted price assumptions.
- [ ] Draw a bridge trust model.
- [ ] Identify trusted relayers/signers.
- [ ] Simulate message replay in a toy bridge.
- [ ] Write bridge risk register.

### Attack Surface

- Oracle manipulation
- Compromised bridge signers
- Weak message verification
- Replay attacks
- Finality mismatch
- Centralized upgrade keys

### Defensive Controls

- Multiple oracle sources
- Time-weighted prices
- Circuit breakers
- Light-client verification where feasible
- Signer decentralization
- Replay protection
- Monitoring abnormal flows

### Mini Project — Bridge Threat Model

Deliver:

- [ ] System diagram
- [ ] Trust assumptions
- [ ] Threat table
- [ ] Attack paths
- [ ] Controls
- [ ] Residual risk
- [ ] Architecture recommendations

### Recall Checks

- Why are bridges high-risk?
- What does an oracle actually trust?
- Why does finality mismatch matter?

---

## 11. Module 4.7 — Wallet, Custody, and Key Management Architecture

### Why This Matters

In blockchain systems, key compromise often equals asset loss or protocol control loss.

### Core Concepts

- Seed phrases
- Private keys
- Hardware wallets
- Multisignature wallets
- Threshold signatures
- Hot/warm/cold wallets
- Key rotation
- Recovery
- Governance keys
- Upgrade keys
- Operational signing policies

### Hands-On Exercises

- [ ] Draw a wallet trust model.
- [ ] Compare hot, warm, and cold wallet risk.
- [ ] Design a multisig policy for treasury operations.
- [ ] Write an incident runbook for signer compromise.
- [ ] Review a fake key management failure scenario.

### Defensive Controls

- Least privilege keys
- Multisig
- Threshold signing
- Hardware-backed keys
- Separation of duties
- Transaction simulation
- Signing policies
- Emergency pause controls with governance safeguards

### Recall Checks

- Why is key management architecture security-critical?
- What are the tradeoffs of emergency pause controls?
- Why should upgrade keys be treated as high risk?

---

## 12. Module 4.8 — MEV, Mempool, and Transaction Ordering Risk

### Why This Matters

Transaction ordering can create economic attacks even when code behaves as written.

### Core Concepts

- Public mempool
- Front-running
- Back-running
- Sandwich attacks
- Private order flow
- Commit-reveal
- Batch auctions
- Slippage
- Liquidations

### Hands-On Exercises

- [ ] Simulate a sandwich attack in a toy automated market maker.
- [ ] Add slippage protection.
- [ ] Test commit-reveal pattern.
- [ ] Document tradeoffs between privacy and transparency.
- [ ] Write detection ideas for abnormal ordering behavior.

### Defensive Controls

- Slippage limits
- Commit-reveal
- Batch auctions
- Private transaction submission
- Oracle design
- Monitoring abnormal price impact

### Recall Checks

- Why does public transaction visibility create risk?
- What does commit-reveal protect against?
- Why is MEV not always a code bug?

---

## 13. Module 4.9 — Governance and Cryptoeconomic Security

### Why This Matters

Protocols can be attacked through voting, incentives, liquidity, bribery, upgrades, or social governance — not only code.

### Core Concepts

- Governance tokens
- Voting power
- Delegation
- Quorum
- Timelocks
- Upgrade governance
- Bribery
- Flash-loan governance attacks
- Economic incentives
- Emergency response

### Hands-On Exercises

- [ ] Model a simple governance vote.
- [ ] Simulate low-quorum takeover.
- [ ] Add timelock controls.
- [ ] Analyze emergency upgrade tradeoffs.
- [ ] Write governance threat model.

### Defensive Controls

- Timelocks
- Quorum design
- Voting delay
- Delegation transparency
- Emergency processes
- Upgrade review
- Economic stress testing

### Recall Checks

- Why can governance be an attack surface?
- What does a timelock protect?
- What risk does emergency governance introduce?

---

## 14. Phase 4 Capstone — Blockchain Security Architecture Review

Build or select a blockchain/Web3 system and produce a complete architecture security review.

Required technical work:

- [ ] Go blockchain or peer-to-peer component.
- [ ] Rust parser/validator or blockchain component.
- [ ] Solidity exploit/fix library subset, with Slither/Foundry/Echidna tool output.
- [ ] Oracle or bridge simulation.
- [ ] Validator/key-management design.
- [ ] MEV or governance risk simulation.

Required artifacts:

- [ ] System context diagram
- [ ] Protocol/component diagram
- [ ] Trust boundary diagram
- [ ] Threat model
- [ ] Risk register
- [ ] Key management architecture
- [ ] Attack simulation report
- [ ] Detection/monitoring plan
- [ ] Architecture recommendations
- [ ] ADRs

---

## 15. Recall and Interleaving Plan

Mix concepts:

- Distributed systems consensus + blockchain consensus
- Cryptographic signatures + wallet custody
- API security + blockchain node RPC security
- Zero Trust service identity + validator identity
- Detection engineering + protocol monitoring
- Rust memory safety + blockchain parsing
- Audit report findings + Module 2.4 secure code review methodology

Teach-back prompts:

- [ ] Explain how a transaction becomes final.
- [ ] Explain a bridge trust model.
- [ ] Explain why key compromise can equal protocol compromise.
- [ ] Explain one smart contract bug as an architecture failure.
- [ ] Explain how a real audit report's finding methodology differs from a synthetic lab exercise.

---

## 16. Phase 4 Exit Criteria

- [ ] Go blockchain/networking exercises completed.
- [ ] Rust blockchain/security exercises completed.
- [ ] Smart contract exploit/fix exercises completed with full audit toolchain output.
- [ ] Audit report reading and competitive audit practice completed.
- [ ] Bridge/oracle threat model completed.
- [ ] Validator/key management architecture completed.
- [ ] MEV/governance exercises completed.
- [ ] Phase 4 capstone completed.
- [ ] Recall checks passed without notes.
- [ ] Mistake log updated.

### Validation (External Calibration — Optional)

Not required to complete the phase, but a useful calibration checkpoint before moving on:

- [ ] Code4rena and Sherlock contest participation for smart contract auditing.