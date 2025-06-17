# Enhanced Incident Response Runbook Generator
# 
# This example extends the basic runbook generator with:
# - Custom incident types for your organization
# - Detailed response procedures
# - Contact information and escalation paths
# - Integration points for SIEM/ticketing systems
#
# Usage: .\custom_runbooks.ps1 [-IncidentType <type>] [-OutputPath <path>]

param(
    [string]$IncidentType = "all",
    [string]$OutputPath = ".\runbooks",
    [string]$OrganizationName = "Your Organization"
)

Write-Host "🔧 Enhanced Incident Response Runbook Generator" -ForegroundColor Cyan
Write-Host "Generating comprehensive runbooks for $OrganizationName..." -ForegroundColor Green

# Ensure output directory exists
if (!(Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    Write-Host "Created output directory: $OutputPath" -ForegroundColor Yellow
}

# Define comprehensive incident types with detailed responses
$IncidentTypes = @{
    "Phishing_Email" = @{
        "Title" = "Phishing Email Response"
        "Severity" = "Medium-High"
        "ResponseTime" = "15 minutes"
        "Description" = "Response procedures for suspected phishing emails"
    }
    "Ransomware_Attack" = @{
        "Title" = "Ransomware Attack Response"
        "Severity" = "Critical"
        "ResponseTime" = "Immediate"
        "Description" = "Critical response procedures for ransomware incidents"
    }
    "Data_Breach" = @{
        "Title" = "Data Breach Response"
        "Severity" = "High-Critical"
        "ResponseTime" = "30 minutes"
        "Description" = "Comprehensive data breach response procedures"
    }
    "Malware_Detection" = @{
        "Title" = "Malware Detection Response"
        "Severity" = "Medium-High"
        "ResponseTime" = "20 minutes"
        "Description" = "Response procedures for malware detection and containment"
    }
    "DDoS_Attack" = @{
        "Title" = "DDoS Attack Response"
        "Severity" = "High"
        "ResponseTime" = "10 minutes"
        "Description" = "Response procedures for Distributed Denial of Service attacks"
    }
    "Insider_Threat" = @{
        "Title" = "Insider Threat Response"
        "Severity" = "High"
        "ResponseTime" = "1 hour"
        "Description" = "Response procedures for suspected insider threats"
    }
    "System_Compromise" = @{
        "Title" = "System Compromise Response"
        "Severity" = "High-Critical"
        "ResponseTime" = "20 minutes"
        "Description" = "Response procedures for compromised systems"
    }
}

# Enhanced runbook template with detailed sections
$RunbookTemplate = @"
# {0} Runbook

**Document Version:** 1.0  
**Last Updated:** {1}  
**Severity Level:** {2}  
**Target Response Time:** {3}  
**Document Owner:** Security Operations Team

---

## 📋 Overview

{4}

### When to Use This Runbook
- [List specific triggers and scenarios]
- [Include SIEM alert conditions]
- [Reference specific detection signatures]

---

## 🚨 Immediate Response (First 5 Minutes)

### 1. Alert Verification
- [ ] Confirm the alert is legitimate (not a false positive)
- [ ] Document initial findings in incident ticket
- [ ] Notify Security Operations Manager if severity is High/Critical

### 2. Initial Containment
- [ ] Isolate affected systems if safe to do so
- [ ] Preserve evidence (avoid powering down systems)
- [ ] Begin timeline documentation

### 3. Communication
- [ ] Create incident ticket in [TICKET_SYSTEM]
- [ ] Notify stakeholders per escalation matrix
- [ ] Prepare initial status update

---

## 🔍 Detection & Analysis

### Evidence Collection
- [ ] Collect system logs from affected machines
  ```bash
  # Linux systems
  sudo journalctl --since "1 hour ago" > /tmp/system_logs.txt
  
  # Windows systems
  Get-WinEvent -FilterHashtable @{{LogName='System','Application','Security'; StartTime=(Get-Date).AddHours(-1)}} | Export-Csv -Path C:\temp\windows_logs.csv
  ```

- [ ] Network traffic analysis
  ```bash
  # Capture network traffic (if safe)
  tcpdump -i any -w /tmp/incident_capture.pcap
  ```

- [ ] Memory dump (if required)
- [ ] Disk imaging (if required)

### SIEM Queries
```sql
-- Example Splunk query for this incident type
index=security sourcetype=*
| search [RELEVANT_SEARCH_TERMS]
| eval incident_id="{5}"
| table _time, src_ip, dest_ip, action, signature
```

### IOC Analysis
- [ ] Check IOCs against threat intelligence feeds
- [ ] Correlate with historical incidents
- [ ] Update IOC database with new findings

---

## 🛡️ Containment Strategy

### Short-term Containment
- [ ] Network isolation of affected systems
- [ ] Disable compromised user accounts
- [ ] Block malicious IP addresses/domains
- [ ] Apply emergency patches if applicable

### Long-term Containment
- [ ] Implement additional monitoring
- [ ] Deploy compensating controls
- [ ] Update security policies
- [ ] Schedule system rebuilds if necessary

---

## 🧹 Eradication & Recovery

### Eradication Steps
1. [ ] Remove malware/malicious files
2. [ ] Close attack vectors
3. [ ] Update system configurations
4. [ ] Patch vulnerabilities
5. [ ] Reset compromised credentials

### Recovery Process
1. [ ] Restore systems from clean backups
2. [ ] Verify system integrity
3. [ ] Gradually restore network connectivity
4. [ ] Monitor for signs of reinfection
5. [ ] Update security tools and signatures

### Validation
- [ ] Vulnerability scans completed
- [ ] Penetration testing (if required)
- [ ] User acceptance testing
- [ ] Security control verification

---

## 📞 Communication & Escalation

### Internal Contacts
- **Security Operations Manager:** [NAME] - [PHONE] - [EMAIL]
- **IT Director:** [NAME] - [PHONE] - [EMAIL]
- **Legal Counsel:** [NAME] - [PHONE] - [EMAIL]
- **HR Director:** [NAME] - [PHONE] - [EMAIL]

### External Contacts
- **Cyber Insurance:** [CARRIER] - [PHONE] - [POLICY_NUMBER]
- **Legal/Forensics:** [FIRM] - [PHONE] - [EMAIL]
- **Law Enforcement:** [CONTACT] - [PHONE] - [EMAIL]
- **Regulatory Bodies:** [CONTACT] - [PHONE] - [EMAIL]

### Escalation Triggers
- [ ] Data exfiltration confirmed
- [ ] Customer data involved
- [ ] Media attention
- [ ] Regulatory notification required
- [ ] Business critical systems affected

---

## 📝 Documentation Requirements

### Incident Timeline
```
[TIMESTAMP] - Initial detection
[TIMESTAMP] - Response team notified
[TIMESTAMP] - Initial containment
[TIMESTAMP] - Analysis completed
[TIMESTAMP] - Eradication completed
[TIMESTAMP] - Recovery initiated
[TIMESTAMP] - Incident closed
```

### Evidence Chain of Custody
- [ ] Digital evidence properly preserved
- [ ] Chain of custody forms completed
- [ ] Evidence stored securely
- [ ] Access logging maintained

---

## 🔄 Post-Incident Activities

### Immediate (24-48 hours)
- [ ] Preliminary lessons learned session
- [ ] Stakeholder notifications complete
- [ ] Systems fully operational
- [ ] Monitoring enhanced

### Short-term (1-2 weeks)
- [ ] Detailed post-mortem completed
- [ ] Root cause analysis finished
- [ ] Corrective actions identified
- [ ] Timeline reconstruction validated

### Long-term (1 month)
- [ ] Process improvements implemented
- [ ] Training updates completed
- [ ] Policy updates approved
- [ ] Metrics and KPIs updated

---

## 📊 Metrics & KPIs

### Response Metrics
- **Time to Detection:** _____ minutes
- **Time to Response:** _____ minutes
- **Time to Containment:** _____ minutes
- **Time to Resolution:** _____ hours/days

### Business Impact
- **Systems Affected:** _____
- **Users Impacted:** _____
- **Downtime:** _____ hours
- **Estimated Cost:** $ _____

---

## 🔧 Tools & Resources

### Required Tools
- [ ] SIEM access ([SYSTEM_NAME])
- [ ] Network monitoring tools
- [ ] Forensics toolkit
- [ ] Communication channels (Slack/Teams)

### Reference Materials
- [Threat Intelligence Platform]
- [Company Security Policies]
- [Regulatory Guidelines]
- [Vendor Support Contacts]

---

## ✅ Checklist Summary

**Phase 1: Immediate Response**
- [ ] Alert verified and documented
- [ ] Initial containment completed
- [ ] Key stakeholders notified
- [ ] Evidence preservation started

**Phase 2: Investigation**
- [ ] Evidence collected and analyzed
- [ ] Scope and impact determined
- [ ] IOCs identified and shared
- [ ] Timeline established

**Phase 3: Containment & Eradication**
- [ ] Threat contained
- [ ] Vulnerabilities patched
- [ ] Malicious artifacts removed
- [ ] Additional controls implemented

**Phase 4: Recovery**
- [ ] Systems restored and validated
- [ ] Normal operations resumed
- [ ] Enhanced monitoring in place
- [ ] Lessons learned documented

---

**Document Control**
- **Created:** {1}
- **Review Frequency:** Quarterly
- **Next Review:** {6}
- **Approved By:** [SECURITY_DIRECTOR]

---

*This runbook is part of the {7} Incident Response Program*
*For questions or suggestions, contact: security-ops@company.com*
"@

# Function to generate individual runbook
function New-IncidentRunbook {
    param(
        [string]$IncidentKey,
        [hashtable]$IncidentData
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $nextReview = (Get-Date).AddMonths(3).ToString("yyyy-MM-dd")
    $incidentId = [System.Guid]::NewGuid().ToString().Substring(0,8).ToUpper()
    
    $runbookContent = $RunbookTemplate -f @(
        $IncidentData.Title,
        $timestamp,
        $IncidentData.Severity,
        $IncidentData.ResponseTime,
        $IncidentData.Description,
        $incidentId,
        $nextReview,
        $OrganizationName
    )
    
    $fileName = Join-Path $OutputPath "$IncidentKey.md"
    $runbookContent | Out-File -FilePath $fileName -Encoding UTF8
    
    Write-Host "✅ Created runbook: $fileName" -ForegroundColor Green
}

# Generate runbooks based on input parameter
if ($IncidentType -eq "all") {
    Write-Host "Generating all incident runbooks..." -ForegroundColor Cyan
    foreach ($incident in $IncidentTypes.GetEnumerator()) {
        New-IncidentRunbook -IncidentKey $incident.Key -IncidentData $incident.Value
    }
} elseif ($IncidentTypes.ContainsKey($IncidentType)) {
    Write-Host "Generating runbook for: $IncidentType" -ForegroundColor Cyan
    New-IncidentRunbook -IncidentKey $IncidentType -IncidentData $IncidentTypes[$IncidentType]
} else {
    Write-Host "❌ Unknown incident type: $IncidentType" -ForegroundColor Red
    Write-Host "Available types: $($IncidentTypes.Keys -join ', ')" -ForegroundColor Yellow
    exit 1
}

# Generate index file
$indexContent = @"
# Incident Response Runbooks - $OrganizationName

Generated on: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Available Runbooks

| Incident Type | Severity | Response Time | Description |
|---------------|----------|---------------|-------------|
"@

foreach ($incident in $IncidentTypes.GetEnumerator()) {
    $indexContent += "| [$($incident.Value.Title)](./$($incident.Key).md) | $($incident.Value.Severity) | $($incident.Value.ResponseTime) | $($incident.Value.Description) |`n"
}

$indexContent += @"

## Quick Reference

### Emergency Contacts
- **Security Operations:** [PHONE_NUMBER]
- **IT Support:** [PHONE_NUMBER]
- **Management:** [PHONE_NUMBER]

### Key Systems
- **SIEM:** [URL]
- **Ticketing:** [URL]
- **Communication:** [PLATFORM]

---

*For questions about these runbooks, contact the Security Operations team.*
"@

$indexPath = Join-Path $OutputPath "README.md"
$indexContent | Out-File -FilePath $indexPath -Encoding UTF8

Write-Host ""
Write-Host "🎉 Runbook generation complete!" -ForegroundColor Green
Write-Host "📁 Output directory: $OutputPath" -ForegroundColor Cyan
Write-Host "📚 Index file: $indexPath" -ForegroundColor Cyan
Write-Host "📊 Total runbooks: $($IncidentTypes.Count)" -ForegroundColor Cyan
