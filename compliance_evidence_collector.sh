#!/bin/bash
# Compliance Evidence Collector - Your Audit Anxiety Antidote! 📋✨
#
# Turn compliance stress into compliance success with one simple command!
# This script packages logs, configs, and security policies into a neat,
# timestamped archive that makes auditors smile and compliance officers sleep better.
#
# Why this makes your life easier:
# ✅ No more scrambling for files during audit season
# ✅ Consistent, professional evidence packaging
# ✅ Timestamps and organization that impresses auditors
# ✅ Works in 2 minutes instead of 2 days
#
# Usage: ./compliance_evidence_collector.sh
# Result: One beautiful archive ready for any auditor!
#
# Pro tip: Check out examples/compliance_enhanced.sh for framework-specific features!

echo "🚀 Let's make compliance a breeze! Your audit-ready package is coming right up..."

EVIDENCE_DIRS=(
    "/var/log"
    "/etc"
    "$HOME/security-policies"
)
OUTPUT="compliance_evidence_$(date +%Y%m%d).tar.gz"

tar -czf $OUTPUT "${EVIDENCE_DIRS[@]}"
echo "📦 Evidence package created: $OUTPUT"
echo "✨ Perfect! Your compliance evidence is ready for auditor review."
echo "💡 Pro tip: The timestamp in the filename helps track when evidence was collected."
echo "🎉 One more successful step towards stress-free compliance!"
