# Security Automation Scripts 🚀

Welcome! This is a growing toolkit of open-source scripts for anyone who wants to make security operations more efficient—and maybe even a bit more fun.  
Whether you’re automating SIEM triage, prepping for compliance, or looking to streamline incident response, you’ll find something here to help you move faster and worry less.

*Built by a believer in security, efficiency, and empowering teams with the right tools. Let’s make security simpler, together!*

---

## What’s Inside

### 🔍 **siem_alert_triage.py**
Cut through alert noise and focus on what really matters, with easy integration to Jira.

**Quick Start:**
```bash
# Basic usage
python siem_alert_triage.py

# With custom config
python siem_alert_triage.py --config my_config.json
```

**Real-world Example:**
```python
# Automatically process 100+ daily alerts, filter false positives,
# and create Jira tickets for true threats in under 30 seconds
alerts = fetch_high_priority_alerts()
actionable = [alert for alert in alerts if is_actionable(alert)]
create_jira_tickets(actionable)  # Only 5-10 real issues from 100+ alerts
```

**What it does:** Automatically fetches high/critical severity alerts from your SIEM and creates Jira tickets for actionable items.  
📁 **[See complete Splunk example →](./examples/siem_splunk.py)**

---

### 📋 **compliance_evidence_collector.sh**
Never scramble for audit evidence again—just run the script and let it handle the packaging.

**Quick Start:**
```bash
# Collect compliance evidence for today's audit
./compliance_evidence_collector.sh

# For specific frameworks
./compliance_enhanced.sh pci-dss
./compliance_enhanced.sh hipaa
```

**Real-world Example:**
```bash
# Friday afternoon audit surprise? No problem.
# Collect 6 months of logs, configs, and policies in 2 minutes
./compliance_enhanced.sh sox
# Output: compliance_evidence_sox_20250614_143022.tar.gz (ready for auditors)
```

**What it does:** Packages system logs, configurations, and security policies into a timestamped archive ready for auditors.  
📁 **[See enhanced compliance example →](./examples/compliance_enhanced.sh)**

---

### 📖 **runbook_generator.ps1**
Instantly create clear, practical incident response runbooks in Markdown. Copy, customise, and keep your team prepared.

**Quick Start:**
```powershell
# Generate standard incident response runbooks
.\runbook_generator.ps1

# Generate custom runbooks for your organization
.\custom_runbooks.ps1 -Incidents "DataBreach,RansomwareDetected"
```

**Real-world Example:**
```powershell
# 3am ransomware alert? Your team has the playbook ready.
# Generate 15 comprehensive incident response runbooks in seconds
.\custom_runbooks.ps1 -CompanyName "Acme Corp" -ContactEmail "security@acme.com"
# Output: Detailed step-by-step guides for every scenario
```

**What it does:** Creates standardized incident response runbooks in Markdown format for common security scenarios.  
📁 **[See custom runbook examples →](./examples/custom_runbooks.ps1)**

---

## For Business Leaders

You don’t need to be a developer to see the value here. These scripts are built to:

- **Save your team’s time** by automating repetitive security and compliance tasks
- **Reduce the risk of costly mistakes** in audits or daily checks
- **Boost your business’s cyber resilience** with easy, reliable solutions
- **Free up your people** to focus on the work that matters most

### Who can benefit?
- IT and security teams aiming to work smarter, not harder
- Business owners and managers who want peace of mind about cyber risks and compliance
- Anyone interested in making security less stressful and more effective

**Want help getting started, or curious how automation fits your business?**  
I’m happy to walk you through or customise a solution—no technical background needed. [![Connect with me on LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin&style=for-the-badge)](https://www.linkedin.com/in/alhourani)



---

## 🚀 Getting Started

### Prerequisites
- **Python 3.6+** (for siem_alert_triage.py)
- **Bash shell** (for compliance_evidence_collector.sh)
- **PowerShell 5.0+** (for runbook_generator.ps1)

### Configuration

**SIEM Alert Triage Setup:**
1. Update `SIEM_API` with your SIEM endpoint
2. Configure `JIRA_API` and authentication
3. Customize severity filters in `is_actionable()`

**Compliance Collector Setup:**
1. Modify `EVIDENCE_DIRS` array for your environment
2. Ensure script has read access to target directories
3. Run with appropriate permissions

**Runbook Generator Setup:**
1. Customize `$incidents` array for your organization
2. Modify the template to match your incident response process
3. Run from your desired output directory

---

## 💼 Real-World Usage Examples

### **SOC Team Daily Workflow**
```bash
# Morning routine: Process overnight alerts in 5 minutes instead of 2 hours
python examples/siem_splunk.py --config production.json
# Result: 127 alerts → 3 real incidents requiring attention
```

### **Compliance Audit Preparation**
```bash
# Audit next week? Collect everything in one command
./examples/compliance_enhanced.sh pci-dss
# Result: Complete evidence package ready for PCI auditors
```

### **Incident Response Team Setup**
```powershell
# New team member? Generate all playbooks instantly
.\examples\custom_runbooks.ps1 -CompanyName "YourCorp" -Emergency "911"
# Result: 15 customized incident response guides ready to use
```

---

## 📁 Examples

For complete, working examples with real configurations, check out the [`examples/`](./examples/) directory:

- **`examples/siem_splunk.py`** - Complete Splunk integration example
- **`examples/compliance_enhanced.sh`** - Customized compliance collection for different frameworks
- **`examples/custom_runbooks.ps1`** - Extended runbook templates
- **`examples/daily_security_workflow.sh`** - Complete SOC workflow automation
- **`examples/GETTING_STARTED.md`** - Step-by-step setup guide with real examples

**👉 [Start with the Getting Started Guide →](./examples/GETTING_STARTED.md)**

---

## Why?

Security work should be challenging—but not tedious. These scripts save time, cut down on manual headaches, and free you up for higher-impact work.

---

## Contribute

Ideas, issues, and pull requests are always welcome. Collaboration is at the heart of security and open source.

---

## License

MIT – use, adapt, and share!

---

*Stay secure, stay curious, and keep automating!*

— Max Alhourani
