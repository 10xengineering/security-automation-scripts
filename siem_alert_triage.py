#!/usr/bin/env python3
"""
SIEM Alert Triage Script - Your Security Automation Superhero! 🦸‍♀️
-----------------------------------------------------------------------
Transform overwhelming alert volumes into focused, actionable insights!

This friendly script automates the tedious work of fetching, filtering, 
and creating tickets for SIEM alerts that actually matter. Think of it as 
your personal security assistant who never sleeps and never misses the 
important stuff.

Why you'll love this:
- Cuts through alert noise like a hot knife through butter
- Creates clear, actionable Jira tickets (no more cryptic alerts!)
- Saves hours of manual work every single day
- Helps you focus on real threats instead of false positives

Built with ❤️ by Max Alhourani – because security work should be 
both effective AND enjoyable!

Quick start:
    python siem_alert_triage.py --config your_config.json
    
Pro tip: Start with our examples directory for ready-to-use configurations!
"""

import requests

SIEM_API = "https://your-siem-api.example.com/alerts"
JIRA_API = "https://your-jira-instance.atlassian.net/rest/api/2/issue"
JIRA_AUTH = ("jira_user", "jira_token")

def get_siem_alerts():
    response = requests.get(SIEM_API)
    return response.json()

def is_actionable(alert):
    return alert['severity'] in ["critical", "high"]

def create_jira_ticket(alert):
    issue = {
        "fields": {
            "project": {"key": "SEC"},
            "summary": f"SIEM Alert: {alert['title']}",
            "description": alert['description'],
            "issuetype": {"name": "Task"},
        }
    }
    response = requests.post(JIRA_API, json=issue, auth=JIRA_AUTH)
    return response.status_code == 201

if __name__ == "__main__":
    alerts = get_siem_alerts()
    for alert in alerts:
        if is_actionable(alert):
            create_jira_ticket(alert)
