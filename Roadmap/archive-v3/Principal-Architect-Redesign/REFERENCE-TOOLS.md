# Reference Tools

> Tool categories for the redesigned roadmap. Tools are not completion by themselves; they support hands-on exercises, evidence, and architecture work.

---

## 1. Foundations

- Linux shell tools: `bash`, `grep`, `awk`, `sed`, `find`, `ss`, `journalctl`, `systemctl`
- Packet analysis: Wireshark, tcpdump
- Cryptography: OpenSSL, age, minisign, hashcat for lab password-hash exercises
- Documentation: Markdown, Mermaid, draw.io/diagrams.net, Graphviz

## 2. Programming

- Python: pytest, requests, scapy, FastAPI where useful
- Go: standard library, testing, race detector, staticcheck
- Rust: cargo, clippy, rustfmt, proptest, cargo-audit, cargo-fuzz
- Solidity: Foundry, Slither, Echidna

## 3. Web/API Security

- Burp Suite Community
- OWASP ZAP
- curl
- ffuf
- sqlmap for comparison after manual learning
- jwt_tool or local JWT scripts
- Semgrep

## 4. Supply Chain Security

- Syft for SBOM generation
- Grype for vulnerability scanning
- Trivy for container and IaC scanning
- Gitleaks or detect-secrets
- Cosign concepts for signing/provenance

## 5. Containers, Kubernetes, and Cloud-Native

- Docker or Podman
- kind, k3s, or minikube
- kubectl
- Helm where needed
- kube-bench
- kube-score
- Checkov
- Open Policy Agent
- Gatekeeper or Kyverno
- LocalStack where useful

## 6. Zero Trust and Service Identity

- OpenSSL or step-ca for lab certificate authority work
- Envoy concepts
- Istio or Linkerd for service mesh labs where appropriate
- Open Policy Agent
- Keycloak for local identity provider experiments

## 7. Observability and Detection

- OpenTelemetry
- Prometheus
- Grafana
- Loki or local log aggregation
- Wazuh or lightweight SIEM-style lab tools
- Sigma rule format concepts

## 8. Blockchain and Web3

- Go toolchain
- Rust toolchain
- Foundry
- Anvil local chain
- Hardhat where useful
- Slither
- Echidna
- Mythril where useful
- Solana/Anchor or Substrate/Cosmos tools depending on chosen ecosystem

## 9. AI Security and AI-Driven Defense

- Ollama or another local model runtime
- ChromaDB or local vector database
- Garak
- PyRIT
- Adversarial Robustness Toolbox
- Fickling for pickle/model-file analysis
- Jupyter only when controlled and documented

## 10. Architecture and Risk

- Mermaid
- diagrams.net
- Threat modeling templates
- ADR templates
- Risk registers
- Attack trees

---

## Tool Rule

For every tool added to the roadmap, document:

- [ ] What problem it solves
- [ ] Where it sits in attack/defense
- [ ] What input it consumes
- [ ] What output it produces
- [ ] How to verify output manually
- [ ] What false positives/false negatives exist
- [ ] What operational risk it introduces
