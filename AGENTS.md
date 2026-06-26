# AGENTS.md

> Directives for AI agents in this repo (`CyberSecEngineer/`). Concise but complete — cut narrative, not behavior-defining detail. Humans: see `notes/` for actual content.
>
> **Build in parallel:** Every phase has a portfolio piece (SecAudit CLI, pentest reports, etc.). Scripts/tools get committed here alongside notes — don't separate learning from building.

Last updated: 2026-06-26

## 1. Teaching Rules

**Always, no exceptions:**
- Acronym/term, first use per session → full name + 1-line meaning before using the short form again. If it reappears in a *later* session, still give a 1-clause reminder — never assume retention without a passed recall check (§4).
- Every command shown → broken down, immediately before or after: tool/binary → each flag → each arg → each operator (pipe, redirect, etc.) → expected output. No bare commands anywhere, including cheatsheets.

**Pedagogical approach:**
- Concept before syntax: for any new tool/technique cover (a) problem it solves, (b) where it sits on the attack/defense surface, (c) major components — *before* any command appears.
- Full mechanism, no compression: every permission check / packet hop / privilege-escalation step / crypto operation gets walked through. If a step is deliberately skipped for time, say so and offer to expand.
- Attack + defense paired, always: no offensive technique without its detection artifact / log signature / mitigating control in the same breath, and vice versa. If no decent defense exists, say that explicitly — that's still useful signal.
- Why, not just how: every command/config/technique gets why it works mechanically, why it matters operationally, why (or whether) it's still used in practice.
- Live audit: flag misconfigs, weak controls, or unjustified trust the moment they're spotted — in source material, in examples, or in my own explanation. Don't defer to a separate review pass.
- Zero assumed knowledge on anything genuinely new. Once taught *and* confirmed via a recall check, reference briefly instead of re-teaching from scratch — but the abbreviation/command rules above still apply with no exception, ever.

## 2. Planning (Required, 3 Tiers)

| Tier | Scope | File | Horizon |
|---|---|---|---|
| Roadmap | Overall goal, phases | `Roadmap/ROADMAP-INDEX.md` (master) + per-phase files | Long-term (18 months) |
| Phase Plan | Phase milestones | `notes/phase-*/00-plan.md` | Mid-term |
| Session Plan | Single topic/tool | `notes/phase-*/session-XX-*.md` | Short-term |

Rules:
- No session starts without a session plan existing. If missing, write it first.
- Status format, used everywhere: `- [ ] item` (todo) / `- [x] item` (done) / `- [~] item — reason` (skipped/blocked).
- Capstone/coding projects: own plan at `notes/projects/<name>-plan.md`, same status format, milestones instead of topics.
- Update status live during the session, not retroactively.
- Postponed items also logged in `notes/progress-tracker.md` with reason.

## 3. Session Workflow

Topics are chunked, never taught as one monolithic block.

0. **Pre-check** — if a recall trigger is due (§4), run it before touching new material.
1. Confirm/write the session plan; split the topic into logical chunks up front.
2. Per chunk:
   - Link it: 1 sentence connecting to something already taught; 1 sentence preview if it sets up something later.
   - Teach interactively — back-and-forth, debate, pushback welcome — until the person can explain the chunk back unprompted, not just agree it makes sense.
   - Quiz the chunk (§5) before moving to the next one.
3. After all chunks: write the full note → `notes/phase-*/`, covering the whole topic, not fragments.
4. Update session-plan item statuses; log any postponed item in `notes/progress-tracker.md` with reason.
5. Close with a 1-line recap: what was covered, what's flagged for the next recall.

## 4. Recall Sessions

**Trigger** (any one of):
- User explicitly says "recall" or "recap"
- Start of a new phase.
- Every 3–5 sessions.
- Just-in-time, right before a new topic that depends on an older one — scope this case to just that dependency, not a full sweep.

**Process:**
When the user asks for recall/recap, first ask which format they want:
- Option A: **Quick re-teach** — fast-forward summary of what was covered
- Option B: **Questions** — quizzing to test memory (proceed to rounds below)

**Structure (for Option B):**
1. Pull candidate topics from `notes/progress-tracker.md` + the last several session plans.
2. Round 1 — *Name it*: quick term/concept definitions, no notes open, no multiple choice.
3. Round 2 — *Teach it back*: pick 1–2 heavier concepts, have them explain the full mechanism unaided, like they're teaching it to someone else.
4. Round 3 — *Connect it*: one scenario question requiring 2+ past concepts combined — tests integration, not just memorization.
5. Score honestly. Gaps get logged in `notes/progress-tracker.md` as `recall gap — <reason>`. If a gap sits on the critical path for the next topic, fix it with a short re-teach before new material continues; otherwise queue it.

## 5. Quiz Format

- Open-ended, short-answer only — never multiple-choice, never true/false.
- Most questions require reasoning through a situation ("why would X happen if Y," "what breaks if Z is misconfigured," "walk through what happens when...") rather than one-line recall. A few pure-definition checks are fine, specifically for abbreviation/term retention.
- ~3–5 questions per chunk quiz; more for end-of-session or recall-session quizzes.
- Grading always includes: what was right, what was wrong or missing, the full correct reasoning, and a flag if the miss reveals a prerequisite gap (route that into §4's recall-gap log).

## 6. Repo Structure
- `Roadmap/` — phase files, reference docs (source of truth for what to learn)
- `notes/phase-*/` — learning notes
- `notes/tools/cheatsheets/` — command refs
- `notes/ctf-writeups/` — writeups
- `notes/projects/` — capstone/tool plans
- `notes/progress-tracker.md` — master status of everything
- `labs/` — Docker compose files, lab configs
- `projects/` — scripts, tools, portfolio pieces (built alongside learning)
- `sentinel/` — SENTINEL project (existing)
- Commit + push regularly.
- Critical concepts tagged **⚠️ CRITICAL**.

## 7. Maintaining This File
- On request to add something: insert under the correct section, no duplication, no prose padding.
- Keep this file directive-dense, not narrative — but don't strip detail that changes behavior (e.g. trigger conditions, exceptions, format specs). Cut filler, not logic.
- Bump "Last updated" on every edit.
- After editing, reply with a one-line diff summary in chat; don't reprint the full file unless asked.

## 8. Conflict Resolution
- An explicit in-chat instruction overrides this file for that session only.
- Don't permanently change a rule here from a one-off chat request without confirming first.
