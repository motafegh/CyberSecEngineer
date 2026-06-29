# Phase 3 — Distributed, Cloud, and Zero Trust Systems

> Purpose: Move from single-application security into secure distributed architecture: services, identity, policy, cloud-native infrastructure, Kubernetes, observability, resilience, and Zero Trust.

---

## 1. Phase Goal

This phase builds the bridge from security engineer to secure systems architect. You will design, build, break, defend, monitor, and document distributed systems.

**Zero Trust:** a security model where no user, device, network, or workload is trusted by default; access is continuously verified.

---

## 2. Prerequisites

- [ ] Phase 0 secure cyber range available.
- [ ] Phase 1 foundations complete enough for networking, cryptography, Go, Rust, and threat modeling.
- [ ] Phase 2 core security complete enough for web/API, authorization, detection, and secure engineering.

---

## 3. Outcomes

By the end of this phase, you should be able to:

- [ ] Explain distributed systems failure modes.
- [ ] Build a small distributed service system in Go.
- [ ] Deploy services locally with containers and Kubernetes.
- [ ] Apply identity-aware service communication.
- [ ] Use policy-as-code for authorization decisions.
- [ ] Design Zero Trust access flows.
- [ ] Add logs, metrics, and traces.
- [ ] Simulate failure and attack conditions.
- [ ] Produce architecture diagrams, threat models, and ADRs.

---

## 4. Module 3.1 — Distributed Systems Fundamentals

### Why This Matters

Blockchain, cloud platforms, AI services, Kubernetes, identity systems, and Zero Trust networks are all distributed systems. Their security depends on failure behavior, consistency, coordination, and trust.

### Mechanism

Distributed systems coordinate work across multiple networked components. They must handle latency, partial failure, retries, inconsistent state, duplicate messages, and untrusted inputs.

### Core Concepts

- Service decomposition
- Client/server communication
- Remote Procedure Calls
- Message queues
- Replication
- Consistency
- Availability
- Partition tolerance
- Leader election
- Consensus overview
- Idempotency
- Retries and backoff
- Circuit breakers
- Timeouts

**RPC — Remote Procedure Call:** a pattern where one program requests an operation from another program as if calling a local function.

### Hands-On Exercises

- [ ] Build two Go services that communicate over HTTP.
- [ ] Add request IDs to every request.
- [ ] Add timeouts to client calls.
- [ ] Simulate a slow downstream service.
- [ ] Add retries and observe duplicate effects.
- [ ] Make an operation idempotent.
- [ ] Simulate service failure and record behavior.
- [ ] Write an ADR for retry behavior.

### Attack Surface

- Missing authentication between services
- Trusting internal networks
- Retry amplification
- Inconsistent authorization
- Unvalidated service responses
- Poor error handling
- Cascading failures

### Defensive Controls

- Service identity
- Timeouts
- Rate limits
- Idempotency keys
- Circuit breakers
- Input validation between services
- Least privilege service permissions

### Detection and Telemetry

- Request IDs
- Structured logs
- Latency metrics
- Error rates
- Dependency failure alerts
- Distributed traces

### Recall Checks

- What is partial failure?
- Why can retries make incidents worse?
- Why is idempotency security-relevant?
- Why should internal service calls not be blindly trusted?

---

## 5. Module 3.2 — Containers and Secure Runtime Boundaries

### Why This Matters

Containers package applications but do not magically make them safe. Container misconfigurations often become host or cluster compromise.

### Core Concepts

- Images
- Containers
- Namespaces
- cgroups
- Capabilities
- seccomp
- AppArmor/SELinux concepts
- Rootless containers
- Image layers
- Registries

### Hands-On Exercises

- [ ] Build a minimal container image.
- [ ] Run a container as non-root.
- [ ] Compare root and non-root behavior.
- [ ] Drop Linux capabilities.
- [ ] Test read-only filesystem mode.
- [ ] Scan an image for vulnerabilities.
- [ ] Demonstrate why mounting the Docker socket is dangerous in a controlled lab.
- [ ] Write a container hardening checklist.

### Attack Surface

- Privileged containers
- Mounted host paths
- Docker socket exposure
- Running as root
- Vulnerable base images
- Embedded secrets
- Overbroad capabilities

### Defensive Controls

- Minimal images
- Non-root users
- Capability dropping
- Read-only filesystems
- Image scanning
- Secret injection instead of baking secrets
- Runtime policy

### Recall Checks

- Why is container root not the same as host root, and when can it become dangerous?
- Why is the Docker socket high risk?
- What does dropping capabilities reduce?

---

## 6. Module 3.3 — Kubernetes Security

### Why This Matters

Kubernetes is a distributed control plane. A weak Kubernetes configuration can expose secrets, workloads, nodes, and entire platforms.

### Core Concepts

- Pods
- Deployments
- Services
- Namespaces
- Service accounts
- Secrets
- ConfigMaps
- Role-Based Access Control
- Admission controllers
- Network policies
- Ingress
- Audit logs

**RBAC — Role-Based Access Control:** permissions are assigned to roles, and users or services receive permissions by being assigned those roles.

### Hands-On Exercises

- [ ] Deploy a simple app to local Kubernetes.
- [ ] Create a namespace per app environment.
- [ ] Create a restricted service account.
- [ ] Test permissions with `can-i` style checks in the lab.
- [ ] Demonstrate overprivileged service account risk.
- [ ] Add a network policy.
- [ ] Store and read a test secret.
- [ ] Enable or inspect available audit/event logs.
- [ ] Write a Kubernetes threat model.

### Attack Surface

- Cluster-admin bindings
- Default service account token exposure
- Privileged pods
- HostPath mounts
- Exposed dashboards
- Weak network policies
- Unencrypted secrets

### Defensive Controls

- Least privilege RBAC
- Namespace isolation
- Network policies
- Pod Security Standards
- Admission control
- Secret encryption and rotation
- Audit logging

### Mini Project — Kubernetes Attack and Hardening Lab

Deliver:

- [ ] Vulnerable deployment
- [ ] Attack path explanation
- [ ] Hardened deployment
- [ ] RBAC diff
- [ ] Network policy diff
- [ ] Detection notes
- [ ] Architecture lesson

### Recall Checks

- Why is a service account token sensitive?
- What does a network policy enforce?
- Why is Kubernetes control plane compromise severe?

---

## 7. Module 3.4 — Cloud Security and Infrastructure as Code

### Why This Matters

Cloud platforms are programmable distributed systems. Misconfiguration can expose data, identities, and compute resources at scale.

**IaC — Infrastructure as Code:** defining infrastructure using version-controlled code instead of manual configuration.

### Core Concepts

- Shared responsibility model
- Identity and Access Management
- Object storage
- Compute
- Serverless functions
- Virtual networks
- Security groups/firewalls
- Logging/audit trails
- Secrets management
- Terraform concepts
- Drift
- Policy-as-code scanning

**IAM — Identity and Access Management:** controls for who or what can access which resources, under what conditions.

### Hands-On Exercises

- [ ] Deploy a local cloud-like lab or simulated resources.
- [ ] Write simple infrastructure code.
- [ ] Create one intentionally public storage misconfiguration.
- [ ] Detect it with scanning.
- [ ] Fix it.
- [ ] Create one overbroad IAM policy.
- [ ] Reduce it to least privilege.
- [ ] Write an ADR for logging requirements.

### Attack Surface

- Public storage
- Wildcard IAM permissions
- Exposed management ports
- Leaked credentials
- Missing logging
- Insecure serverless permissions
- Public snapshots

### Defensive Controls

- Least privilege IAM
- Private by default resources
- Encryption
- Logging and audit trails
- Secret management
- IaC scanning
- Drift detection
- Guardrails

### Mini Project — Cloud Misconfiguration Lab

Deliver:

- [ ] Misconfigured IaC examples
- [ ] Exploit demonstrations in local/simulated lab
- [ ] Fixed configurations
- [ ] Scanner results
- [ ] Risk-ranked report

### Recall Checks

- Why is IAM the blast-radius control layer?
- What does shared responsibility mean?
- Why is missing logging a security finding?

---

## 8. Module 3.5 — Service Identity and mTLS

### Why This Matters

Zero Trust requires services to prove identity, not just rely on network location.

**mTLS — mutual Transport Layer Security:** TLS where both client and server authenticate each other, commonly used for service-to-service trust.

### Mechanism

Each service receives an identity, usually through a certificate. During connection setup, both sides verify each other before exchanging data.

### Hands-On Exercises

- [ ] Create a small certificate authority for lab use.
- [ ] Issue certificates to two services.
- [ ] Configure server-side TLS.
- [ ] Configure client certificate verification.
- [ ] Observe failed connection with missing/wrong client certificate.
- [ ] Rotate a test certificate.
- [ ] Document identity lifecycle.

### Attack Surface

- Stolen private keys
- Expired certificates
- Weak certificate validation
- Overbroad service identity
- No revocation process

### Defensive Controls

- Short-lived certificates
- Automated rotation
- Strong validation
- Key protection
- Identity-scoped authorization
- Certificate expiry monitoring

### Recall Checks

- How is mTLS different from normal TLS?
- What does a service certificate prove?
- What happens when a service private key leaks?

---

## 9. Module 3.6 — Policy-as-Code and Authorization Architecture

### Why This Matters

Distributed systems need consistent authorization. Hardcoding scattered checks creates drift and hidden privilege paths.

**OPA — Open Policy Agent:** a policy-as-code engine used to make authorization and compliance decisions consistently.

### Core Concepts

- Policy decision point
- Policy enforcement point
- Centralized vs embedded policy
- Rego basics or equivalent policy language
- Deny by default
- Context-aware decisions
- Policy testing
- Policy logging

### Hands-On Exercises

- [ ] Write a simple allow/deny policy.
- [ ] Add user role conditions.
- [ ] Add resource ownership conditions.
- [ ] Add service identity conditions.
- [ ] Write tests for policies.
- [ ] Log policy decisions.
- [ ] Integrate a policy check into a small service.
- [ ] Write an ADR comparing embedded checks and policy-as-code.

### Attack Surface

- Policy bypass
- Missing enforcement point
- Stale policy data
- Overbroad default allow
- Poor policy test coverage
- Missing decision logs

### Defensive Controls

- Deny by default
- Central policy review
- Policy tests
- Decision logging
- Version control
- Separation of duties

### Recall Checks

- What is the difference between decision and enforcement?
- Why is deny-by-default important?
- What can go wrong if policy data is stale?

---

## 10. Module 3.7 — Zero Trust Network Architecture

### Why This Matters

Traditional networks often trust anything “inside.” Zero Trust removes that assumption and continuously verifies identity, context, and policy.

### Core Concepts

- Identity-first access
- Least privilege
- Microsegmentation
- Device/workload posture
- Continuous verification
- Just-in-time access
- Strong authentication
- Policy-based access
- Telemetry-driven trust
- Blast radius reduction

### Hands-On Exercises

- [ ] Draw a traditional flat network and identify lateral movement paths.
- [ ] Redesign it with Zero Trust boundaries.
- [ ] Add service identity requirements.
- [ ] Add network policies.
- [ ] Add policy-based authorization.
- [ ] Simulate a compromised low-privilege service.
- [ ] Show how controls limit blast radius.
- [ ] Write a Zero Trust migration ADR.

### Attack Surface

- Implicit internal trust
- Flat networks
- Shared credentials
- Overprivileged service accounts
- Missing telemetry
- Long-lived access

### Defensive Controls

- Identity-aware access
- mTLS
- Microsegmentation
- Least privilege
- Continuous logging
- Conditional access
- Just-in-time elevation

### Mini Project — Zero Trust Microservices Lab

Build:

- [ ] Three services
- [ ] Service identities
- [ ] mTLS or equivalent identity proof
- [ ] Policy-as-code authorization
- [ ] Network restrictions
- [ ] Logs for access decisions
- [ ] Attack simulation
- [ ] Blast-radius analysis

### Recall Checks

- Why is Zero Trust not just network segmentation?
- What does continuous verification mean?
- How does Zero Trust limit lateral movement?

---

## 11. Module 3.8 — Observability, Detection, and Resilience

### Why This Matters

Distributed systems are hard to understand without telemetry. Security incidents and outages often look similar until evidence is correlated.

### Core Concepts

- Structured logs
- Metrics
- Traces
- OpenTelemetry
- Correlation IDs
- Service Level Indicators
- Error budgets concept
- Alert design
- Chaos testing
- Incident runbooks

**OpenTelemetry:** an open standard for collecting traces, metrics, and logs from applications and infrastructure.

### Hands-On Exercises

- [ ] Add structured logs to services.
- [ ] Add request IDs.
- [ ] Add metrics for request count, latency, and errors.
- [ ] Add distributed tracing.
- [ ] Trigger a downstream failure.
- [ ] Follow the failure in logs and traces.
- [ ] Write an alert rule.
- [ ] Write an incident runbook.

### Attack Surface

- Missing logs
- Logs with secrets
- Unauthenticated telemetry endpoints
- Alert fatigue
- Unclear ownership
- No incident runbooks

### Defensive Controls

- Safe structured logging
- Trace correlation
- Access-controlled telemetry
- Actionable alerts
- Runbooks
- Retention policies

### Recall Checks

- What does a trace show that a log may not?
- Why are correlation IDs useful?
- Why can logs become sensitive data?

---

## 12. Phase 3 Capstone — Secure Distributed Zero Trust Platform

Build a local distributed platform.

Required system:

- [ ] At least three services, preferably in Go.
- [ ] Containerized deployment.
- [ ] Local Kubernetes deployment.
- [ ] Service identities.
- [ ] mTLS or equivalent authenticated service communication.
- [ ] Policy-as-code authorization.
- [ ] Network restrictions.
- [ ] Structured logs.
- [ ] Metrics and traces.
- [ ] Failure simulation.
- [ ] Attack simulation.

Required artifacts:

- [ ] System context diagram
- [ ] Component diagram
- [ ] Trust boundary diagram
- [ ] Threat model
- [ ] Risk register
- [ ] ADRs
- [ ] Attack/defense report
- [ ] Detection and incident runbook
- [ ] Zero Trust migration note

---

## 13. Recall and Interleaving Plan

Mix concepts:

- [ ] Distributed retries + denial of service
- [ ] Kubernetes service accounts + Zero Trust service identity
- [ ] mTLS + cryptography/key lifecycle
- [ ] Policy-as-code + API authorization
- [ ] Observability + incident response
- [ ] Cloud IAM + blockchain validator key management preview

Teach-back prompts:

- [ ] Explain why internal networks should not be trusted.
- [ ] Explain how a request travels through the capstone platform.
- [ ] Explain which identity is most dangerous if compromised.
- [ ] Explain how you would detect lateral movement.

---

## 14. Phase 3 Exit Criteria

- [ ] Distributed systems exercises completed.
- [ ] Container and Kubernetes hardening exercises completed.
- [ ] Cloud/IaC misconfiguration exercises completed.
- [ ] mTLS/service identity exercises completed.
- [ ] Policy-as-code exercises completed.
- [ ] Zero Trust microservices lab completed.
- [ ] Observability exercises completed.
- [ ] Phase 3 capstone completed.
- [ ] Recall checks passed without notes.
- [ ] Mistake log updated.
