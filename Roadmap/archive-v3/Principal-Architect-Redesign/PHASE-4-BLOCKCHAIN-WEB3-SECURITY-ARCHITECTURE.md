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
- [ ] Review smart contracts for vulnerability classes.
- [ ] Threat model bridges, oracles, wallets, validators, and governance.
- [ ] Explain MEV and transaction-ordering risk.
- [ ] Design key management and custody controls.
- [ ] Produce a protocol security architecture review.

**MEV — Maximal Extractable Value:** value extracted by reordering, inserting, or censoring blockchain transactions.

---

## 4. Module 4.1 — Blockchain System Model

### Why This Matters

A blockchain is not magic trust. It replaces some trusted parties with cryptography, consensus, incentives, and replicated validation. Each replacement creates new attack surfaces.

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

### Mini Project — Smart Contract Exploit/Fix Library

Deliver:

- [ ] Vulnerable contracts
- [ ] Exploit tests
- [ ] Fixed contracts
- [ ] Fix validation tests
- [ ] Audit notes
- [ ] Severity explanations

### Recall Checks

- Why does reentrancy happen?
- Why are oracle spot prices dangerous?
- Why are proxy initializers risky?

---

## 9. Module 4.6 — Oracles, Bridges, and Cross-Chain Trust

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

## 10. Module 4.7 — Wallet, Custody, and Key Management Architecture

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

## 11. Module 4.8 — MEV, Mempool, and Transaction Ordering Risk

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

## 12. Module 4.9 — Governance and Cryptoeconomic Security

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

## 13. Phase 4 Capstone — Blockchain Security Architecture Review

Build or select a blockchain/Web3 system and produce a complete architecture security review.

Required technical work:

- [ ] Go blockchain or peer-to-peer component.
- [ ] Rust parser/validator or blockchain component.
- [ ] Solidity exploit/fix library subset.
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

## 14. Recall and Interleaving Plan

Mix concepts:

- Distributed systems consensus + blockchain consensus
- Cryptographic signatures + wallet custody
- API security + blockchain node RPC security
- Zero Trust service identity + validator identity
- Detection engineering + protocol monitoring
- Rust memory safety + blockchain parsing

Teach-back prompts:

- [ ] Explain how a transaction becomes final.
- [ ] Explain a bridge trust model.
- [ ] Explain why key compromise can equal protocol compromise.
- [ ] Explain one smart contract bug as an architecture failure.

---

## 15. Phase 4 Exit Criteria

- [ ] Go blockchain/networking exercises completed.
- [ ] Rust blockchain/security exercises completed.
- [ ] Smart contract exploit/fix exercises completed.
- [ ] Bridge/oracle threat model completed.
- [ ] Validator/key management architecture completed.
- [ ] MEV/governance exercises completed.
- [ ] Phase 4 capstone completed.
- [ ] Recall checks passed without notes.
- [ ] Mistake log updated.
