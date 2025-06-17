#!/usr/bin/env python3
"""
Splunk SIEM Alert Triage Example
---------------------------------
Complete working example for integrating with Splunk and Jira.
This example shows real-world configuration and error handling.

Prerequisites:
- pip install requests splunk-sdk
- Splunk credentials and search permissions
- Jira API token

Usage:
    python siem_splunk.py --config config.json
"""

import requests
import json
import logging
from datetime import datetime, timedelta

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class SplunkSIEMTriage:
    def __init__(self, splunk_host, splunk_port, username, password, jira_url, jira_auth):
        self.splunk_base_url = f"https://{splunk_host}:{splunk_port}"
        self.splunk_auth = (username, password)
        self.jira_url = jira_url
        self.jira_auth = jira_auth
        
    def get_splunk_alerts(self, time_range="24h"):
        """Fetch high-priority security alerts from Splunk"""
        search_query = f'''
        search index=security earliest=-{time_range}
        | where severity="high" OR severity="critical"
        | where status!="resolved"
        | table _time, title, description, severity, source_ip, dest_ip
        | sort -_time
        '''
        
        try:
            # Start search job
            search_url = f"{self.splunk_base_url}/services/search/jobs"
            search_data = {
                'search': search_query,
                'output_mode': 'json',
                'exec_mode': 'blocking'
            }
            
            response = requests.post(search_url, data=search_data, auth=self.splunk_auth, verify=False)
            response.raise_for_status()
            
            job_sid = response.json()['sid']
            
            # Get results
            results_url = f"{self.splunk_base_url}/services/search/jobs/{job_sid}/results"
            results_response = requests.get(results_url, auth=self.splunk_auth, 
                                          params={'output_mode': 'json'}, verify=False)
            results_response.raise_for_status()
            
            return results_response.json()['results']
            
        except requests.RequestException as e:
            logger.error(f"Error fetching Splunk alerts: {e}")
            return []
    
    def is_actionable(self, alert):
        """Determine if an alert requires immediate action"""
        high_risk_conditions = [
            alert.get('severity') in ['critical', 'high'],
            'malware' in alert.get('description', '').lower(),
            'breach' in alert.get('title', '').lower(),
            alert.get('source_ip', '').startswith('10.0.0.')  # Internal network
        ]
        
        return any(high_risk_conditions)
    
    def create_jira_ticket(self, alert):
        """Create a Jira ticket for actionable alerts"""
        
        # Extract key information
        alert_time = alert.get('_time', datetime.now().isoformat())
        title = alert.get('title', 'Unknown Security Alert')
        description = alert.get('description', 'No description available')
        severity = alert.get('severity', 'medium')
        source_ip = alert.get('source_ip', 'N/A')
        dest_ip = alert.get('dest_ip', 'N/A')
        
        # Build Jira ticket payload
        ticket_payload = {
            "fields": {
                "project": {"key": "SEC"},
                "summary": f"SECURITY ALERT: {title}",
                "description": f"""
*Alert Details:*
• Time: {alert_time}
• Severity: {severity.upper()}
• Source IP: {source_ip}
• Destination IP: {dest_ip}

*Description:*
{description}

*Next Steps:*
1. Investigate source of alert
2. Verify if this is a true positive
3. Take appropriate containment measures
4. Update ticket with findings

_Auto-generated from Splunk SIEM alert triage system_
                """,
                "issuetype": {"name": "Task"},
                "priority": {"name": "High" if severity == "critical" else "Medium"},
                "labels": ["security", "siem", f"severity-{severity}"]
            }
        }
        
        try:
            response = requests.post(
                f"{self.jira_url}/rest/api/2/issue",
                json=ticket_payload,
                auth=self.jira_auth,
                headers={"Content-Type": "application/json"}
            )
            response.raise_for_status()
            
            ticket_key = response.json()['key']
            logger.info(f"Created Jira ticket: {ticket_key} for alert: {title}")
            return ticket_key
            
        except requests.RequestException as e:
            logger.error(f"Error creating Jira ticket: {e}")
            return None

def main():
    """Main execution function"""
    
    # Configuration (in production, load from secure config file)
    config = {
        "splunk": {
            "host": "your-splunk-server.company.com",
            "port": 8089,
            "username": "splunk_service_account",
            "password": "your_splunk_password"  # Use environment variable in production
        },
        "jira": {
            "url": "https://your-company.atlassian.net",
            "auth": ("jira_username", "jira_api_token")  # Use environment variables
        }
    }
    
    # Initialize triage system
    triage = SplunkSIEMTriage(
        splunk_host=config["splunk"]["host"],
        splunk_port=config["splunk"]["port"],
        username=config["splunk"]["username"],
        password=config["splunk"]["password"],
        jira_url=config["jira"]["url"],
        jira_auth=config["jira"]["auth"]
    )
    
    logger.info("Starting SIEM alert triage process...")
    
    # Fetch and process alerts
    alerts = triage.get_splunk_alerts()
    logger.info(f"Found {len(alerts)} alerts to process")
    
    actionable_count = 0
    tickets_created = 0
    
    for alert in alerts:
        if triage.is_actionable(alert):
            actionable_count += 1
            ticket_key = triage.create_jira_ticket(alert)
            if ticket_key:
                tickets_created += 1
    
    logger.info(f"Processing complete: {actionable_count} actionable alerts, {tickets_created} tickets created")

if __name__ == "__main__":
    main()
