# Session 11 — Mini-Project 14.3: Evidence Pipeline Starter

> **Roadmap ref:** `PHASE-0-SECURE-LAB.md` §14.3
> **Date:** Planned
> **Status:** [ ] Planned
> **Prerequisites:** Sessions 8-10 complete, all targets deployed, isolation verified

---

## Session Goals

- [ ] Write a reusable evidence pipeline script (bash)
- [ ] Test the pipeline end-to-end: start lab → run scan → capture evidence → stop lab → archive
- [ ] Verify evidence lands in the right places with the right naming convention
- [ ] Save pipeline to `building/labs/evidence-pipeline.sh`

---

## Chunk 1 — Design the Pipeline

### Teaching Points

1. **What a pipeline is:** A sequence of steps that takes raw input (tool output, pcap, logs) and produces organized output (named files in the right directories). Not automated scanning — organized evidence collection.
2. **Why it matters:** In Phase 1+, you'll run dozens of scans. Without a repeatable pipeline, you'll lose evidence, misname files, or forget to archive. The pipeline enforces the 7 evidence handling rules from Module 0.5.
3. **The flow:** Start targets → Start Kali → Run scan → Write to bind mount → Copy to phase archive → Stop containers

### Design

```bash
#!/bin/bash
# evidence-pipeline.sh — Phase 0 evidence collection pipeline
# Usage: ./evidence-pipeline.sh <tool> <target> <description>
# Example: ./evidence-pipeline.sh nmap <target-ip> "full-scan"

EVIDENCE_DIR="/evidence"            # bind mount inside container
PHASE_ARCHIVE="/host-mount/learning/phases/phase-0-secure-lab/evidence"
DATE=$(date +%Y-%m-%d)
TOOL=$1
TARGET=$2
DESCRIPTION=$3
FILENAME="${DATE}-${TOOL}-${TARGET}-${DESCRIPTION}"

# Step 1: Run the tool, capture output
# Step 2: Save to bind mount with naming convention
# Step 3: Copy to phase archive
# Step 4: Delete from container bind mount
```

---

## Chunk 2 — Build and Test the Pipeline

### Hands-On Steps

1. Write the script with: tool execution, filename generation, bind mount save, archive copy, cleanup
2. Test with nmap scan against DVWA
3. Verify: file appears in bind mount → copied to archive → deleted from container
4. Test with tcpdump capture
5. Document the pipeline in `building/labs/EVIDENCE-PIPELINE.md`

---

## Chunk 3 — End-to-End Test

### Teaching Points

1. **Why end-to-end:** Individual steps working doesn't mean the pipeline works as a whole. The test is: can you destroy all containers and still have your evidence?
2. **The acid test:** Run the pipeline → `docker rm` every container → Check the archive directory → Evidence must still be there.

### Hands-On Steps

1. Full pipeline run: start lab → scan all 3 targets → capture evidence → archive → stop
2. Destroy containers: `docker rm -f kali dvwa webgoat juiceshop`
3. Check archive: verify files exist in `learning/phases/phase-0-secure-lab/evidence/`
4. Rebuild lab: follow snapshot/restore plan from Session 9
5. Confirm lab works again after rebuild

---

## Quiz Questions

1. You run the pipeline and the archive copy fails (disk full). What evidence do you still have, and what's lost? How would you detect this failure in a real session?
2. Why is "delete from container after archive copy" the last step, not the first? What happens if you reverse the order?

---

## After Session

- [ ] Write learning note: `notes/13-evidence-pipeline.md`
- [ ] Update `phase-0-progress-tracker.md`: Mini-Project 14.3 → ✅
- [ ] Update `learning/progress-tracker.md`
- [ ] Write session record: `learning/session-records/SESSION-011.md`
- [ ] Commit and push
