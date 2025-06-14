# Daily Security Operations Workflow (Windows PowerShell)
# 
# This script demonstrates how to use all three security automation tools
# in a typical SOC daily workflow for Windows environments.
#
# Usage: .\daily_security_workflow.ps1 [-Monday] [-ComplianceDay]

param(
    [switch]$Monday,
    [switch]$ComplianceDay
)

# Configuration
$ConfigDir = ".\examples"
$SiemConfig = "$ConfigDir\config.json"
$LogFile = ".\logs\security_workflow_$(Get-Date -Format 'yyyyMMdd').log"

# Create log directory if it doesn't exist
if (-not (Test-Path ".\logs")) {
    New-Item -ItemType Directory -Path ".\logs" -Force
}

# Function to log with timestamp
function Write-Log {
    param([string]$Message)
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "[$Timestamp] $Message"
    Write-Host $LogEntry
    Add-Content -Path $LogFile -Value $LogEntry
}

Write-Host "🚀 Starting Daily Security Workflow - $(Get-Date)" -ForegroundColor Green

try {
    # Step 1: Process overnight SIEM alerts
    Write-Log "🔍 Processing overnight SIEM alerts..."
    
    $SiemResult = python examples\siem_splunk.py --config $SiemConfig
    if ($LASTEXITCODE -eq 0) {
        Write-Log "✅ SIEM alert processing completed successfully"
    } else {
        Write-Log "❌ SIEM alert processing failed - check configuration"
        throw "SIEM processing failed"
    }

    # Step 2: Compliance evidence collection (if compliance day)
    if ($ComplianceDay) {
        Write-Log "📋 Collecting compliance evidence..."
        
        # For Windows, use PowerShell equivalent or WSL
        if (Get-Command wsl -ErrorAction SilentlyContinue) {
            wsl ./examples/compliance_enhanced.sh general
        } else {
            Write-Log "⚠️  WSL not available - using Windows compliance collection"
            # Add Windows-specific compliance collection here
        }
        
        if ($LASTEXITCODE -eq 0) {
            Write-Log "✅ Compliance evidence collected successfully"
        } else {
            Write-Log "❌ Compliance evidence collection failed"
        }
    }

    # Step 3: Update runbooks (Mondays or when explicitly requested)
    $IsMonday = (Get-Date).DayOfWeek -eq 'Monday'
    if ($Monday -or $IsMonday) {
        Write-Log "📖 Updating incident response runbooks..."
        
        .\examples\custom_runbooks.ps1
        if ($LASTEXITCODE -eq 0) {
            Write-Log "✅ Incident response runbooks updated"
        } else {
            Write-Log "⚠️  Runbook update failed - manual review needed"
        }
    }

    # Summary
    Write-Log "🎉 Daily security workflow completed!"
    Write-Log "📊 Check Jira for new security tasks"
    Write-Log "📁 Review logs in: $LogFile"

    # Quick stats
    $JiraTickets = (Select-String -Path $LogFile -Pattern "Created Jira ticket" -ErrorAction SilentlyContinue).Count
    Write-Log "📈 Summary: $JiraTickets new security tickets created today"

    Write-Host ""
    Write-Host "🔗 Quick Links:" -ForegroundColor Cyan
    Write-Host "   Jira Dashboard: https://company.atlassian.net/projects/SEC"
    Write-Host "   SIEM Console: https://splunk.company.com"
    Write-Host "   Today's Log: $LogFile"

} catch {
    Write-Log "❌ Workflow failed: $($_.Exception.Message)"
    Write-Host "Check the log file for details: $LogFile" -ForegroundColor Red
    exit 1
}

# Optional: Open Jira dashboard if requested
if ($env:OPEN_JIRA -eq "true") {
    Start-Process "https://company.atlassian.net/projects/SEC"
}
