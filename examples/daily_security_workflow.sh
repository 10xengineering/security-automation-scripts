#!/bin/bash
# Daily Security Operations Workflow Example
# 
# This script demonstrates how to use all three security automation tools
# in a typical SOC daily workflow. Run this every morning to:
# 1. Process overnight SIEM alerts
# 2. Collect compliance evidence (if needed)  
# 3. Update incident response runbooks (weekly)
#
# Usage: ./daily_security_workflow.sh [monday|compliance-day]

set -euo pipefail

echo "🚀 Starting Daily Security Workflow - $(date)"

# Configuration
CONFIG_DIR="./examples"
SIEM_CONFIG="${CONFIG_DIR}/config.json"
LOG_FILE="./logs/security_workflow_$(date +%Y%m%d).log"

# Create log directory if it doesn't exist
mkdir -p logs

# Function to log with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Step 1: Process overnight SIEM alerts
log "🔍 Processing overnight SIEM alerts..."
if python3 examples/siem_splunk.py --config "$SIEM_CONFIG"; then
    log "✅ SIEM alert processing completed successfully"
else
    log "❌ SIEM alert processing failed - check configuration"
    exit 1
fi

# Step 2: Compliance evidence collection (if today is compliance day)
if [[ "${1:-}" == "compliance-day" ]]; then
    log "📋 Collecting compliance evidence..."
    if ./examples/compliance_enhanced.sh general; then
        log "✅ Compliance evidence collected successfully"
    else
        log "❌ Compliance evidence collection failed"
    fi
fi

# Step 3: Update runbooks (Mondays only)
if [[ "${1:-}" == "monday" ]] || [[ "$(date +%u)" == "1" ]]; then
    log "📖 Updating incident response runbooks..."
    if powershell.exe -File examples/custom_runbooks.ps1; then
        log "✅ Incident response runbooks updated"
    else
        log "⚠️  Runbook update failed - manual review needed"
    fi
fi

# Summary
log "🎉 Daily security workflow completed!"
log "📊 Check Jira for new security tasks"
log "📁 Review logs in: $LOG_FILE"

# Quick stats
JIRA_TICKETS=$(grep -c "Created Jira ticket" "$LOG_FILE" 2>/dev/null || echo "0")
log "📈 Summary: $JIRA_TICKETS new security tickets created today"

echo ""
echo "🔗 Quick Links:"
echo "   Jira Dashboard: https://company.atlassian.net/projects/SEC"
echo "   SIEM Console: https://splunk.company.com"
echo "   Today's Log: $LOG_FILE"
