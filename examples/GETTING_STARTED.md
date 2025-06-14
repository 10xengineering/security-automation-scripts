# Getting Started Guide - Real Examples

This guide shows you how to get up and running with practical examples in 5 minutes.

## 🚀 Quick Start (Choose Your Path)

### Option 1: SOC Analyst - "I need to process alerts faster"

```bash
# 1. Copy the Splunk example configuration
cp examples/config.json my_config.json

# 2. Update with your credentials (use environment variables for security)
export SPLUNK_PASSWORD="your_password"
export JIRA_API_TOKEN="your_token"

# 3. Test with a small query first
python examples/siem_splunk.py --config my_config.json --test

# 4. Process real alerts
python examples/siem_splunk.py --config my_config.json
```

**Expected Result:** Transform 100+ daily alerts into 5-10 actionable Jira tickets.

---

### Option 2: Compliance Manager - "Audit is next week, help!"

```bash
# 1. Choose your compliance framework
./examples/compliance_enhanced.sh pci-dss     # For PCI compliance
./examples/compliance_enhanced.sh hipaa      # For HIPAA compliance  
./examples/compliance_enhanced.sh sox        # For SOX compliance

# 2. Result: Complete evidence package ready for auditors
# compliance_evidence_pci-dss_20250614_143022.tar.gz
```

**Expected Result:** All required logs, configs, and policies in one organized archive.

---

### Option 3: Security Manager - "My team needs better incident response"

```powershell
# 1. Generate customized runbooks for your organization
.\examples\custom_runbooks.ps1 -CompanyName "Acme Corp" -Emergency "911"

# 2. Review and customize the generated templates
# Output: 15+ incident response playbooks in Markdown

# 3. Share with your team via wiki/SharePoint
```

**Expected Result:** Complete incident response playbooks ready for your team.

---

## 🔧 Configuration Examples

### Minimal SIEM Setup (5 minutes)
```json
{
  "siem_config": {
    "splunk": {
      "host": "your-splunk.com",
      "username": "service_account", 
      "password": "ENV:SPLUNK_PASSWORD"
    }
  },
  "jira_config": {
    "url": "https://yourcompany.atlassian.net",
    "api_token": "ENV:JIRA_API_TOKEN",
    "project_key": "SEC"
  }
}
```

### Quick Compliance Check
```bash
# Test on a small directory first
./compliance_evidence_collector.sh
# Check output: compliance_evidence_20250614.tar.gz

# For production, use the enhanced version
./examples/compliance_enhanced.sh general
```

---

## 📊 Real Success Metrics

**Before automation:**
- ⏰ 2 hours daily processing SIEM alerts
- 📋 3 days to prepare compliance evidence  
- 📖 No standardized incident response

**After automation:**
- ⚡ 5 minutes daily alert processing
- 📦 2 minutes to generate compliance package
- 📚 Complete incident response library

---

## 🆘 Troubleshooting

### Common Issues:

**"Python script fails"**
```bash
# Check Python version (need 3.6+)
python --version

# Install required packages
pip install requests splunk-sdk
```

**"Bash script won't run"**
```bash
# Make executable
chmod +x compliance_evidence_collector.sh

# Check for Windows/Unix line endings
dos2unix compliance_evidence_collector.sh
```

**"PowerShell execution policy"**
```powershell
# Allow script execution (run as admin)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 🎯 Next Steps

1. **Start with one script** that solves your biggest pain point
2. **Customize the examples** for your environment  
3. **Set up daily automation** using the workflow examples
4. **Share with your team** and gather feedback
5. **Extend and contribute** back to the project

---

**Need help?** Check the main README.md or connect with the maintainer on LinkedIn.
