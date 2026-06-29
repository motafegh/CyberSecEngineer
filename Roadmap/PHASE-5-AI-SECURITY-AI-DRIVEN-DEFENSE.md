# Phase 5 — AI Security and AI-Driven Defense

> Purpose: Secure Artificial Intelligence systems and safely use Artificial Intelligence to improve security operations without creating blind trust in model output.

---

## 1. Phase Goal

This phase has two equal parts:

1. **AI security** — how AI systems fail, leak, get poisoned, get extracted, or get misused.
2. **AI-driven defense** — how AI can assist detection, triage, investigation, and response with guardrails and evaluation.

**AI — Artificial Intelligence:** software systems that perform tasks normally requiring human reasoning, perception, or decision-making.

**ML — Machine Learning:** a subset of AI where models learn patterns from data instead of being directly programmed for every rule.

**LLM — Large Language Model:** a large AI model trained on text/code that predicts and generates language-like output.

---

## 2. Prerequisites

- [ ] Phase 1 Python, cryptography, networking, and threat modeling.
- [ ] Phase 2 web/API security, secure code review, detection, and incident response.
- [ ] Phase 3 distributed systems, identity, policy, and observability.

---

## 3. Outcomes

By the end of this phase, you should be able to:

- [ ] Threat model AI systems.
- [ ] Perform basic adversarial ML exercises.
- [ ] Test LLM applications for prompt injection and data leakage.
- [ ] Secure Retrieval-Augmented Generation pipelines.
- [ ] Review model supply chain risk.
- [ ] Design AI agent guardrails.
- [ ] Build AI-assisted security triage workflows.
- [ ] Evaluate false positives and false negatives.
- [ ] Produce AI red team and AI security architecture reports.

**RAG — Retrieval-Augmented Generation:** an LLM pattern where external documents are retrieved and inserted into model context before answering.

---

## 4. Module 5.1 — AI System Architecture and Threat Modeling

### Why This Matters

AI systems include data, models, prompts, tools, retrieval systems, APIs, users, logs, and deployment infrastructure. Each part has a trust boundary.

### Lab Setup Note

Before this module, apply the Lab Extension Protocol from Phase 0 (Section 6) to build the Artificial Intelligence security zone.

### Core Concepts

- Training data
- Fine-tuning data
- Inference
- Prompts
- Context windows
- Embeddings
- Vector databases
- Retrieval pipelines
- Tool/function calling
- Model serving APIs
- Human feedback
- Evaluation harnesses

### Hands-On Exercises

- [ ] Draw an AI application architecture.
- [ ] Mark trust boundaries.
- [ ] Identify sensitive data.
- [ ] Identify model inputs and outputs.
- [ ] Identify tool/action permissions.
- [ ] Write an AI system threat model.
- [ ] Write one ADR for data handling.

### Attack Surface

- Poisoned data
- Prompt injection
- Sensitive data leakage
- Model extraction
- Tool abuse
- Insecure output handling
- Malicious model files
- Overtrusted AI output

### Defensive Controls

- Data validation
- Prompt/input filtering where useful
- Output handling controls
- Tool permission boundaries
- Human approval
- Model provenance
- Logging and evaluation

### Recall Checks

- Why is an AI system more than a model?
- Where can untrusted data enter a RAG system?
- Why is tool calling high risk?

---

## 5. Module 5.2 — Adversarial Machine Learning

### Why This Matters

ML systems can be fooled, poisoned, stolen, or used to leak information. Even if the final role focuses on architecture, you need practical intuition for these failure modes.

### Module Framing

This module moves quickly through baseline ML mechanics and spends the saved time on the security-specific framing and hands-on attack/defense work. The exercises are designed to be completed against a small model you build locally — start from a clean baseline rather than reusing an existing production architecture, so attack results are not confounded by pre-existing model quirks.

### Core Concepts

- Evasion attacks
- Poisoning attacks
- Backdoors
- Model extraction
- Model inversion
- Membership inference
- White-box attacks
- Black-box attacks
- Transferability
- Robustness tradeoffs

### Hands-On Exercises

- [ ] Build or load a small baseline model (e.g., a compact transformer or MLP on a simple classification task) and document the architecture choice before running attacks against it.
- [ ] Create a simple evasion example.
- [ ] Measure success rate.
- [ ] Perform a basic poisoning experiment and document the attack as a clean data poisoning class exercise (flip a subset of training labels, measure downstream accuracy impact).
- [ ] Demonstrate model extraction concept against a CodeBERT-style classifier.
- [ ] Compare clean and attacked performance.
- [ ] Document defensive options.

### Defensive Controls

- Adversarial training
- Data validation
- Rate limiting model APIs
- Output throttling
- Differential privacy concepts
- Model watermarking concepts
- Monitoring query patterns

### Mini Project — Adversarial ML Lab Report

Deliver:

- [ ] Model description
- [ ] Attack setup
- [ ] Results
- [ ] Defense discussion
- [ ] Limitations
- [ ] Architecture implications

### Recall Checks

- What is the difference between evasion and poisoning?
- Why does model extraction matter for security?
- Why is robustness not free?
- Why is a label-poisoning bug found during ML development the same attack class as a deliberate poisoning attack?

---

## 6. Module 5.3 — LLM Security and Prompt Injection

### Why This Matters

LLM applications interpret text as instructions, context, data, and sometimes tool commands. That ambiguity creates new security problems.

### Core Concepts

- Direct prompt injection
- Indirect prompt injection
- System prompt leakage
- Jailbreaks
- Context poisoning
- Insecure output handling
- Tool-call abuse
- Excessive agency
- Model denial of service
- Overreliance

### Hands-On Exercises

- [ ] Test direct prompt injection on a local/demo app.
- [ ] Test system prompt extraction attempts.
- [ ] Test malicious markdown or hidden instruction patterns.
- [ ] Test output handling risk with generated HTML/code.
- [ ] Test tool-calling abuse in a controlled toy tool.
- [ ] Write safe handling rules for LLM output.
- [ ] Log prompts, outputs, and decisions safely.

### Defensive Controls

- Least privilege tools
- Clear instruction hierarchy
- Input/output validation
- Human approval for high-impact actions
- Retrieval source labeling
- Output escaping
- Prompt and tool telemetry
- Evaluation test suites

### Mini Project — LLM Red Team Suite

Build a local test suite with:

- [ ] Prompt injection payloads
- [ ] Data leakage tests
- [ ] Tool abuse tests
- [ ] Output handling tests
- [ ] Result scoring
- [ ] JSON/HTML report

### Recall Checks

- Why is indirect prompt injection harder than direct prompt injection?
- Why can LLM output become an injection source?
- Why should tools be least privilege?

---

## 7. Module 5.4 — Secure RAG Systems

### Why This Matters

RAG connects LLMs to external documents. Retrieved documents can carry malicious instructions, sensitive data, stale information, or poisoned content.

### Core Concepts

- Document ingestion
- Chunking
- Embeddings
- Vector search
- Retrieval ranking
- Context construction
- Source attribution
- Access-controlled retrieval
- Data poisoning
- Prompt injection through documents

### Hands-On Exercises

- [ ] Build a small local RAG application.
- [ ] Ingest harmless documents.
- [ ] Add a malicious document with hidden instructions.
- [ ] Observe model behavior.
- [ ] Add source labeling.
- [ ] Add access filtering.
- [ ] Add output citation requirements.
- [ ] Add retrieval logging.
- [ ] Threat model the RAG pipeline.

### Defensive Controls

- Document provenance
- Access-controlled indexes
- Source isolation
- Content sanitization where appropriate
- Retrieval logging
- Citation requirements
- Human review for sensitive answers
- Evaluation datasets

### Mini Project — Secure RAG Assessment

Deliver:

- [ ] RAG architecture diagram
- [ ] Attack tests
- [ ] Defense changes
- [ ] Evaluation results
- [ ] Residual risk
- [ ] ADR for retrieval access control

### Recall Checks

- Why is retrieved text untrusted input?
- Why does access control belong in retrieval?
- Why are citations not a complete security control?

---

## 8. Module 5.5 — Model Supply Chain and ML Infrastructure Security

### Why This Matters

Models, datasets, notebooks, pipelines, and serialized files can carry malicious code or poisoned behavior.

### Core Concepts

- Model provenance
- Dataset provenance
- Pickle deserialization risk
- Model formats
- Dependency risk
- Training pipeline permissions
- Model registry access
- Inference API security
- Containerized model serving

### Hands-On Exercises

- [ ] Analyze a harmless pickle file.
- [ ] Demonstrate why unsafe deserialization is dangerous in a lab.
- [ ] Scan model/project dependencies.
- [ ] Write model provenance metadata.
- [ ] Threat model a model-serving API.
- [ ] Add authentication and rate limiting to a toy inference API.

### Defensive Controls

- Avoid unsafe formats where possible
- Provenance tracking
- Hash verification
- Model registry permissions
- Dependency scanning
- Container scanning
- API authentication and rate limits
- Sandbox untrusted artifacts

### Mini Project — Malicious Model File Analyzer

Build a tool or lab package that:

- [ ] Creates safe demonstration payloads in isolated lab
- [ ] Analyzes serialization behavior
- [ ] Flags suspicious patterns
- [ ] Documents safe model loading guidance

### Recall Checks

- Why is pickle dangerous?
- What does model provenance prove?
- Why is an inference API still an API security problem?

---

## 9. Module 5.6 — AI-Driven Detection and Alert Triage

### Why This Matters

AI can help security teams summarize, correlate, and prioritize alerts, but unvalidated AI decisions can create dangerous automation failures.

### Core Concepts

- Log ingestion
- Alert enrichment
- Anomaly detection
- Triage summaries
- Security Orchestration, Automation, and Response
- Human-in-the-loop decisions
- False positives
- False negatives
- Evaluation datasets
- Guardrails

**SOAR — Security Orchestration, Automation, and Response:** tooling and workflows that coordinate security actions such as enrichment, ticketing, containment, and response.

### Hands-On Exercises

- [ ] Ingest sample logs.
- [ ] Detect simple anomalies.
- [ ] Summarize alerts with an LLM.
- [ ] Compare summary to raw evidence.
- [ ] Require human approval before actions.
- [ ] Track false positives and false negatives.
- [ ] Write a guardrail policy.
- [ ] Log all AI-assisted decisions.

### Defensive Controls

- Human approval for high-impact actions
- Evidence-linked summaries
- Strict action allowlists
- Evaluation metrics
- Prompt/output logging
- Privacy controls
- Rollback plans

### Mini Project — AI Security Triage Assistant

Build a local prototype that:

- [ ] Reads lab logs
- [ ] Groups related events
- [ ] Generates an incident summary
- [ ] Links back to evidence
- [ ] Recommends but does not execute containment
- [ ] Requires human approval
- [ ] Tracks evaluation results

### Recall Checks

- Why should AI not directly execute high-impact security actions by default?
- What is a false negative?
- Why must summaries link to raw evidence?

---

## 10. Module 5.7 — AI Agent Security

### Why This Matters

Agents combine LLM reasoning with tools, memory, and autonomy. This increases impact if compromised or misaligned.

### Core Concepts

- Tool permissions
- Memory
- Planning loops
- Action boundaries
- Prompt injection
- Indirect instruction attacks
- Approval gates
- Sandboxing
- Audit logs
- Kill switches

### Hands-On Exercises

- [ ] Build a toy agent with one harmless tool.
- [ ] Attempt prompt injection against the tool boundary.
- [ ] Add an allowlist.
- [ ] Add human approval.
- [ ] Add action logging.
- [ ] Add a kill switch.
- [ ] Write an agent threat model.

### Defensive Controls

- Least privilege tools
- Strong action schemas
- Human approval
- Sandboxing
- Explicit deny actions
- Audit logs
- Rate limits
- Monitoring

### Recall Checks

- Why do tools increase LLM risk?
- What is excessive agency?
- What should an agent never be allowed to do without approval?

---

## 11. Phase 5 Capstone — Secure AI-Driven Security Operations Prototype

Build a local AI-assisted security operations system.

Required system:

- [ ] Log ingestion
- [ ] Detection or anomaly logic
- [ ] LLM-assisted alert explanation
- [ ] Evidence links
- [ ] Human approval gate
- [ ] Guardrail policy
- [ ] Prompt/output/tool logs
- [ ] Evaluation set
- [ ] False positive/false negative tracking

Required security assessment:

- [ ] AI system architecture diagram
- [ ] Threat model
- [ ] Prompt injection tests
- [ ] RAG poisoning tests if RAG is used
- [ ] Model supply chain review
- [ ] Tool abuse tests if tools are used
- [ ] Privacy risk review
- [ ] Incident runbook
- [ ] ADRs

---

## 12. Recall and Interleaving Plan

Mix concepts:

- RAG access control + API authorization
- Model supply chain + software supply chain
- AI agent tools + Zero Trust least privilege
- Alert triage + detection engineering
- Prompt injection + insecure output handling
- Privacy + logging strategy
- Label poisoning + adversarial ML poisoning attacks

Teach-back prompts:

- [ ] Explain a full RAG attack path.
- [ ] Explain how an AI triage assistant can fail dangerously.
- [ ] Explain why AI output must be treated as untrusted.
- [ ] Explain one safe human-in-the-loop design.
- [ ] Explain how a label-poisoning bug maps onto the data poisoning attack class.

---

## 13. Phase 5 Exit Criteria

- [ ] AI threat modeling exercises completed.
- [ ] Adversarial ML lab completed, with findings documented against the data poisoning, evasion, and extraction attack classes.
- [ ] LLM red team suite completed.
- [ ] Secure RAG assessment completed.
- [ ] Model supply chain exercises completed.
- [ ] AI triage assistant prototype completed.
- [ ] AI agent security exercises completed.
- [ ] Phase 5 capstone completed.
- [ ] Recall checks passed without notes.
- [ ] Mistake log updated.

### Validation (External Calibration — Optional)

Not required to complete the phase, but a useful calibration checkpoint before moving on:

- [ ] AI CTF challenges (HackAPrompt, AI safety CTFs).