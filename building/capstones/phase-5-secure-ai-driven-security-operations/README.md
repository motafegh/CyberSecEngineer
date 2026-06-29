# Capstone: Phase 5 — Secure AI-Driven Security Operations Prototype

> Capstone work for Phase 5. See `Roadmap/PHASE-5-AI-SECURITY-AI-DRIVEN-DEFENSE.md` §11 and `Roadmap/CAPSTONE-INDEX.md` for the spec.

## Required System

- [ ] Log ingestion
- [ ] Detection or anomaly logic
- [ ] LLM-assisted alert explanation
- [ ] Evidence links
- [ ] Human approval gate
- [ ] Guardrail policy
- [ ] Prompt/output/tool logs
- [ ] Evaluation set
- [ ] False positive/false negative tracking

## Required Security Assessment

- [ ] AI system architecture diagram
- [ ] Threat model
- [ ] Prompt injection tests
- [ ] RAG poisoning tests if RAG is used
- [ ] Model supply chain review
- [ ] Tool abuse tests if tools are used
- [ ] Privacy risk review
- [ ] Incident runbook
- [ ] ADRs

## Layout (suggested)

```
phase-5-secure-ai-driven-security-operations/
├── README.md (this file)
├── ingest/                  # log collection
├── detection/               # anomaly / rule logic
├── llm-triage/              # LLM-assisted explanation
├── evaluation/              # test sets, FP/FN tracking
├── architecture/
├── threat-model.md
├── adrs/
└── reports/
    └── security-assessment.md
```

## Status

Not started. Lab extension for the AI security zone happens via the Lab Extension Protocol before this capstone begins.
