# Evidence Handling Rules

## Purpose

Evidence is the raw material of learning. Without discipline in handling it, you cannot
prove what happened, reproduce results, or learn from mistakes.

## Rules

1. ALWAYS use bind mounts for evidence directories inside containers.
2. NEVER edit raw evidence files — annotate findings in a separate `.notes.txt` file.
3. ALWAYS name evidence: `YYYY-MM-DD-tool-target-description.ext`
4. ALWAYS copy evidence from the bind mount to `learning/phases/phase-N-*/evidence/` after each session.
5. FLAG any evidence containing passwords, tokens, or PII in a companion notes file.
6. DELETE evidence from the Kali container after copying to the host.
7. KEEP evidence until the related session's learning note is written.

## Evidence Flow

```
Container writes → bind mount (building/labs/evidence/)
                  → after session: copy to phase archive (learning/phases/phase-N-*/evidence/)
                  → delete from bind mount
```
