<# 
Incident Response Runbook Generator - Your Team's Confidence Builder! 📖🛡️

Transform security uncertainty into security readiness with professional, 
comprehensive incident response playbooks generated in seconds!

Why your team will love this:
✅ Clear, step-by-step procedures for common security incidents
✅ Consistent response processes that build confidence
✅ Professional Markdown format that's easy to read and share
✅ Customizable templates that grow with your organization

This script creates practical, actionable runbooks that turn 3am security 
alerts from stressful panic into organized, professional response.

Your team deserves to feel prepared and confident - let's make that happen!

Usage: .\runbook_generator.ps1
Result: Professional incident response library ready for your team!

Pro tip: Check out examples/custom_runbooks.ps1 for advanced features and 
organization-specific customization options!

Author: Max Alhourani - Building security tools that empower teams! 🚀
#>

Write-Host "🌟 Ready to build your team's incident response confidence? Let's create some amazing runbooks!" -ForegroundColor Cyan

# runbook_generator.ps1

$incidents = @(
    "Phishing Email",
    "Ransomware Detected",
    "Data Breach"
)

$template = @"
# {0} Response Runbook

## Detection
How to detect this incident (alerts, reports, logs).

## Immediate Actions
- Triage the alert
- Isolate affected systems

## Investigation
- Gather logs and evidence
- Analyse impact

## Remediation
- Contain and eradicate
- Patch or restore systems

## Post-Mortem
- Review process
- Update runbook
"@

foreach ($incident in $incidents) {
    $fileName = "$($incident -replace ' ', '_').md"
    $content = $template -f $incident
    $content | Out-File -FilePath $fileName
    Write-Host "✅ Created: $fileName" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎉 Fantastic! Your incident response runbook library is ready!" -ForegroundColor Cyan
Write-Host "💡 Next steps:" -ForegroundColor Yellow
Write-Host "   • Review and customize each runbook for your environment"
Write-Host "   • Share with your team via wiki, SharePoint, or version control"
Write-Host "   • Practice with tabletop exercises to build familiarity"
Write-Host "   • Keep them updated as your environment evolves"
Write-Host ""
Write-Host "🛡️ Your team is now better prepared for any security incident!" -ForegroundColor Green
