# siem_alert_triage.py

"""
SIEM Alert Triage Script
------------------------
Automates fetching, filtering, and creating tickets for actionable SIEM alerts.
Save your sanity (and your sleep): Cut false positives, keep security teams focused.

Built by Max Alhourani – because security work should be effective and just a little bit easier!
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
