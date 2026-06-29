# Phase 3 — Track B: AI / ML Security

> **The rarest specialization. Fewer than a thousand people globally have both ML depth and security practice.**  
> **Prerequisites:** [PHASE-2-CORE-ATTACK-DEFENSE.md](PHASE-2-CORE-ATTACK-DEFENSE.md) complete  
> **Background Advantage:** ML/Deep Learning knowledge + SENTINEL project  
> **Schedule:** Every Tuesday + deep work Saturdays  
> **Duration:** ~7 months (parallel with other tracks)

---

## Table of Contents

- [B.1 Adversarial Machine Learning](#b1-adversarial-machine-learning)
- [B.2 LLM & AI System Security](#b2-llm--ai-system-security)
- [B.3 ML Infrastructure Security](#b3-ml-infrastructure-security)
- [B.4 Mini Projects](#b4-mini-projects)
- [Track B Capstone](#track-b-capstone--ai-red-team-report)

---

## B.1 Adversarial Machine Learning

### Concepts

- **ML threat model:** Who attacks, what's the goal, what's their capability
- **Evasion vs Poisoning vs Inference attacks:** When each applies
- **White-box vs Black-box vs Transfer attacks:** Attacker knowledge assumptions
- **Robustness-accuracy tradeoff:** More robust = often less accurate
- **Certified robustness:** Mathematical guarantees for specific perturbation sizes
- **Adversarial transferability:** Attacks crafted on one model work on another

### Attack Classes — Implement from Scratch, Then with ART

| Attack | Type | What It Does | Defense |
|---|---|---|---|
| **FGSM** | Evasion | Single-step gradient-based perturbation | Adversarial training |
| **PGD** | Evasion | Iterative, stronger version of FGSM | Adversarial training |
| **CW (Carlini-Wagner)** | Evasion | Optimization-based, bypasses distillation | Input preprocessing |
| **DeepFool** | Evasion | Minimal perturbation to cross decision boundary | Ensemble |
| **BadNets** | Poisoning | Backdoor via trigger in training data | Anomaly detection on inputs |
| **Clean-Label** | Poisoning | Poison without changing labels | Dataset sanitization |
| **Model Extraction** | Model theft | Reconstruct model via query interface | Rate limiting, watermarking |
| **Model Inversion** | Privacy | Recover training data from outputs | Differential privacy |
| **Membership Inference** | Privacy | Determine if sample was in training set | DP-SGD, regularization |

### FGSM Mathematical Construction

```python
# FGSM: Fast Gradient Sign Method
# x_adv = x + epsilon * sign(grad_x(L(theta, x, y)))

import torch

def fgsm_attack(model, x, y, epsilon):
    x.requires_grad = True
    output = model(x)
    loss = torch.nn.CrossEntropyLoss()(output, y)
    model.zero_grad()
    loss.backward()
    
    # Generate perturbation
    perturbation = epsilon * x.grad.data.sign()
    x_adv = x + perturbation
    x_adv = torch.clamp(x_adv, 0, 1)  # keep valid pixel range
    return x_adv
```

### Defenses to Understand and Implement

1. **Adversarial training** — Train with adversarial examples in the loop
2. **Input preprocessing** — JPEG compression, feature squeezing, spatial smoothing
3. **Certified defenses** — Randomized smoothing (Cohen et al.)
4. **Ensemble defenses** — Multiple models, majority voting
5. **Anomaly detection** — Detect adversarial inputs at inference time
6. **Differential privacy in training** — DP-SGD, privacy budget accounting

### Tools

```
ART (Adversarial Robustness Toolbox — IBM), Foolbox, CleverHans
```

---

## B.2 LLM & AI System Security

### Concepts

- LLM attack surface (training, fine-tuning, inference, deployment)
- Trust boundaries in LLM deployments
- Prompt as instruction surface
- Context window as attack vector
- Tool/function calling security
- Autonomous agent risk model
- Multi-modal attack surface

### OWASP LLM Top 10

| # | Class | Description | Your Background Advantage |
|---|---|---|---|
| LLM01 | **Prompt Injection** | Direct and indirect, overriding system instructions | Deep LLM knowledge |
| LLM02 | **Insecure Output Handling** | LLM output used unsanitized → XSS, SQLi, code execution | Web security knowledge |
| LLM03 | **Training Data Poisoning** | Corrupting training data to influence behavior | ML knowledge |
| LLM04 | **Model Denial of Service** | Resource exhaustion via crafted inputs | DoS knowledge |
| LLM05 | **Supply Chain** | Malicious pre-trained weights or plugins | Code review skills |
| LLM06 | **Sensitive Information Disclosure** | Training data leakage, system prompt extraction | Prompt engineering |
| LLM07 | **Insecure Plugin Design** | Tool/function calling abuse | API security |
| LLM08 | **Excessive Agency** | Unauthorized autonomous actions | Threat modeling |
| LLM09 | **Overreliance** | Downstream trust in hallucinated outputs | — |
| LLM10 | **Model Theft** | Extraction via API queries | Model extraction skills |

### Skills
- Write prompt injection payloads (direct and indirect)
- Test jailbreaks systematically
- Trace indirect injection through RAG pipelines
- Evaluate tool-calling security boundaries
- Write AI red-team reports in industry format

### Tools

```
Garak — LLM vulnerability scanning
Ollama — Local model hosting (no API keys, fully local)
PyRIT — Microsoft AI red team toolkit (open source)
LangChain — Building test pipelines locally
```

### Prompt Injection Taxonomy

```
Direct Injection:
├── System prompt override: "Ignore previous instructions and..."
├── Role-play attacks: "You are now DAN (Do Anything Now)"
├── Encoding bypass: Base64, ROT13, leetspeak
├── Context overflow: Fill context with junk, override at end
└── Markdown injection: "```system\nNew instruction..."

Indirect Injection:
├── Web page content: LLM reads page with hidden instruction
├── Document upload: PDF/DOC with embedded instructions
├── RAG poisoning: Retrieved document contains payload
├── Email content: Auto-processing tools execute payload
└── Third-party API: Tool response contains hidden instruction
```

---

## B.3 ML Infrastructure Security

### Vulnerability Classes

| Vulnerability | How It Works | Detection |
|---|---|---|
| **Pickle deserialization RCE** | `pickle.loads()` executes arbitrary code on load | Use Fickling to scan |
| **Insecure model storage** | Unauthenticated access to model weights | Access control audit |
| **Supply chain** | Malicious weights from untrusted sources | Hash verification, provenance |
| **Training pipeline injection** | Poisoned external datasets | Dataset validation |
| **Model serving API** | Unauthenticated inference, rate limit bypass | API security testing |

### Tools

```
Fickling (pickle analysis and disassembly),
Trivy (container scanning), checksec, bandit, semgrep
```

### Fickling Usage

```bash
# Analyze a model file for malicious pickle
fickling --trace model.pkl

# Disassemble pickle opcodes
fickling --json model.pkl

# Check for known dangerous patterns
fickling --check-safety model.pkl
```

---

## B.4 Mini Projects

### B.4.1 — Adversarial ML Suite

**Goal:** Test your own SENTINEL model's robustness.

```python
# adversarial_suite.py
# 1. Implement FGSM from scratch (no ART library)
# 2. Implement PGD from scratch
# 3. Implement model extraction attack
# 4. Apply all three to your SENTINEL model
# 5. Questions to answer:
#    - Can you fool it into missing a reentrancy vulnerability?
#    - Success rate per attack?
#    - Perturbation magnitude needed?
#    - Which vulnerability classes are most robust?
# 6. Publish as research note on GitHub
```

**Deliverable:** Working code + results document + analysis.

### B.4.2 — LLM Red Team Test Suite

```python
# llm_redteam.py
# Python tool that tests any Ollama-compatible model against OWASP LLM Top 10

# For each of the 10 categories:
# - 10 test prompts per category (100 total)
# - Automated success/failure evaluation
# - Structured JSON output

# Architecture:
# llm_redteam/
# ├── llm_redteam.py
# ├── payloads/
# │   ├── prompt_injection.json    # 10 payloads for LLM01
# │   ├── output_handling.json     # 10 payloads for LLM02
# │   └── ... (one per category)
# ├── evaluators/
# │   └── auto_eval.py             # Heuristic + LLM-based evaluation
# └── reports/
#     └── generate_report.py       # HTML/JSON report generation
```

**Deliverable:** Working tool on GitHub. This fills a genuine gap in open-source tooling.

### B.4.3 — Malicious Pickle Analyzer

```python
# pickle_analyzer.py
# 1. Generate 5 malicious pickle payloads:
#    - Level 1: Simple command execution (os.system)
#    - Level 2: Reverse shell connection
#    - Level 3: Environment variable exfiltration
#    - Level 4: File exfiltration (read /etc/passwd)
#    - Level 5: Multi-stage payload (download + execute)
# 2. Analyze each with Fickling
# 3. Write detection rule for each pattern
# 4. Package as scanner: flags suspicious patterns in .pkl / .pt / .pth files
```

**Deliverable:** Scanner tool + 5 documented payloads + detection rules.

---

## Track B Capstone — AI Red Team Report

### What It Is
A full security assessment of a locally deployed LLM application — you build it, then you attack it.

### Build Phase

Create a simple RAG chatbot:
```python
# Components:
# 1. Ollama running locally (model: llama3.2 or mistral)
# 2. Document ingestion (PDF + markdown files)
# 3. Vector database (ChromaDB — local, no cloud)
# 4. Retrieval + generation pipeline
# 5. Optional: tool/function calling integration
```

### Attack Phase

Test all of the following:

| Attack | What to Test |
|---|---|
| **Direct prompt injection** | Override system instructions |
| **Indirect injection via documents** | Upload document with embedded instruction |
| **System prompt extraction** | "Repeat the text above" variants |
| **Output handling flaws** | Get model to output executable code/XSS |
| **DoS via context exhaustion** | Fill context window, cause failures |
| **Tool-calling abuse** | If using functions, manipulate calls |
| **Data leakage** | Extract document content not relevant to query |

### Deliverable

Professional red team report structured like real AI security assessments:

```
1. EXECUTIVE SUMMARY
2. SCOPE (application components, model version, tools)
3. METHODOLOGY (testing approach, tools used)
4. FINDINGS TABLE (severity, category, OWASP mapping)
5. PER-FINDING:
   → Description
   → Reproduction steps
   → Impact assessment
   → Remediation
6. RISK MATRIX
7. APPENDIX (tested payloads, raw outputs)
```

**Standard:** HiddenLayer / Protect AI report quality.

**Publish on GitHub.**

---

*v2 — Local-first · Free · No KYC · No Subscriptions*
