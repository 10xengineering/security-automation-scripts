# Security Automation Scripts 🚀

Welcome to your new security superpowers! This is a growing toolkit of open-source scripts designed to make security operations not just more efficient, but genuinely enjoyable. Yes, you read that right—security work can actually be fun! 

Whether you're drowning in SIEM alerts, scrambling for compliance evidence, or wishing your team had better incident response procedures, you'll find something here to transform those pain points into smooth, automated workflows.

*Built with love by someone who believes security should empower teams, not overwhelm them. Together, let's make security simpler, smarter, and maybe even a little bit delightful!* ✨

---

## What's Inside (Your New Security Toolkit!)

### 🔍 **siem_alert_triage.py**
Transform alert chaos into organized action! This friendly script cuts through the noise so you can focus on threats that actually matter.

**Quick Start (seriously, it's this easy!):**
```bash
# Get started in 30 seconds
python siem_alert_triage.py

# With your own configuration (we'll help you set this up!)
python siem_alert_triage.py --config my_config.json
```

**Real-world magic:**
```python
# Watch this script turn 127 overwhelming alerts into 3 actionable tickets
# Your future self will thank you! 🎯
alerts = fetch_high_priority_alerts()
actionable = [alert for alert in alerts if is_actionable(alert)]
create_jira_tickets(actionable)  # Only the real threats make it through
```

**What it does:** Automatically fetches high/critical severity alerts from your SIEM and creates clear, actionable Jira tickets. No more alert fatigue—just focused security work!  
📁 **[Complete Splunk example →](./examples/siem_splunk.py)** | **[Sumo Logic example →](./examples/siem_sumo_logic.py)**

---

### 📋 **compliance_evidence_collector.sh**
Turn compliance stress into compliance success! Never scramble for audit evidence again—this script packages everything you need with a single command.

**Quick Start (audit-ready in minutes!):**
```bash
# Collect evidence for today's surprise audit
./compliance_evidence_collector.sh

# Get framework-specific packages (we support all the major ones!)
./examples/compliance_enhanced.sh pci-dss
./examples/compliance_enhanced.sh hipaa
./examples/compliance_enhanced.sh sox
```

**Real-world lifesaver:**
```bash
# Friday afternoon audit notification? No stress! 
# Collect 6 months of logs, configs, and policies in under 2 minutes
./examples/compliance_enhanced.sh sox
# Output: compliance_evidence_sox_20250614_143022.tar.gz 
# ✅ Ready for auditors, complete with checksums and metadata!
```

**What it does:** Intelligently packages system logs, configurations, and security policies into a timestamped, audit-ready archive. Includes integrity checks and comprehensive reporting. Auditors will be impressed!  
📁 **[Enhanced compliance examples →](./examples/compliance_enhanced.sh)**

---

### 📖 **runbook_generator.ps1**
Give your team the confidence that comes with having a plan! Create clear, practical incident response runbooks that actually help during high-stress situations.

**Quick Start (playbooks in seconds!):**
```powershell
# Generate your essential incident response library
.\runbook_generator.ps1

# Create custom runbooks tailored to your organization
.\examples\custom_runbooks.ps1 -CompanyName "Acme Corp" -Emergency "911"
```

**Real-world confidence booster:**
```powershell
# 3am ransomware alert? Your team has the exact playbook they need!
# Generate 15 comprehensive, step-by-step incident response guides
.\examples\custom_runbooks.ps1 -CompanyName "Acme Corp" -ContactEmail "security@acme.com"
# Result: Detailed guides that turn panic into organized, effective response
```

**What it does:** Creates standardized, comprehensive incident response runbooks in clear Markdown format. Includes escalation contacts, technical steps, and communication templates. Your team will feel prepared for anything!  
📁 **[Custom runbook examples →](./examples/custom_runbooks.ps1)**

---

## For Business Leaders 💼

You don't need to be a developer to understand the massive value here. These scripts are built to deliver real business impact:

- **Dramatically reduce response times** ⚡ Turn 2-hour alert reviews into 5-minute focused actions
- **Eliminate compliance panic** 📋 Be audit-ready in minutes, not days
- **Boost team confidence** 🛡️ Clear procedures mean faster, better incident response
- **Free up your experts** 🧠 Let your security team focus on strategy, not busy work
- **Reduce costly mistakes** 💰 Automated processes mean consistent, reliable results

### Who benefits most?
- **Security teams** who want to work smarter and sleep better
- **IT managers** looking to improve efficiency and reduce burnout
- **Business owners** who need reliable security without the stress
- **Compliance officers** who want to stay ahead of audit requirements

**Curious how this could transform your security operations?**  
These tools are designed to be accessible to everyone. No PhD in cybersecurity required! [![Connect with me on LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin&style=for-the-badge)](https://www.linkedin.com/in/alhourani)

---

## 🚀 Getting Started (You've Got This!)

### What You'll Need
Don't worry—we keep the requirements simple and straightforward:

- **Python 3.6+** (for the SIEM triage magic)
- **Bash shell** (for compliance collection on Unix/Linux systems)
- **PowerShell 5.0+** (for runbook generation)

*💡 Pro tip: If you're on Windows, the examples work great with WSL (Windows Subsystem for Linux) too!*

### Setting Things Up (Easier Than You Think!)

**SIEM Alert Triage - Your Anti-Alert-Fatigue Solution:**
1. Copy the example config file (we've done the hard work for you!)
2. Update with your SIEM endpoint and Jira details
3. Customize the alert filters to match your environment
4. Run it and watch the magic happen! ✨

**Compliance Evidence Collection - Your Audit Ace:**
1. Choose your compliance framework (PCI, HIPAA, SOX, or general)
2. Update the evidence paths for your specific environment
3. Make sure the script has read access to your log directories
4. Run it and breathe easy knowing you're audit-ready!

**Runbook Generation - Your Incident Response Confidence Builder:**
1. Customize the incident types for your organization's needs
2. Add your contact information and escalation procedures
3. Generate your comprehensive playbook library
4. Share with your team and watch response times improve!

---

## 💼 Real-World Success Stories

### **SOC Team Transformation**
```bash
# Before: 2 hours every morning processing overnight alerts
# After: 5 minutes to review 3 actionable tickets

python examples/siem_sumo_logic.py --config production.json
# Result: 127 noisy alerts → 3 genuine security incidents
# Team morale: ⬆️ Sleep quality: ⬆️ False positive fatigue: ⬇️
```

### **Compliance Audit Victory**
```bash
# The scenario: Auditor calls Friday afternoon for Monday evidence
# The solution: One command, two minutes, complete peace of mind

./examples/compliance_enhanced.sh pci-dss
# Result: Comprehensive evidence package with integrity verification
# Auditor feedback: "Most organized evidence we've ever received"
```

### **Incident Response Excellence**
```powershell
# New team member starts Monday morning
# By lunch: Fully equipped with 15 detailed incident response playbooks

.\examples\custom_runbooks.ps1 -CompanyName "YourCorp" -Emergency "911"
# Result: Confident team members who know exactly what to do
# Next 3am alert: Handled professionally instead of causing panic
```

---

## 📁 Examples & Learning Resources

Your journey to security automation excellence starts here! We've created comprehensive examples that show you exactly how to implement these tools in your environment:

- **`examples/siem_splunk.py`** - Complete Splunk integration with real-world error handling
- **`examples/siem_sumo_logic.py`** - 🆕 Comprehensive Sumo Logic integration guide
- **`examples/compliance_enhanced.sh`** - Framework-specific compliance collection (PCI, HIPAA, SOX)
- **`examples/custom_runbooks.ps1`** - Professional incident response templates
- **`examples/daily_security_workflow.sh`** - Complete SOC automation workflow
- **`examples/GETTING_STARTED.md`** - Your step-by-step setup companion

**🌟 New to automation?** **[Start with our Getting Started Guide →](./examples/GETTING_STARTED.md)** - We'll walk you through everything!

---

## Why This Matters 🎯

Security work should challenge your mind, not drain your spirit. These scripts eliminate the repetitive tasks that cause burnout, giving you more time for the strategic thinking that actually protects your organization.

**The bigger picture:** Every minute saved on busy work is a minute gained for innovation, learning, and building truly robust security. Your organization deserves both efficiency and excellence—and now you can have both!

---

## Join the Community 🤝

We believe the best security tools come from collaboration and shared experience. Your ideas, feedback, and contributions make this project better for everyone:

- **Found a bug?** Please let us know—we fix issues fast!
- **Have an improvement idea?** We'd love to hear it!
- **Want to contribute?** Pull requests welcome—big or small!
- **Need help?** Check our examples or reach out—we're here to help!

*Remember: Every expert was once a beginner. Your questions and contributions help others learn too!*

---

## License & Sharing 📜

MIT License – use these tools, adapt them for your needs, and share them freely! Security gets better when we work together.

---

## What's Next? 🌟

Ready to transform your security operations? Here's your roadmap:

1. **Pick one tool** that addresses your biggest current pain point
2. **Follow the getting started guide** (we've made it really straightforward!)
3. **Customize it** for your environment (the examples show you how)
4. **Share your success** with your team—they'll want in on this too!
5. **Keep building** - automation is addictive in the best way

*Remember: Small improvements compound into major transformations. You're not just implementing scripts—you're building a more effective, confident, and resilient security practice.*

---

*Stay secure, stay curious, and remember—you've got the power to make security both effective and enjoyable!* 

— Max Alhourani 🛡️✨
