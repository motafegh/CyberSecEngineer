# Phase 3 — Track C: Cloud Security (Local)

> **All cloud security skills, zero cloud accounts, using LocalStack and local Kubernetes.**  
> **Prerequisites:** [PHASE-2-CORE-ATTACK-DEFENSE.md](PHASE-2-CORE-ATTACK-DEFENSE.md) complete  
> **Schedule:** Every Wednesday + deep work Saturdays  
> **Duration:** ~7 months (parallel with other tracks)

---

## Table of Contents

- [C.1 Core Cloud Concepts](#c1-core-cloud-concepts)
- [C.2 Cloud Misconfiguration Classes](#c2-cloud-misconfiguration-classes)
- [C.3 Container & Kubernetes Security](#c3-container--kubernetes-security)
- [C.4 Infrastructure as Code Security](#c4-infrastructure-as-code-security)
- [C.5 Tools](#c5-tools)
- [C.6 Mini Projects](#c6-mini-projects)
- [Track C Capstone](#track-c-capstone--cloud-security-assessment)

---

## C.1 Core Cloud Concepts

### Shared Responsibility Model

```
┌─────────────────────────────────────────┐
│          CUSTOMER RESPONSIBILITY         │
│  ┌─────────────────────────────────┐    │
│  │         APPLICATION              │    │
│  │  ┌─────────────────────────┐   │    │
│  │  │    OPERATING SYSTEM      │   │    │
│  │  │  ┌─────────────────┐   │   │    │
│  │  │  │   NETWORK        │   │   │    │
│  │  │  │  ┌───────────┐  │   │   │    │
│  │  │  │  │  FIREWALL  │  │   │   │    │
│  │  │  │  │ ┌───────┐ │  │   │   │    │
│  │  │  │  │ │  DATA  │ │  │   │   │    │
│  │  │  │  │ │       │ │  │   │   │    │
│  └──┘  └──┘ └───────┘ └──┘   └──┘    │
│         CLOUD PROVIDER RESPONSIBILITY   │
└─────────────────────────────────────────┘
```

- **Cloud provider:** Hardware, virtualization, physical security
- **Customer:** Everything above the hypervisor — OS, apps, data, access control

### IAM Design Principles

1. **Least privilege** — Grant minimum access needed
2. **Separation of duties** — No single person has full control
3. **Just-in-time access** — Temporary elevation, auto-expiring
4. **Resource policies** vs **identity policies** — When to use which
5. **Service accounts** — Dedicated identities for apps, key rotation
6. **Secrets management** — Rotation, encryption, audit trail

### Network Segmentation

| Concept | What It Is |
|---|---|
| **VPC** | Isolated virtual network |
| **Subnets** | IP ranges within VPC (public vs private) |
| **Security Groups** | Stateful firewall at instance level |
| **NACLs** | Stateless firewall at subnet level |
| **Route Tables** | Control traffic flow between subnets |

### Data Classification Tiers

| Tier | Example | Protection Required |
|---|---|---|
| Public | Marketing website | Standard |
| Internal | Internal documentation | Access control |
| Confidential | Customer data, API keys | Encryption + access control |
| Restricted | Financial records, PII | Encryption + MFA + audit |

---

## C.2 Cloud Misconfiguration Classes

| # | Misconfiguration | Impact | How to Exploit |
|---|---|---|---|
| 1 | **Public object storage (S3)** | Data exposure | Browse bucket contents, download |
| 2 | **Wildcard IAM policies** | Privilege escalation | `Resource: "*"` grants access to everything |
| 3 | **Publicly exposed databases** | Data theft | Connect directly without auth |
| 4 | **Hardcoded credentials** | Full account compromise | Extract from source code, config files |
| 5 | **Missing encryption at rest** | Data exposure if storage accessed | Access underlying storage |
| 6 | **Missing encryption in transit** | Credential interception | MITM on unencrypted connections |
| 7 | **Exposed metadata endpoint** | Credential theft | `169.254.169.254/latest/meta-data/iam/*` |
| 8 | **Unrestricted outbound (0.0.0.0/0)** | Data exfiltration, C2 | Connect to attacker server |
| 9 | **Missing CloudTrail/logging** | Attacker persistence undetected | Delete logs, no audit trail |
| 10 | **Public AMI / snapshot** | Data exposure | Mount snapshot, read contents |

---

## C.3 Container & Kubernetes Security

### Container Concepts

| Concept | What It Does |
|---|---|
| **Namespaces** | Isolate processes, network, mounts (pid, net, mnt, uts, ipc, user) |
| **cgroups** | Limit resource usage (CPU, memory, I/O) |
| **Capabilities** | Fine-grained privileges (instead of full root) |
| **seccomp profiles** | Filter allowed syscalls |
| **AppArmor/SELinux** | Mandatory access control |

### Container-to-Host Escape Paths

1. **Privileged container** → full host access via `/proc/1/root/`
2. **Mounted Docker socket** → escape via Docker daemon
3. **Kernel exploit** → container doesn't contain kernel exploits
4. **Writable /sys** → modify kernel parameters from container

### Kubernetes Concepts

| Concept | Security Relevance |
|---|---|
| **RBAC** | ClusterRole, Role, RoleBinding — who can do what |
| **Pod Security Standards** | Restricted, Baseline, Privileged profiles |
| **Network Policies** | Firewall between pods (usually wide open by default) |
| **Secrets** | Stored in etcd (must be encrypted at rest) |
| **Admission Controllers** | Gatekeeper for pod specs (OPA, Kyverno) |
| **Service Account Token** | Auto-mounted into pods (disable if not needed) |

### Kubernetes Attack Paths to Practice

```
1. Privileged container → host filesystem access
   kubectl run priv --image=alpine --privileged --rm -it -- /bin/sh
   # Inside: chroot /host

2. Mounted Docker socket → escape to host Docker
   docker.sock mounted as volume → docker ps from container

3. Overpermissioned service account → lateral movement
   kubectl auth can-i --list  # check permissions

4. Exposed kubelet API (10250) → node compromise
   curl https://<node>:10250/pods --insecure

5. etcd access → read all cluster secrets
   etcdctl get /registry/secrets --prefix
```

---

## C.4 Infrastructure as Code Security

### Concepts

- **IaC misconfiguration** as root cause of cloud breaches ( Capital One, etc.)
- **Policy-as-code:** Define security rules in code (Checkov, tfsec)
- **Shift-left security:** Find issues before deployment
- **Drift detection:** Catch manual changes that bypass IaC

### What to Scan For

```
HIGH PRIORITY:
├── Public S3 buckets (acl = "public-read")
├── Security groups with 0.0.0.0/0 on sensitive ports (22, 3389, 3306)
├── Missing encryption (at rest + in transit)
├── Wildcard IAM policies ("*" on resource or action)
├── Hardcoded secrets in Terraform/CloudFormation
└── Missing logging/audit configuration

MEDIUM PRIORITY:
├── Unencrypted EBS volumes
├── Missing versioning on S3
├── Overly permissive Lambda execution roles
└── Missing backup/retention policies
```

---

## C.5 Tools

| Tool | Purpose | Local? |
|---|---|---|
| **LocalStack** | AWS API emulation (S3, IAM, Lambda, etc.) | Yes |
| **minikube** or **k3s** | Local Kubernetes cluster | Yes |
| **Checkov** | IaC static analysis (Terraform, CloudFormation, K8s) | Yes |
| **tfsec** | Terraform-specific security scanning | Yes |
| **Trivy** | Container image + IaC scanning | Yes |
| **kube-bench** | Kubernetes CIS benchmark | Yes |
| **kube-score** | Kubernetes object recommendations | Yes |
| **Docker** | Container runtime | Yes |
| **Proxmox** | Full local cloud infrastructure (optional) | Yes |

---

## C.6 Mini Projects

### C.6.1 — Cloud Misconfiguration Lab

In LocalStack: deploy 8 of the 10 misconfiguration classes from C.2.

For each:
1. Document the misconfiguration (Terraform/config)
2. Demonstrate exploitation
3. Write the remediated config
4. Write a Checkov rule that detects it

**Package as a reproducible lab:**
```
cloud-misconfig-lab/
├── docker-compose.yml          # LocalStack + supporting services
├── terraform/
│   ├── main.tf                 # Deploys all 8 misconfigurations
│   └── variables.tf
├── exploits/
│   ├── exploit_s3_public.py
│   ├── exploit_iam_wildcard.py
│   └── ...
├── remediations/
│   ├── fixed_s3.tf
│   └── ...
├── checkov_rules/
│   ├── S3PublicRead.yaml
│   └── ...
└── README.md                   # Lab guide with screenshots
```

### C.6.2 — Kubernetes Attack Chain

In minikube:

1. Deploy vulnerable configuration:
   - Privileged pod
   - Exposed service account token
   - Weak RBAC (cluster-admin binding)

2. Document full attack chain:
   ```
   Service discovery → Exploit exposed pod 
   → Privilege escalation to cluster-admin 
   → Secret extraction from all namespaces
   ```

3. Write kube-bench remediation plan

### C.6.3 — IaC Security Scanner

```python
# iac_scanner.py
# Wraps Checkov and tfsec:

# 1. Run both tools against target directory
# 2. Deduplicate findings (same issue found by both tools)
# 3. Enrich each finding:
#    - Attack scenario (how would this be exploited)
#    - Blast radius (what's the impact)
#    - Real-world incident reference (e.g., "Similar to Capital One breach")
#    - Fix: corrected code snippet
# 4. Risk prioritization:
#    - Public exposure + sensitive data = Critical
#    - Privilege escalation potential = High
#    - Missing defense-in-depth = Medium
#    - Best practice = Low
# 5. Output: risk-prioritized HTML + JSON report
```

---

## Track C Capstone — Cloud Security Assessment

### What It Is
A full simulated cloud security assessment of a fictional company environment built in LocalStack.

### Build Phase

Create a realistic multi-service environment:

```hcl
# Terraform for LocalStack
# Services to deploy:
# 1. S3 buckets (some public, some with sensitive data)
# 2. IAM users, roles, policies (some wildcard)
# 3. Lambda functions (some with excessive permissions)
# 4. RDS instance (simulated, with weak password)
# 5. VPC with security groups (some wide open)
# 6. CloudTrail (partially disabled)
# 7. EC2 instance metadata (vulnerable to SSRF)
```

### Assessment Phase

1. **Enumerate all resources:** Use AWS CLI against LocalStack
2. **Identify misconfigurations:** Manual review + automated scanning
3. **Exploit each finding:** Demonstrate actual impact
4. **Document blast radius:** What else could an attacker access?
5. **Write the assessment report:**

```
EXECUTIVE SUMMARY
├── Cloud environment overview
├── Risk rating (Critical/High/Medium/Low count)
└── Top 3 priority fixes

METHODOLOGY
├── Tools used (Checkov, tfsec, manual review)
├── Assessment scope
└── Time period

FINDINGS
├── [CRITICAL] Public S3 bucket with customer data
├── [HIGH] Wildcard IAM policy allows s3:*
├── [HIGH] Lambda has RDS full access + exposed env vars
├── [MEDIUM] CloudTrail disabled for us-east-1
├── [MEDIUM] Security group allows 0.0.0.0/0 on port 22
└── ...

REMEDIATION ROADMAP
├── Immediate (24-48 hours)
├── Short-term (1-2 weeks)
└── Long-term (1-3 months)
```

### Deliverable

Assessment report in the style of a real cloud security engagement. Publish on GitHub.

---

*v2 — Local-first · Free · No KYC · No Subscriptions*
