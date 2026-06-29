#!/bin/bash
# System Security Auditor
# Checks for common security misconfigurations

echo "═══════════════════════════════════════════"
echo "  System Security Audit Report"
echo "  Generated: $(date)"
echo "═══════════════════════════════════════════"
echo ""

# ── Check 1: SUID binaries ──────────────────
echo "[1/5] Checking SUID binaries..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
suid_files=$(find / -path /mnt -prune -o -perm -4000 -type f -print 2>/dev/null)
if [ -n "$suid_files" ]; then
    echo "$suid_files"
    count=$(echo "$suid_files" | wc -l)
    echo "→ Found $count SUID binaries"
else
    echo "→ No SUID binaries found"
fi
echo ""

# ── Check 2: World-writable files ────────────
echo "[2/5] Checking world-writable files..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ww_files=$(find / -path /mnt -prune -o -perm -0002 -type f -print 2>/dev/null)
if [ -n "$ww_files" ]; then
    echo "$ww_files" | head -20
    count=$(echo "$ww_files" | wc -l)
    echo "→ Found $count world-writable files (showing first 20)"
else
    echo "→ No world-writable files found"
fi
echo ""
