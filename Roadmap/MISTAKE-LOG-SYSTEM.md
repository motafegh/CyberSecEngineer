# Mistake Log System

> The mistake log is a living index of corrected misconceptions. It closes the gap between exposure and durable understanding.

---

## 1. What a Mistake Log Entry Is

A mistake log entry records one corrected misconception. It is not a list of errors in code or exercises. It is a record of a belief you held that was wrong — or a gap in understanding that caused repeated failure.

Each entry contains four fields:

**Misconception held:** The exact belief or assumption that was wrong. Written as a statement in first person. Example: "I thought JWT expiry was enforced by the library automatically."

**Correct understanding:** The accurate mental model. Written as a precise replacement. Example: "JWT expiry is a claim the server must check explicitly; the library only parses the token. Missing the `exp` check means expired tokens are accepted forever."

**Source of confusion:** Why the wrong belief formed. Example: "The library's `verify()` function name implied full validation. The docs do not prominently warn that expiry checking requires a flag."

**Recall test:** A specific question that, if answered correctly from memory, proves the misconception is resolved. Example: "What does a JWT library's verify function guarantee, and what must you add explicitly to enforce expiry?"

---

## 2. Where It Lives

Create one file per phase: `learning/mistakes/phase-0.md`, `learning/mistakes/phase-1.md`, and so on. Cross-phase mistakes go in `learning/mistakes/cross-phase.md`.

Each file is a flat list of dated entries with all four fields.

---

## 3. Entry Format

```markdown
## Entry: [short title]
Date: YYYY-MM-DD
Phase/Module: e.g. Phase 2 / Module 2.3

**Misconception held:**
[First-person statement of the wrong belief.]

**Correct understanding:**
[Precise replacement belief.]

**Source of confusion:**
[Why the wrong model formed.]

**Recall test:**
[A specific question whose correct answer proves closure.]

**Status:** Open / Closed
**Closed on:** YYYY-MM-DD
```

---

## 4. When to Add an Entry

Add an entry when any of these occur:

- You answered a recall check wrong and the correct answer surprised you.
- You made the same mistake twice in exercises or code.
- You discovered a belief was wrong only after seeing an exploit succeed in the lab.
- A teach-back exposed a gap you could not fill.
- An AI or peer corrected a specific factual claim you made confidently.

Do not add entries for things you never tried to understand. The log is for corrected beliefs, not reading lists.

---

## 5. Spaced Recall Protocol

The mistake log is not a static record. Use it actively.

**Weekly review:** Read all Open entries. Answer each recall test from memory without looking at the correct understanding. If you cannot answer correctly, the entry remains Open.

**Closing an entry:** An entry is Closed only when you answer its recall test correctly on two separate review sessions at least one week apart. Write the closed date.

**Phase transitions:** Before moving to the next phase, review all Open entries from the current and previous phases. Do not carry unresolved foundational mistakes forward.

**Long-term interleaving:** Every three phases, revisit the full closed log. If a closed entry's recall test is no longer answerable, reopen it.

---

## 6. What Does Not Go in the Log

- Syntax errors or tool usage mistakes that have no conceptual component.
- Things you looked up and used correctly the first time.
- Todo items, reading lists, or wishlist topics.
- Vague notes like "need to understand X better."

Every entry must have a specific, testable recall question. If you cannot write that question, the entry is not ready to log.

---

## 7. Signs the Log Is Working

- The number of Open entries decreases over a phase.
- You catch yourself about to repeat a closed mistake and self-correct.
- Teach-back sessions have fewer surprises.
- New entries appear less frequently in later phases because foundational models are stable.
