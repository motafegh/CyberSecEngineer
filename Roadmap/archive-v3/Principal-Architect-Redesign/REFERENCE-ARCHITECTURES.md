# Reference Architectures

> Architecture patterns to build, study, attack, defend, and adapt throughout the roadmap.

---

## 1. Secure Distributed Microservices

Required elements:

- [ ] API gateway or entry service
- [ ] Multiple backend services
- [ ] Service identity
- [ ] Request IDs
- [ ] Structured logs
- [ ] Metrics and traces
- [ ] Central authorization decision
- [ ] Least privilege service permissions

Security questions:

- [ ] What happens if one service is compromised?
- [ ] What identity does each service use?
- [ ] Where is authorization enforced?
- [ ] What logs prove a request path?

---

## 2. Zero Trust Service-to-Service Platform

Required elements:

- [ ] mTLS or equivalent service authentication
- [ ] Deny-by-default access
- [ ] Policy-as-code authorization
- [ ] Microsegmentation
- [ ] Access decision logs
- [ ] Certificate/key rotation plan

Security questions:

- [ ] Which service identity is most dangerous?
- [ ] What is the blast radius of credential theft?
- [ ] How are policies tested?

---

## 3. Secure Kubernetes Platform

Required elements:

- [ ] Namespaces
- [ ] Least privilege RBAC
- [ ] Network policies
- [ ] Pod security controls
- [ ] Admission policies
- [ ] Secret management
- [ ] Audit logging

Security questions:

- [ ] Can a pod access the host?
- [ ] Can a service account read secrets?
- [ ] What alerts show privilege escalation?

---

## 4. Secure Blockchain Node/Validator Architecture

Required elements:

- [ ] Node network boundary
- [ ] Validator key isolation
- [ ] Remote signing or equivalent control where applicable
- [ ] Monitoring for missed blocks/suspicious events
- [ ] Backup and recovery plan
- [ ] Slashing protection plan

Security questions:

- [ ] What happens if a validator key leaks?
- [ ] What happens during network partition?
- [ ] What telemetry proves validator health?

---

## 5. Secure Bridge / Cross-Chain Architecture

Required elements:

- [ ] Source chain verification
- [ ] Destination chain verification
- [ ] Message replay protection
- [ ] Relayer/signer trust model
- [ ] Finality assumptions
- [ ] Emergency controls
- [ ] Monitoring abnormal flows

Security questions:

- [ ] Who can forge or approve messages?
- [ ] What finality assumptions are made?
- [ ] What happens if relayers are compromised?

---

## 6. Secure RAG Application

Required elements:

- [ ] Document provenance
- [ ] Access-controlled retrieval
- [ ] Source labeling
- [ ] Prompt injection tests
- [ ] Output handling controls
- [ ] Prompt/retrieval/tool logs
- [ ] Human review for sensitive actions

Security questions:

- [ ] Can a document override instructions?
- [ ] Can a user retrieve unauthorized content?
- [ ] Are outputs treated as untrusted?

---

## 7. AI-Driven Security Operations

Required elements:

- [ ] Log ingestion
- [ ] Detection logic
- [ ] AI-assisted summarization
- [ ] Evidence links
- [ ] Human approval gates
- [ ] Guardrail policy
- [ ] Evaluation set
- [ ] False positive/false negative tracking

Security questions:

- [ ] Can malicious logs manipulate the AI assistant?
- [ ] Can the AI execute actions directly?
- [ ] How is summary correctness evaluated?

---

## 8. Secure Software Supply Chain

Required elements:

- [ ] Dependency scanning
- [ ] Secret scanning
- [ ] SBOM generation
- [ ] Artifact signing/provenance plan
- [ ] Least privilege CI/CD
- [ ] Container scanning
- [ ] Build isolation

Security questions:

- [ ] What happens if a dependency is compromised?
- [ ] Can build secrets leak?
- [ ] How do we know what was deployed?
