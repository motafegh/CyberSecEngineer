# Reference Architectures

> Architecture patterns to build, study, attack, defend, and adapt throughout the roadmap. Each pattern includes a narrative description of why it exists, an annotated diagram sketch, the required elements checklist, security questions, key ADR stubs, and common failure modes.

---

## 1. Secure Distributed Microservices

### Why This Pattern Exists

A monolith has one trust boundary. Splitting it into services multiplies the number of network calls, identities, and places authorization can silently fail. This pattern exists to keep that multiplication from becoming a multiplication of risk: every service gets its own identity, every call is authenticated, and authorization is decided in one place instead of scattered across handlers.

### How It Works

A single entry service (API gateway) terminates external traffic and forwards requests to backend services. Each backend service carries a request ID end to end, authenticates the caller (user or upstream service), and checks authorization against a central decision point rather than reimplementing the rule locally. Logs, metrics, and traces are correlated by request ID so a single request's path through every service can be reconstructed after the fact.

### Annotated Diagram Sketch

```text
Client
  -> API Gateway / Entry Service   [authenticates external caller, assigns request ID]
       -> Service A                [validates token, checks authz, calls Service B]
            -> Service B           [validates service identity, least-privilege scope]
       -> Service C                [independent path, same identity/authz pattern]
  -> Central Authorization Decision Point   [queried by every service]
  -> Telemetry Pipeline   [structured logs, metrics, traces correlated by request ID]
```

### Required Elements

- [ ] API gateway or entry service
- [ ] Multiple backend services
- [ ] Service identity
- [ ] Request IDs
- [ ] Structured logs
- [ ] Metrics and traces
- [ ] Central authorization decision
- [ ] Least privilege service permissions

### Security Questions

- [ ] What happens if one service is compromised?
- [ ] What identity does each service use?
- [ ] Where is authorization enforced?
- [ ] What logs prove a request path?

### Key ADR Stubs

- **ADR: Centralized vs embedded authorization.** Context: scattered authorization checks drift out of sync across services. Decision: route authorization decisions through one policy decision point. Consequences: adds a network hop and a new single point of failure that must itself be highly available and monitored.
- **ADR: Synchronous vs asynchronous service communication.** Context: chained synchronous calls create cascading latency and failure. Decision: use synchronous calls only where a response is required for the caller to proceed; otherwise use a queue. Consequences: queues introduce eventual consistency and require idempotency handling.
- **ADR: Service identity mechanism.** Context: services need to prove who they are to each other. Decision: short-lived certificates issued per service (see Zero Trust pattern below) rather than shared API keys. Consequences: requires certificate issuance and rotation infrastructure.

### Common Failure Modes

- Authorization logic duplicated and drifting between services instead of centralized.
- Internal service-to-service calls trusted simply because they originate "inside" the network.
- Request IDs generated but never propagated past the first hop, breaking traceability.
- One overprivileged service account used by multiple services for convenience.

---

## 2. Zero Trust Service-to-Service Platform

### Why This Pattern Exists

Flat, implicitly trusted internal networks turn one compromised service into a foothold for the entire platform. This pattern exists to make every service prove its identity on every call and have every access decision checked against policy, so that no network location implies trust.

### How It Works

Each service is issued a short-lived certificate (or equivalent credential) at startup. Connections between services use mutual authentication so both sides verify each other before any data moves. A policy engine evaluates each call against context (caller identity, resource, action) and denies by default unless a rule explicitly allows it. Every access decision — allow or deny — is logged for later analysis.

### Annotated Diagram Sketch

```text
Certificate Authority (lab-scale)
  -> issues short-lived certs to: Service A, Service B, Service C

Service A --mTLS (mutual authN)--> Service B
  -> Service B queries Policy Engine: "Can Service A call this endpoint?"
  -> Policy Engine: deny by default, allow only if rule matches
  -> Decision logged with caller identity, resource, action, and result

Microsegmentation: network policy additionally restricts which services can reach which, independent of the application-layer check.
```

### Required Elements

- [ ] mTLS or equivalent service authentication
- [ ] Deny-by-default access
- [ ] Policy-as-code authorization
- [ ] Microsegmentation
- [ ] Access decision logs
- [ ] Certificate/key rotation plan

### Security Questions

- [ ] Which service identity is most dangerous?
- [ ] What is the blast radius of credential theft?
- [ ] How are policies tested?

### Key ADR Stubs

- **ADR: Certificate lifetime.** Context: long-lived certificates increase the value and window of a stolen key. Decision: short-lived certificates with automated rotation rather than long-lived, manually-rotated ones. Consequences: requires reliable automated issuance; a broken rotation pipeline becomes an availability incident.
- **ADR: Policy enforcement location.** Context: policy can be enforced at a sidecar/proxy layer or embedded in application code. Decision: enforce at a sidecar/proxy where feasible, to decouple policy from application releases. Consequences: adds a network hop per call and a new component to operate.
- **ADR: Fail-open vs fail-closed on policy engine outage.** Context: if the policy engine is unreachable, services must decide whether to allow or deny. Decision: fail closed (deny) to preserve the security invariant, accepting an availability cost. Consequences: a policy engine outage becomes a platform-wide outage; the policy engine itself must be made highly available.

### Common Failure Modes

- Microsegmentation network policy implemented, but application-layer authorization left wide open ("we already segmented the network").
- Certificate rotation pipeline silently failing, discovered only when certificates expire in production.
- Policy engine treated as a side component instead of a tier-0 dependency with its own availability and monitoring requirements.

---

## 3. Secure Kubernetes Platform

### Why This Pattern Exists

Kubernetes is itself a distributed control plane: a single overprivileged service account or missing network policy can turn a single compromised pod into cluster-wide or even node-level compromise. This pattern exists to apply least privilege and isolation at every Kubernetes-native boundary — namespace, RBAC, network policy, and pod security — rather than relying on the cluster's defaults.

### How It Works

Workloads are isolated by namespace per environment or team. Each workload runs under a dedicated, least-privilege service account rather than the namespace default. Pod security controls restrict privilege escalation, host access, and capabilities. Network policies restrict which pods can talk to which, denying east-west traffic by default. Admission controllers enforce these rules at deploy time rather than relying on after-the-fact audit. Audit logs capture API server activity for later investigation.

### Annotated Diagram Sketch

```text
Cluster
  -> Namespace: team-a
       -> Pod (non-root, dropped capabilities, read-only root fs)
            -> dedicated Service Account (least-privilege RBAC role)
       -> NetworkPolicy: allow only from Namespace team-a + explicit allowlist
  -> Admission Controller: rejects pods violating Pod Security Standards
  -> Audit Log: every API server request, who/what/when
```

### Required Elements

- [ ] Namespaces
- [ ] Least privilege RBAC
- [ ] Network policies
- [ ] Pod security controls
- [ ] Admission policies
- [ ] Secret management
- [ ] Audit logging

### Security Questions

- [ ] Can a pod access the host?
- [ ] Can a service account read secrets?
- [ ] What alerts show privilege escalation?

### Key ADR Stubs

- **ADR: Default-deny network policy.** Context: Kubernetes allows all pod-to-pod traffic by default. Decision: apply a default-deny NetworkPolicy per namespace and explicitly allow required paths. Consequences: every new service-to-service dependency requires a policy update, adding deployment friction in exchange for containment.
- **ADR: Service account per workload vs namespace default.** Context: using the default service account for every pod in a namespace makes every pod equally privileged. Decision: issue a dedicated, scoped service account per workload. Consequences: more RBAC objects to manage, but a compromised pod's blast radius shrinks to its own permissions.
- **ADR: Admission control enforcement vs advisory scanning.** Context: scanning after deployment finds violations too late. Decision: enforce Pod Security Standards at admission time, rejecting non-compliant pods before they run. Consequences: misconfigured legitimate workloads will fail to deploy until fixed, requiring a clear exception path.

### Common Failure Modes

- Default service account used cluster-wide because it "already works."
- Network policies written but never tested, leaving them silently permissive.
- Secrets stored as plain Kubernetes Secrets without encryption at rest or rotation.
- Cluster-admin RBAC bindings granted for convenience during initial setup and never revoked.

---

## 4. Secure Blockchain Node/Validator Architecture

### Why This Pattern Exists

In a blockchain network, a validator's private key is equivalent to its right to participate in consensus — and in many protocols, double-signing or key theft has direct financial or protocol-control consequences. This pattern exists to isolate the validator key from the node's network-facing surface, so that node compromise does not automatically mean key compromise.

### How It Works

The validator's signing key never touches the network-facing node directly; signing requests are forwarded to a separate, isolated signer (remote signing) that holds the key. The consensus node itself is hardened and monitored for missed blocks, equivocation, and unusual peer behavior, which are leading indicators of either an attack or a misconfiguration. Backup and recovery plans exist for both the node and the key material, and slashing protection prevents the validator from being tricked into double-signing across a restart or migration.

### Annotated Diagram Sketch

```text
P2P Network (untrusted peers)
  -> Consensus/Validator Node   [network-facing, hardened, monitored]
       -> signing request -> Remote Signer (isolated, holds key)   [no direct network exposure]
       <- signed result <-
  -> Monitoring: missed blocks, equivocation, peer anomalies
  -> Slashing Protection DB: prevents signing a conflicting block after restart/migration
  -> Backup/Recovery Plan: node state + key material, tested independently
```

### Required Elements

- [ ] Node network boundary
- [ ] Validator key isolation
- [ ] Remote signing or equivalent control where applicable
- [ ] Monitoring for missed blocks/suspicious events
- [ ] Backup and recovery plan
- [ ] Slashing protection plan

### Security Questions

- [ ] What happens if a validator key leaks?
- [ ] What happens during network partition?
- [ ] What telemetry proves validator health?

### Key ADR Stubs

- **ADR: Remote signing vs co-located key.** Context: co-locating the signing key on the network-facing node means any node compromise is a key compromise. Decision: separate the signer into an isolated component reachable only by the node. Consequences: adds latency and a new failure mode (signer unreachable = node cannot sign) that must be monitored.
- **ADR: Slashing protection persistence.** Context: a validator restored from an old snapshot could double-sign a block it already signed, triggering slashing. Decision: persist slashing protection state independently of the node's chain state and verify it on every restart. Consequences: recovery procedures become more complex but prevent an entirely avoidable financial penalty.
- **ADR: Client diversity.** Context: running a single consensus client implementation means a client-specific bug can affect the whole validator set simultaneously. Decision: where the protocol supports it, prefer or plan for client diversity. Consequences: more operational complexity in exchange for reduced correlated-failure risk.

### Common Failure Modes

- Validator key stored directly on the consensus node "for simplicity," eliminating the isolation this pattern exists to provide.
- No alerting on missed blocks, so a degraded validator is discovered only after slashing.
- Slashing protection database lost or not restored during a node migration, causing accidental double-signing.

---

## 5. Secure Bridge / Cross-Chain Architecture

### Why This Pattern Exists

A bridge replaces native cross-chain trust (which doesn't exist) with a trusted set of relayers, signers, or light clients. Most of the largest blockchain losses have come from exactly this substitution being weaker than assumed. This pattern exists to make the trust assumption explicit and to bound the damage when it fails.

### How It Works

A message originating on the source chain is observed by relayers, verified against the source chain's finality rules, and submitted to the destination chain, where it is verified again before being acted on (e.g., minting a wrapped asset). Replay protection ensures the same message cannot be submitted twice. Emergency controls (pause functionality) and monitoring for abnormal flow volume act as a backstop for assumptions that turn out to be wrong.

### Annotated Diagram Sketch

```text
Source Chain
  -> Event emitted (e.g., asset locked)
  -> Relayer(s) observe event, wait for source-chain finality
  -> Message + proof submitted to Destination Chain
  -> Destination Chain Verifier: checks proof against trust model (multisig / light client)
       -> Replay Protection: message ID checked against already-processed set
       -> Action executed (e.g., asset minted)
  -> Monitoring: abnormal flow volume triggers circuit breaker / pause
```

### Required Elements

- [ ] Source chain verification
- [ ] Destination chain verification
- [ ] Message replay protection
- [ ] Relayer/signer trust model
- [ ] Finality assumptions
- [ ] Emergency controls
- [ ] Monitoring abnormal flows

### Security Questions

- [ ] Who can forge or approve messages?
- [ ] What finality assumptions are made?
- [ ] What happens if relayers are compromised?

### Key ADR Stubs

- **ADR: Multisig vs light-client verification.** Context: multisig bridges are simpler to build but concentrate trust in a small signer set; light-client bridges are more trustless but harder to build and maintain. Decision: state explicitly which model is used and why, given engineering constraints. Consequences: a multisig choice must be paired with strong signer key management and monitoring to compensate for the concentrated trust.
- **ADR: Finality assumption per source chain.** Context: different chains have different finality guarantees and reorg risk. Decision: define a minimum confirmation depth per source chain before a message is considered final enough to act on. Consequences: deeper confirmation requirements increase latency but reduce reorg-related double-processing risk.
- **ADR: Emergency pause authority.** Context: a pause function stops an active exploit but is itself a centralization risk if the pause key is compromised or abused. Decision: define who holds pause authority and under what governance process it is exercised. Consequences: requires balancing fast incident response against decentralization and abuse risk.

### Common Failure Modes

- Trust model documented as "decentralized" while a small multisig actually controls all funds.
- Replay protection scoped to one direction only, missing replay on the reverse path.
- No circuit breaker, so an exploit drains the bridge fully before anyone reacts.

---

## 6. Secure RAG Application

### Why This Pattern Exists

Retrieval-Augmented Generation treats retrieved documents as context the model will follow — including any instructions hidden inside them. This pattern exists to keep retrieved content from silently becoming untrusted instructions the model obeys, and to keep retrieval itself from leaking content the requesting user shouldn't see.

### How It Works

Documents are ingested with provenance metadata and access labels. Retrieval is access-controlled: a user's query only searches the index partition (or filter) they are authorized to see. Retrieved content is labeled as data, not instructions, when constructed into the model's context. Outputs are required to cite their sources, and all prompts, retrievals, and outputs are logged so behavior can be audited after the fact. Sensitive answers route through human review before being acted on.

### Annotated Diagram Sketch

```text
User Query
  -> Access-Controlled Retrieval   [filters index by user's authorized scope]
       -> Vector Database          [documents tagged with provenance + access labels]
  -> Context Construction          [retrieved text labeled as data, not instructions]
  -> LLM                           [generates answer, must cite sources]
  -> Output Handling                [citations required; sensitive answers -> human review]
  -> Logs: prompt, retrieved docs, output, decision
```

### Required Elements

- [ ] Document provenance
- [ ] Access-controlled retrieval
- [ ] Source labeling
- [ ] Prompt injection tests
- [ ] Output handling controls
- [ ] Prompt/retrieval/tool logs
- [ ] Human review for sensitive actions

### Security Questions

- [ ] Can a document override instructions?
- [ ] Can a user retrieve unauthorized content?
- [ ] Are outputs treated as untrusted?

### Key ADR Stubs

- **ADR: Access control at retrieval vs at generation.** Context: filtering unauthorized content out of the model's answer after the fact is unreliable. Decision: enforce access control at the retrieval step, before content ever reaches the model's context. Consequences: requires access metadata on every document and a retrieval layer that understands per-user scope.
- **ADR: Treating retrieved content as data vs instructions.** Context: models will follow instructions found anywhere in their context, including retrieved documents. Decision: explicitly frame retrieved content as untrusted data in the prompt structure, and test that framing against injection attempts. Consequences: does not fully eliminate injection risk; must be paired with output handling controls and human review for sensitive actions.
- **ADR: Citation requirement.** Context: users may treat fluent answers as verified fact. Decision: require the model to cite retrieved sources for factual claims. Consequences: citations are a partial mitigation, not a guarantee of correctness — must be communicated as such.

### Common Failure Modes

- Index built without access labels, then access control bolted on as a filter after retrieval — easy to bypass.
- Retrieved documents treated as fully trusted because they "came from our own knowledge base."
- No logging of what was retrieved for a given answer, making post-incident review impossible.

---

## 7. AI-Driven Security Operations

### Why This Pattern Exists

AI can meaningfully speed up alert triage and summarization, but an AI system that can act on its own conclusions turns a wrong summary into a wrong containment action. This pattern exists to keep AI assistance fast and useful while keeping every high-impact decision behind a human approval gate.

### How It Works

Logs are ingested and run through detection/anomaly logic to produce candidate alerts. An LLM summarizes related events into a human-readable incident narrative, with every claim in the summary linked back to the raw evidence it came from. The system recommends a containment action but does not execute it; a human reviews the evidence-linked summary and approves or rejects the action. False positive and false negative rates are tracked against an evaluation set so the system's accuracy is measured, not assumed.

### Annotated Diagram Sketch

```text
Log Sources
  -> Ingestion + Detection/Anomaly Logic
       -> Candidate Alert
  -> LLM Summarization   [every claim linked to raw evidence]
       -> Incident Narrative + Recommended Action (not executed)
  -> Human Approval Gate
       -> Approved -> Action executed, logged
       -> Rejected -> logged, fed back into evaluation set
  -> Evaluation Tracking: false positive / false negative rate over time
```

### Required Elements

- [ ] Log ingestion
- [ ] Detection logic
- [ ] AI-assisted summarization
- [ ] Evidence links
- [ ] Human approval gates
- [ ] Guardrail policy
- [ ] Evaluation set
- [ ] False positive/false negative tracking

### Security Questions

- [ ] Can malicious logs manipulate the AI assistant?
- [ ] Can the AI execute actions directly?
- [ ] How is summary correctness evaluated?

### Key ADR Stubs

- **ADR: AI recommends, human executes.** Context: an AI system with direct execution rights against production infrastructure turns a hallucinated or manipulated summary into a real incident. Decision: the AI may only recommend; a human must approve before any containment action runs. Consequences: slower response time in exchange for eliminating a class of automation failure.
- **ADR: Evidence-linked summaries.** Context: a fluent summary can be wrong in ways that are hard to spot without the underlying evidence. Decision: every claim in an AI-generated summary must link to the specific log lines or events that support it. Consequences: increases summary generation complexity but makes human review meaningfully faster and more reliable.
- **ADR: Treating log content as untrusted input to the LLM.** Context: log fields (user agents, filenames, referrers) are attacker-controlled and can contain injection payloads aimed at the summarizing LLM. Decision: sanitize/label log content as untrusted data in the summarization prompt and test against injection. Consequences: requires ongoing red-teaming of the summarization pipeline itself.

### Common Failure Modes

- Guardrail policy defined on paper but the system wired to execute actions directly anyway "to save time."
- Evaluation set never built, so nobody can say how often the AI is wrong.
- Log fields fed into the LLM without treating them as attacker-controlled, opening an indirect prompt injection path.

---

## 8. Secure Software Supply Chain

### Why This Matters

A build pipeline that pulls in dependencies, builds containers, and deploys artifacts is itself an attack surface — sometimes a more efficient one for an attacker than the running application. This pattern exists to make every step from dependency to deployed artifact scannable, attributable, and least-privilege.

### How It Works

Dependencies are scanned for known vulnerabilities and pinned via lockfiles. Secrets are scanned out of source and never baked into images. An SBOM is generated for every build, recording exactly what went into it. Build artifacts are signed so their provenance can be verified later. CI/CD pipelines run with least-privilege, scoped tokens, and builds are isolated from each other so one compromised build cannot affect another. Container images are scanned before deployment.

### Annotated Diagram Sketch

```text
Source Repository
  -> Secret Scanning (pre-commit + CI)
  -> Dependency Scanning (lockfile-pinned)
  -> Build (isolated, least-privilege CI token)
       -> SBOM Generated
       -> Container Image Scanned
       -> Artifact Signed (provenance attached)
  -> Deployment
  -> Question answerable at any time: "what exactly is running, and where did it come from?"
```

### Required Elements

- [ ] Dependency scanning
- [ ] Secret scanning
- [ ] SBOM generation
- [ ] Artifact signing/provenance plan
- [ ] Least privilege CI/CD
- [ ] Container scanning
- [ ] Build isolation

### Security Questions

- [ ] What happens if a dependency is compromised?
- [ ] Can build secrets leak?
- [ ] How do we know what was deployed?

### Key ADR Stubs

- **ADR: Lockfile enforcement.** Context: unpinned dependency ranges mean a build today and a build tomorrow can pull different, potentially compromised, code without anyone changing anything. Decision: require lockfiles and fail builds on lockfile drift. Consequences: dependency updates require an explicit, reviewed step rather than happening silently.
- **ADR: Artifact signing and provenance.** Context: without signing, there is no cryptographic way to verify that a deployed artifact matches what was built and reviewed. Decision: sign every build artifact and verify the signature before deployment. Consequences: requires key management infrastructure for the signing process itself.
- **ADR: Least-privilege, single-purpose CI tokens.** Context: a single broad CI token shared across pipelines means any pipeline compromise grants access to everything that token can touch. Decision: scope tokens narrowly per pipeline/purpose and rotate them. Consequences: more tokens to manage, but a compromised pipeline's blast radius shrinks to its own scope.

### Common Failure Modes

- SBOM generated but never consulted during an actual incident, making it theater rather than a control.
- A single CI/CD token with broad permissions reused across every pipeline for convenience.
- Container scanning run, but findings never gated — builds proceed regardless of scan results.