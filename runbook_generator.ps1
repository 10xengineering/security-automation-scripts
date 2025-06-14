<# 
runbook_generator.ps1

Need a runbook fast? This script creates clean Markdown incident response guides in seconds.
Practical, repeatable, and easy to tweak—just like security should be.

Author: Max Alhourani
#>

Write-Host "Ready to generate your incident response runbooks? Let's do this! 💡"

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
    Write-Host "Created: $fileName"
}
