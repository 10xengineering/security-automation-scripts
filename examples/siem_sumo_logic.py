#!/usr/bin/env python3
"""
Sumo Logic SIEM Alert Triage Example
------------------------------------
Your friendly guide to connecting Sumo Logic with automated ticket creation!

This example shows you how to turn overwhelming alert volumes into manageable, 
actionable insights. Think of it as your personal security assistant that 
never sleeps and never misses the important stuff.

What you'll need:
- pip install requests sumoapi-client
- Sumo Logic API credentials (don't worry, we'll walk you through it!)
- Jira API token (easier than it sounds, promise!)

Quick start magic:
    python siem_sumo_logic.py --config config.json

Pro tip: Start with a small time window (like 1 hour) to test things out.
You've got this! 🚀
"""

import requests
import json
import logging
from datetime import datetime, timedelta
from sumoapi import SumoAPIClient
import argparse
import sys
import os

# Set up friendly logging that actually helps you debug
logging.basicConfig(
    level=logging.INFO, 
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('sumo_triage.log'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

class SumoLogicSIEMTriage:
    """
    Your Sumo Logic alert triage companion! 
    
    This class handles the heavy lifting of connecting to Sumo Logic,
    fetching relevant alerts, and creating actionable Jira tickets.
    Think of it as your security operations co-pilot.
    """
    
    def __init__(self, config):
        """
        Initialize your triage assistant with configuration.
        
        Don't worry if this looks complex - we've made it as simple as possible!
        """
        self.sumo_config = config.get('sumo_logic', {})
        self.jira_config = config.get('jira_config', {})
        
        # Set up Sumo Logic connection
        self.sumo_client = SumoAPIClient(
            endpoint=self.sumo_config.get('endpoint'),
            access_id=self._get_secure_value(self.sumo_config.get('access_id')),
            access_key=self._get_secure_value(self.sumo_config.get('access_key'))
        )
        
        # Prepare Jira connection details
        self.jira_url = self.jira_config.get('url')
        self.jira_auth = (
            self.jira_config.get('username'),
            self._get_secure_value(self.jira_config.get('api_token'))
        )
        
        logger.info("🎉 Sumo Logic triage system initialized! Ready to make your security life easier.")
    
    def _get_secure_value(self, value):
        """
        Safely retrieve credentials from environment variables.
        
        Security tip: Always use environment variables for sensitive data!
        This keeps your credentials safe and your automation secure.
        """
        if isinstance(value, str) and value.startswith('ENV:'):
            env_var = value[4:]  # Remove 'ENV:' prefix
            env_value = os.getenv(env_var)
            if not env_value:
                logger.warning(f"⚠️  Environment variable {env_var} not found. Please set it for security!")
                return None
            return env_value
        return value
    
    def get_sumo_alerts(self, time_range_hours=24):
        """
        Fetch security alerts from Sumo Logic that need your attention.
        
        We're looking for the important stuff - high and critical severity alerts
        that haven't been resolved yet. Think of this as your security inbox,
        but smarter!
        
        Args:
            time_range_hours (int): How far back to look (default: 24 hours)
            
        Returns:
            list: Your prioritized list of security alerts
        """
        
        # Calculate time range (Sumo Logic loves UTC timestamps)
        end_time = datetime.utcnow()
        start_time = end_time - timedelta(hours=time_range_hours)
        
        # Here's our smart query - it finds the alerts that actually matter
        search_query = f'''
        _sourceCategory=security/alerts
        | where severity in ("HIGH", "CRITICAL", "high", "critical")
        | where status != "RESOLVED" and status != "resolved"
        | where _messageTime >= {int(start_time.timestamp() * 1000)}
        | where _messageTime <= {int(end_time.timestamp() * 1000)}
        | json field=_raw "alert_id" as alert_id
        | json field=_raw "title" as title
        | json field=_raw "description" as description  
        | json field=_raw "severity" as severity
        | json field=_raw "source_ip" as source_ip
        | json field=_raw "destination_ip" as destination_ip
        | json field=_raw "user" as affected_user
        | json field=_raw "host" as affected_host
        | json field=_raw "detection_rule" as detection_rule
        | sort by _messageTime desc
        | limit 100
        '''
        
        try:
            logger.info(f"🔍 Searching Sumo Logic for alerts from the last {time_range_hours} hours...")
            
            # Execute the search job
            search_job = self.sumo_client.search_job(
                query=search_query,
                from_time=start_time.isoformat() + 'Z',
                to_time=end_time.isoformat() + 'Z'
            )
            
            # Wait for results (Sumo Logic processes this in the background)
            logger.info("⏳ Waiting for Sumo Logic to process your search... (this usually takes 30-60 seconds)")
            search_job.wait_for_completion()
            
            # Get the results
            results = search_job.records()
            
            logger.info(f"✅ Found {len(results)} potential security alerts to review!")
            
            # Convert to our standard format for easier processing
            formatted_alerts = []
            for record in results:
                alert = {
                    'id': record.get('alert_id', f"sumo_{record.get('_messageid', 'unknown')}"),
                    'timestamp': record.get('_messagetime', ''),
                    'title': record.get('title', 'Security Alert'),
                    'description': record.get('description', 'No description available'),
                    'severity': record.get('severity', 'medium').upper(),
                    'source_ip': record.get('source_ip', 'N/A'),
                    'destination_ip': record.get('destination_ip', 'N/A'),
                    'affected_user': record.get('affected_user', 'N/A'),
                    'affected_host': record.get('affected_host', 'N/A'),
                    'detection_rule': record.get('detection_rule', 'N/A'),
                    'raw_data': record
                }
                formatted_alerts.append(alert)
            
            return formatted_alerts
            
        except Exception as e:
            logger.error(f"❌ Oops! Had trouble connecting to Sumo Logic: {str(e)}")
            logger.info("💡 Tip: Check your credentials and network connection. You've got this!")
            return []
    
    def is_actionable(self, alert):
        """
        Decide if an alert needs immediate human attention.
        
        This is where the magic happens! We use smart filtering to separate
        the signals from the noise. Think of this as your experienced security
        analyst friend who knows what's worth waking you up for.
        
        Args:
            alert (dict): The security alert to evaluate
            
        Returns:
            bool: True if this alert deserves immediate attention
        """
        
        # These are the red flags that mean "take action now!"
        high_priority_indicators = [
            # Severity-based filtering
            alert.get('severity', '').upper() in ['CRITICAL', 'HIGH'],
            
            # Content-based intelligence (look for scary keywords)
            any(keyword in alert.get('description', '').lower() for keyword in [
                'malware', 'ransomware', 'breach', 'exfiltration', 
                'lateral movement', 'privilege escalation', 'backdoor'
            ]),
            
            # Title-based filtering
            any(keyword in alert.get('title', '').lower() for keyword in [
                'attack', 'compromise', 'suspicious', 'unauthorized'
            ]),
            
            # Network-based indicators (adjust these IP ranges for your environment!)
            self._is_internal_ip_involved(alert),
            
            # User-based indicators
            alert.get('affected_user', '').lower() not in ['system', 'service', 'unknown'],
            
            # Detection rule intelligence
            any(keyword in alert.get('detection_rule', '').lower() for keyword in [
                'apt', 'threat', 'exploit', 'persistence'
            ])
        ]
        
        # Count how many red flags this alert has
        priority_score = sum(high_priority_indicators)
        
        # We need at least 2 indicators to consider it actionable
        # (This helps reduce false positives while catching real threats)
        is_actionable = priority_score >= 2
        
        if is_actionable:
            logger.info(f"🚨 Alert '{alert.get('title', 'Unknown')}' flagged as actionable (score: {priority_score}/6)")
        
        return is_actionable
    
    def _is_internal_ip_involved(self, alert):
        """
        Check if internal IP addresses are involved in the alert.
        
        Customize these ranges for your network! Internal IP involvement
        often indicates lateral movement or internal compromise.
        """
        internal_ranges = ['10.', '192.168.', '172.16.', '172.17.', '172.18.']
        
        source_ip = alert.get('source_ip', '')
        dest_ip = alert.get('destination_ip', '')
        
        return any(ip.startswith(range_prefix) for ip in [source_ip, dest_ip] 
                  for range_prefix in internal_ranges)
    
    def create_jira_ticket(self, alert):
        """
        Transform a security alert into a well-formatted Jira ticket.
        
        This creates tickets that your team will actually want to work with -
        clear, informative, and actionable. No more cryptic alerts!
        
        Args:
            alert (dict): The security alert to convert
            
        Returns:
            bool: True if ticket was created successfully
        """
        
        # Build a comprehensive, helpful ticket description
        description = self._build_ticket_description(alert)
        
        # Map alert severity to Jira priority
        severity_mapping = {
            'CRITICAL': 'Highest',
            'HIGH': 'High', 
            'MEDIUM': 'Medium',
            'LOW': 'Low'
        }
        
        jira_priority = severity_mapping.get(
            alert.get('severity', 'MEDIUM').upper(), 
            'Medium'
        )
        
        # Create the ticket payload
        ticket_payload = {
            "fields": {
                "project": {"key": self.jira_config.get('project_key', 'SEC')},
                "summary": f"🔍 Security Alert: {alert.get('title', 'Untitled Alert')}",
                "description": description,
                "issuetype": {"name": self.jira_config.get('issue_type', 'Task')},
                "priority": {"name": jira_priority},
                "labels": [
                    "security-alert",
                    "sumo-logic", 
                    f"severity-{alert.get('severity', 'medium').lower()}",
                    "automated-triage"
                ]
            }
        }
        
        try:
            response = requests.post(
                f"{self.jira_url}/rest/api/2/issue",
                json=ticket_payload,
                auth=self.jira_auth,
                headers={'Content-Type': 'application/json'}
            )
            
            if response.status_code == 201:
                ticket_data = response.json()
                ticket_key = ticket_data.get('key', 'Unknown')
                ticket_url = f"{self.jira_url}/browse/{ticket_key}"
                
                logger.info(f"✅ Created Jira ticket {ticket_key} for alert: {alert.get('title', 'Unknown')}")
                logger.info(f"🔗 View ticket: {ticket_url}")
                return True
            else:
                logger.error(f"❌ Failed to create Jira ticket. Response: {response.status_code} - {response.text}")
                return False
                
        except Exception as e:
            logger.error(f"❌ Error creating Jira ticket: {str(e)}")
            logger.info("💡 Tip: Double-check your Jira URL and authentication credentials")
            return False
    
    def _build_ticket_description(self, alert):
        """
        Create a comprehensive, readable ticket description.
        
        This makes sure your security team has all the context they need
        to investigate efficiently. Clear information = faster resolution!
        """
        
        description = f"""
🚨 *Security Alert Detected via Sumo Logic*

*Alert Details:*
• *Severity:* {alert.get('severity', 'Unknown')}
• *Detection Time:* {alert.get('timestamp', 'Unknown')}
• *Detection Rule:* {alert.get('detection_rule', 'Not specified')}

*Alert Description:*
{alert.get('description', 'No description available')}

*Technical Details:*
• *Source IP:* {alert.get('source_ip', 'N/A')}
• *Destination IP:* {alert.get('destination_ip', 'N/A')}
• *Affected User:* {alert.get('affected_user', 'N/A')}
• *Affected Host:* {alert.get('affected_host', 'N/A')}

*Investigation Steps:*
1. Review the alert details above
2. Check Sumo Logic for additional context around this timeframe
3. Verify if this activity is authorized/expected
4. If malicious: contain, investigate, and remediate
5. Update this ticket with findings and actions taken

*Quick Links:*
• [Sumo Logic Search|{self.sumo_config.get('endpoint', '#')}/ui/search]
• [Security Playbooks|{self.jira_config.get('playbook_url', '#')}]

---
_This ticket was automatically created by the Sumo Logic SIEM Triage system._
_Need help? Check the runbooks or reach out to the security team!_
        """
        
        return description


def load_config(config_path):
    """
    Load configuration from file with helpful error handling.
    
    We make this as painless as possible - if something's wrong,
    we'll tell you exactly how to fix it!
    """
    try:
        with open(config_path, 'r') as f:
            config = json.load(f)
            logger.info(f"✅ Configuration loaded successfully from {config_path}")
            return config
    except FileNotFoundError:
        logger.error(f"❌ Config file not found: {config_path}")
        logger.info("💡 Tip: Copy examples/config.json and customize it for your environment")
        sys.exit(1)
    except json.JSONDecodeError as e:
        logger.error(f"❌ Invalid JSON in config file: {str(e)}")
        logger.info("💡 Tip: Check for missing commas or brackets in your config file")
        sys.exit(1)


def main():
    """
    Your main security automation workflow starts here!
    
    This orchestrates the entire process: fetch alerts, filter them,
    and create tickets for the ones that matter. Simple and effective!
    """
    
    parser = argparse.ArgumentParser(
        description="🔍 Sumo Logic SIEM Alert Triage - Turn alert chaos into organized action!"
    )
    parser.add_argument(
        '--config', 
        default='examples/config.json',
        help='Path to configuration file (default: examples/config.json)'
    )
    parser.add_argument(
        '--hours', 
        type=int, 
        default=24,
        help='Hours of alerts to process (default: 24)'
    )
    parser.add_argument(
        '--test', 
        action='store_true',
        help='Test mode: show what would be processed without creating tickets'
    )
    
    args = parser.parse_args()
    
    # Load configuration
    config = load_config(args.config)
    
    # Initialize the triage system
    try:
        triage = SumoLogicSIEMTriage(config)
    except Exception as e:
        logger.error(f"❌ Failed to initialize Sumo Logic connection: {str(e)}")
        logger.info("💡 Tip: Check your Sumo Logic credentials in the config file")
        sys.exit(1)
    
    logger.info(f"🚀 Starting Sumo Logic alert triage for the last {args.hours} hours...")
    
    if args.test:
        logger.info("🧪 Test mode enabled - no tickets will be created")
    
    # Fetch alerts from Sumo Logic
    alerts = triage.get_sumo_alerts(time_range_hours=args.hours)
    
    if not alerts:
        logger.info("🎉 No alerts found! Your security posture is looking good.")
        return
    
    # Process each alert
    actionable_count = 0
    tickets_created = 0
    
    logger.info(f"📊 Processing {len(alerts)} alerts...")
    
    for i, alert in enumerate(alerts, 1):
        logger.info(f"[{i}/{len(alerts)}] Evaluating: {alert.get('title', 'Unknown Alert')}")
        
        if triage.is_actionable(alert):
            actionable_count += 1
            
            if args.test:
                logger.info("🧪 [TEST MODE] Would create Jira ticket for this alert")
            else:
                if triage.create_jira_ticket(alert):
                    tickets_created += 1
                else:
                    logger.warning("⚠️  Failed to create ticket - continuing with other alerts")
        else:
            logger.info("ℹ️  Alert doesn't meet actionability criteria - skipping")
    
    # Summary report
    logger.info("=" * 60)
    logger.info("📈 TRIAGE SUMMARY")
    logger.info("=" * 60)
    logger.info(f"Total alerts processed: {len(alerts)}")
    logger.info(f"Actionable alerts identified: {actionable_count}")
    
    if args.test:
        logger.info(f"Tickets that would be created: {actionable_count}")
        logger.info("🧪 Test mode complete - no actual tickets were created")
    else:
        logger.info(f"Jira tickets successfully created: {tickets_created}")
        
        if tickets_created < actionable_count:
            logger.warning(f"⚠️  {actionable_count - tickets_created} tickets failed to create")
    
    # Helpful next steps
    logger.info("")
    logger.info("🎯 NEXT STEPS:")
    if tickets_created > 0:
        logger.info(f"• Review {tickets_created} new security tickets in Jira")
        logger.info(f"• Dashboard: {config.get('jira_config', {}).get('url', 'your-jira-url')}/projects/{config.get('jira_config', {}).get('project_key', 'SEC')}")
    
    logger.info("• Check Sumo Logic for additional context if needed")
    logger.info("• Update detection rules based on your findings")
    logger.info("")
    logger.info("🌟 Great job keeping your organization secure! Every alert reviewed makes your environment safer.")


if __name__ == "__main__":
    main()
