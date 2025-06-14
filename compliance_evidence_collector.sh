#!/bin/bash
# compliance_evidence_collector.sh
#
# Collect logs, configs, and docs for compliance audits in one easy package.
# Spend less time chasing files, more time getting things DONE.

echo "Let's make compliance a breeze! 🚀"

EVIDENCE_DIRS=(
    "/var/log"
    "/etc"
    "$HOME/security-policies"
)
OUTPUT="compliance_evidence_$(date +%Y%m%d).tar.gz"

tar -czf $OUTPUT "${EVIDENCE_DIRS[@]}"
echo "Evidence package created: $OUTPUT"
