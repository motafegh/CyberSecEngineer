# Capstone: Phase 3 — Secure Distributed Zero Trust Platform

> Capstone work for Phase 3. See `Roadmap/PHASE-3-DISTRIBUTED-CLOUD-ZEROTRUST.md` §12 and `Roadmap/CAPSTONE-INDEX.md` for the spec.

## Required System

- [ ] At least three services, preferably in Go
- [ ] Containerized deployment
- [ ] Local Kubernetes deployment
- [ ] Service identities
- [ ] mTLS or equivalent authenticated service communication
- [ ] Policy-as-code authorization
- [ ] Network restrictions
- [ ] Structured logs
- [ ] Metrics and traces
- [ ] Failure simulation
- [ ] Attack simulation

## Required Artifacts

- [ ] System context diagram
- [ ] Component diagram
- [ ] Trust boundary diagram
- [ ] Threat model
- [ ] Risk register
- [ ] ADRs
- [ ] Attack/defense report

## Layout (suggested)

```
phase-3-secure-distributed-zero-trust-platform/
├── README.md (this file)
├── services/               # Go services
├── deploy/                 # K8s manifests, Helm charts
├── policies/               # OPA / Kyverno / Gatekeeper
├── observability/          # OTel, Prometheus, Grafana
├── architecture/
│   ├── context.png
│   ├── component.png
│   └── trust-boundary.png
├── threat-model.md
├── risk-register.md
├── adrs/
└── reports/
    └── attack-defense.md
```

## Status

Not started. Lab extension for the container/Kubernetes zone happens via the Lab Extension Protocol before this capstone begins.
