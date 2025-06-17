# Getting Started Guide - Your Security Automation Journey! 🚀

Welcome to the most approachable guide to security automation you'll ever read! This guide is designed to get you up and running with confidence in just 5 minutes. No matter your technical background, we'll walk you through everything step by step.

*Remember: Every expert started exactly where you are right now. You've got this!* ✨

## 🎯 Quick Start (Choose Your Adventure!)

Pick the path that matches your biggest current challenge. Don't worry about being "perfect" from day one—start where you are, with what you have!

### Path 1: SOC Analyst - "Help, I'm drowning in alerts!" 🆘➡️🏊

**Your challenge:** Processing hundreds of daily alerts manually  
**Your solution:** Smart automation that filters signal from noise  
**Time to awesome:** 5 minutes setup, lifetime of sanity saved!

```bash
# Step 1: Copy our battle-tested configuration (we've done the hard work!)
cp examples/config.json my_config.json

# Step 2: Set up your credentials securely (environment variables are your friend!)
export SPLUNK_PASSWORD="your_splunk_password"
export JIRA_API_TOKEN="your_jira_token"
export SUMO_ACCESS_ID="your_sumo_access_id"      # 🆕 For Sumo Logic users!
export SUMO_ACCESS_KEY="your_sumo_access_key"

# Step 3: Test with a small batch first (always smart to start small!)
python examples/siem_splunk.py --config my_config.json --hours 1 --test

# Step 4: Watch the magic happen with real alerts!
python examples/siem_splunk.py --config my_config.json
# OR for Sumo Logic users:
python examples/siem_sumo_logic.py --config my_config.json
```

**Expected magic:** Transform 100+ overwhelming alerts into 5-10 actionable tickets that actually matter. Your inbox (and your stress levels) will thank you!

*💡 Pro tip: Start with the `--test` flag first—it shows you what would happen without actually creating tickets. Perfect for building confidence!*

---

### Path 2: Compliance Manager - "Audit surprise attack incoming!" 📋➡️😌

**Your challenge:** Auditors want evidence and they want it now  
**Your solution:** Automated evidence collection that makes you look like a superhero  
**Time to awesome:** 2 minutes to audit-ready evidence package!

```bash
# Choose your compliance adventure (we support all the major frameworks!)
./examples/compliance_enhanced.sh pci-dss     # For PCI DSS compliance
./examples/compliance_enhanced.sh hipaa      # For HIPAA compliance  
./examples/compliance_enhanced.sh sox        # For SOX compliance
./examples/compliance_enhanced.sh general    # For general security evidence

# Result: compliance_evidence_pci-dss_20250614_143022.tar.gz
# Complete with integrity checksums and organized documentation!
```

**Expected relief:** All required logs, configurations, and policies in one beautifully organized, auditor-ready archive. Watch compliance stress transform into compliance confidence!

*💡 Insider secret: The enhanced version includes integrity verification and metadata that impresses even the most demanding auditors!*

---

### Path 3: Security Manager - "My team needs better incident response!" 🛡️➡️💪

**Your challenge:** Inconsistent incident response, team uncertainty during crises  
**Your solution:** Professional, comprehensive incident response playbooks  
**Time to awesome:** 30 seconds to a complete incident response library!

```powershell
# Generate your comprehensive incident response library
.\examples\custom_runbooks.ps1 -CompanyName "Acme Corp" -Emergency "911"

# Customize for your specific scenarios
.\examples\custom_runbooks.ps1 -CompanyName "Your Org" -ContactEmail "security@yourorg.com"

# Result: 15+ detailed, step-by-step incident response guides
# Covering everything from phishing to data breaches to ransomware
```

**Expected confidence boost:** Complete incident response playbooks that turn 3am panic into organized, professional response. Your team will feel prepared for anything!

*💡 Team tip: Share these runbooks in your team wiki or SharePoint. When crisis hits, having the plan at your fingertips makes all the difference!*

---

## 🔧 Configuration Examples (We've Made This Super Easy!)

### Splunk Configuration (5 minutes to setup!):
```json
{
  "splunk": {
    "host": "your-splunk.company.com",
    "port": 8089,
    "username": "service_account",
    "password": "ENV:SPLUNK_PASSWORD",
    "index": "security"
  },
  "jira_config": {
    "url": "https://yourcompany.atlassian.net",
    "username": "security@yourcompany.com",
    "api_token": "ENV:JIRA_API_TOKEN",
    "project_key": "SEC"
  }
}
```

### 🆕 Sumo Logic Configuration (Even easier!):
```json
{
  "sumo_logic": {
    "endpoint": "https://api.sumologic.com/api/v1",
    "access_id": "ENV:SUMO_ACCESS_ID",
    "access_key": "ENV:SUMO_ACCESS_KEY",
    "time_zone": "UTC",
    "query_timeout": 300
  },
  "jira_config": {
    "url": "https://yourcompany.atlassian.net",
    "username": "security@yourcompany.com", 
    "api_token": "ENV:JIRA_API_TOKEN",
    "project_key": "SEC",
    "issue_type": "Security Incident"
  }
}
```

*💡 Security Pro Tip: Notice how we use `ENV:` for sensitive values? This keeps your credentials safe in environment variables instead of hardcoded in files. Smart and secure!*

### Quick Compliance Check (Start Small, Think Big!)
```bash
# Test on a small directory first (smart approach!)
./compliance_evidence_collector.sh

# Check the output - you'll see: compliance_evidence_20250614.tar.gz
# Open it up and see what magic happened!

# Ready for the full experience? Try the enhanced version:
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

## 🆘 Troubleshooting (Don't Worry, We've Got You!)

### "Help! My Python script won't run!"
```bash
# First, check your Python version (we need 3.6 or newer)
python --version

# If it's too old, time for an upgrade! Don't worry, it's easier than you think.

# Install the packages we need (this might take a minute, perfect time for coffee!)
pip install requests splunk-sdk sumoapi-client

# Still having trouble? Try this:
pip install --upgrade pip
pip install -r requirements.txt
```

### "The bash script says 'permission denied'!"
```bash
# Easy fix! Just make it executable:
chmod +x compliance_evidence_collector.sh
chmod +x examples/compliance_enhanced.sh

# On Windows with weird line endings? This will fix it:
dos2unix compliance_evidence_collector.sh
```

### "PowerShell won't let me run scripts!"
```powershell
# Run this as administrator (it's a Windows security thing):
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# This tells Windows you're allowed to run scripts you trust. Makes sense!
```

### "My SIEM credentials aren't working!"
Don't panic! This is super common. Here's the checklist:

1. **Double-check your endpoint URL** - is it exactly right?
2. **Verify your username and password** - try logging in manually first
3. **Check your API permissions** - you might need read access to security logs
4. **Test your Jira token** - create a test ticket manually with the API

### 🆕 "Sumo Logic specific issues!"
```bash
# Check your Sumo Logic endpoint and credentials
python -c "from sumoapi import SumoAPIClient; print('Sumo API client installed!')"

# Test your connection with a simple query
python examples/siem_sumo_logic.py --config my_config.json --test --dry-run

# Common Sumo Logic gotchas:
# 1. Make sure your access ID and key have search permissions
# 2. Check your time zone settings in the config
# 3. Verify your query timeout is long enough for complex searches
```

*Remember: Every expert started exactly where you are now. These bumps are just part of the learning journey!*

---

## 🎯 Next Steps

1. **Start with one script** that solves your biggest pain point
2. **Customize the examples** for your environment  
3. **Set up daily automation** using the workflow examples
4. **Share with your team** and gather feedback
5. **Extend and contribute** back to the project

---

**Need help?** Check the main README.md or connect with the maintainer on LinkedIn.
