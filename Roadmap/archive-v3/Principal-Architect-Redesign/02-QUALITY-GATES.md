# Quality Gates Framework

> This file defines how progress is measured in the redesigned roadmap. It replaces time-based deadlines with evidence-based capability gates.

---

## 1. Purpose

The roadmap should not ask: "How many weeks did this take?"

It should ask:

> Can you explain it, build it, break it, defend it, detect it, operate it, and architect with it?

Quality gates prevent shallow completion.

---

## 2. Completion Levels

Each important concept should be marked with one of these states.

| Status | Meaning |
|---|---|
| `- [ ]` | Not started. |
| `- [x]` | Completed to the required quality gate. |
| `- [~] item — reason` | Skipped, blocked, or deferred with reason. |

A topic is not complete just because it was read.

---

## 3. Universal Concept Gate

For every important concept:

- [ ] I can define it in plain language.
- [ ] I can explain the internal mechanism step by step.
- [ ] I can identify where it appears in real systems.
- [ ] I can explain the attack surface.
- [ ] I can perform at least one hands-on exercise.
- [ ] I can explain at least one defensive control.
- [ ] I can identify useful logs, traces, or telemetry.
- [ ] I can explain one common misconception.
- [ ] I can answer recall questions without notes.

---

## 4. Security Gate

For every security-relevant topic:

- [ ] I can describe the threat model.
- [ ] I can demonstrate or simulate the failure mode safely.
- [ ] I can explain attacker prerequisites and constraints.
- [ ] I can implement or describe prevention controls.
- [ ] I can implement or describe detection controls.
- [ ] I can explain blast radius.
- [ ] I can recommend remediation.
- [ ] I can explain residual risk after remediation.

---

## 5. Build Gate

For every build project:

- [ ] It runs locally.
- [ ] It has clear setup instructions.
- [ ] It has tests or verification steps.
- [ ] It handles expected errors safely.
- [ ] It avoids hardcoded secrets.
- [ ] It has a README explaining what it does and why it matters.
- [ ] It includes security notes.
- [ ] It includes limitations and future improvements.

---

## 6. Attack Lab Gate

For every attack lab:

- [ ] The lab is isolated and authorized.
- [ ] The vulnerable condition is documented.
- [ ] The exploit path is reproduced.
- [ ] The mechanism is explained, not only the command/tool.
- [ ] Evidence is captured.
- [ ] The impact is explained.
- [ ] A defense or mitigation is included.
- [ ] A detection artifact is identified.

---

## 7. Defense Lab Gate

For every defense lab:

- [ ] The control maps to a real threat.
- [ ] The control is implemented or configured.
- [ ] The attack is retested after the defense.
- [ ] The result is documented.
- [ ] Remaining bypasses or limitations are listed.
- [ ] Logs or telemetry are reviewed.
- [ ] Operational maintenance is considered.

---

## 8. Architecture Gate

For every architecture artifact:

- [ ] Trust boundaries are shown.
- [ ] Identities are listed.
- [ ] Assets and sensitive data are identified.
- [ ] Secrets and keys are accounted for.
- [ ] Authorization points are shown.
- [ ] Network flows are shown.
- [ ] Failure modes are documented.
- [ ] Attack paths are documented.
- [ ] Controls are mapped to threats.
- [ ] Tradeoffs are explicit.
- [ ] Residual risk is stated.

---

## 9. Recall Gate

Before exiting a module:

- [ ] Answer definition questions without notes.
- [ ] Walk through at least one mechanism from memory.
- [ ] Explain one attack path from memory.
- [ ] Explain one defensive design from memory.
- [ ] Connect the topic to at least two previous topics.
- [ ] Identify one place this topic appears in later phases.

---

## 10. Phase Exit Gate

A phase is complete only when:

- [ ] All critical concepts meet the universal concept gate.
- [ ] All required hands-on exercises are completed.
- [ ] Mini projects meet the build gate.
- [ ] Security labs meet attack/defense gates.
- [ ] Architecture artifacts meet the architecture gate.
- [ ] Recall checks are passed.
- [ ] Common mistakes are documented.
- [ ] Deferred items are logged with reasons.

---

## 11. Principal-Level Gate

For the final target role, evidence must show:

- [ ] Depth in security mechanisms.
- [ ] Ability to build secure systems.
- [ ] Ability to break systems ethically in labs.
- [ ] Ability to design defenses.
- [ ] Ability to reason across blockchain, AI, cloud, identity, and networks.
- [ ] Ability to write clear architecture decisions.
- [ ] Ability to explain risk to both technical and non-technical audiences.
- [ ] Ability to operate systems with telemetry, response, and resilience.

---

## 12. Anti-Shallow-Completion Rule

Do not mark a topic complete if the only evidence is:

- [ ] Watched a video.
- [ ] Read a blog post.
- [ ] Copied a command.
- [ ] Ran a tool without understanding output.
- [ ] Built a toy project with no security analysis.
- [ ] Wrote notes with no recall check.

Reading is allowed, but reading alone is not completion.
