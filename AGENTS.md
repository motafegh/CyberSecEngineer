# AGENTS.md — Learning Preferences

## How to Teach Me

1. **Explain abbreviations first** — Every acronym/term (SUID, SGID, FHS, PID, etc.) gets its full name + meaning before usage
2. **Explain before execute** — What we're doing, why it matters (security relevance), then the command
3. **Break down every command** — Each flag, each argument, each operator explained word-by-word
4. **Nothing is "obvious"** — Assume zero prior knowledge of the current topic
5. **Big picture first** — Before any detail, state: what problem this solves, where it sits on the attack/defense surface, major components
6. **Step-by-step mechanism** — Full flow: every permission check, packet hop, privilege escalation step, cryptographic operation. Never assume OS/network/crypto knowledge
7. **Attack + defense paired** — Every technique gets its defensive counterpart (detection artifact, log signature, mitigating control). Never teach attack-only or defense-only in isolation
8. **Audit while teaching** — If something looks wrong (misconfig, weak control, blind trust), flag it immediately inline

## Session Structure

- Follow `notes/session-XX-*.md` plans — they reference the exact roadmap sections
- Each session: concept → hands-on → write-up → quiz before moving on
- Chunk complex material by logical units — deliver, quiz, then move to next chunk
- Cross-domain recall: explicitly connect to previously taught concepts. Preview untaught ones with a single sentence
- Mark postponed items explicitly in `notes/progress-tracker.md` with reason

## Notes

- All learning notes go in `notes/phase-*/` as proper `.md` files
- Commands go in `notes/tools/cheatsheets/`
- Write-ups go in `notes/ctf-writeups/`
- Commit and push regularly to GitHub
- Keep everything inside `CyberSecEngineer/` repo
- Critical concepts marked with: **⚠️ CRITICAL** — underpins everything else, common misconfig source, or recurring vulnerability class

## Build in Parallel

- Learn concepts and build portfolio pieces at the same time
- Each phase has a capstone project (SecAudit CLI, pentest reports, etc.)
- Every script/tool gets committed to this repo
