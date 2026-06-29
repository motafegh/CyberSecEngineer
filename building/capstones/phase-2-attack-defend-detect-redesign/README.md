# Capstone: Phase 2 — Attack, Defend, Detect, Redesign

> Capstone work for Phase 2. See `Roadmap/PHASE-2-CORE-SECURITY-ENGINEERING.md` §15 and `Roadmap/CAPSTONE-INDEX.md` for the spec.

## Required Deliverables

- [ ] Architecture diagram
- [ ] Threat model
- [ ] Vulnerability assessment report
- [ ] Exploit proof-of-concepts in isolated lab
- [ ] Secure code/config fixes
- [ ] Regression tests
- [ ] Detection rules
- [ ] Incident timeline
- [ ] Architecture recommendations
- [ ] ADRs for major security decisions

## Layout (suggested)

```
phase-2-attack-defend-detect-redesign/
├── README.md (this file)
├── target-app/             # vulnerable app to attack
├── reports/
│   ├── vulnerability-assessment.md
│   ├── attack-report.md
│   └── incident-timeline.md
├── exploits/               # lab-only PoC, sanitized
├── fixes/                  # patches + tests
├── detections/             # Sigma / Suricata / Wazuh rules
└── adrs/
```

## Status

Not started.
