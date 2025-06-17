#!/bin/bash
# Enhanced Compliance Evidence Collector
# 
# This example shows how to customize the compliance collector for different
# regulatory frameworks (SOX, HIPAA, PCI-DSS, etc.)
#
# Usage: ./compliance_enhanced.sh [framework]
# Example: ./compliance_enhanced.sh pci-dss

set -euo pipefail

# Configuration
FRAMEWORK="${1:-general}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_DIR="./compliance_evidence_${FRAMEWORK}_${TIMESTAMP}"
ARCHIVE_NAME="compliance_evidence_${FRAMEWORK}_${TIMESTAMP}.tar.gz"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "${OUTPUT_DIR}/collection.log"
}

# Create output directory
mkdir -p "$OUTPUT_DIR"

log "Starting compliance evidence collection for framework: $FRAMEWORK"

# Framework-specific evidence collection
case "$FRAMEWORK" in
    "pci-dss")
        log "Collecting PCI-DSS specific evidence..."
        EVIDENCE_DIRS=(
            "/var/log/auth.log*"
            "/var/log/secure*"
            "/etc/ssh/sshd_config"
            "/etc/apache2/conf*"
            "/etc/nginx/nginx.conf"
            "/var/log/apache2/access.log*"
            "/var/log/nginx/access.log*"
            "/etc/iptables/"
            "/etc/fail2ban/"
        )
        
        # PCI-DSS specific checks
        echo "=== PCI-DSS Compliance Checks ===" > "${OUTPUT_DIR}/pci_checks.txt"
        echo "SSL/TLS Configuration:" >> "${OUTPUT_DIR}/pci_checks.txt"
        if command -v openssl &> /dev/null; then
            openssl version >> "${OUTPUT_DIR}/pci_checks.txt" 2>&1 || true
        fi
        
        echo "Firewall Status:" >> "${OUTPUT_DIR}/pci_checks.txt"
        if command -v ufw &> /dev/null; then
            ufw status >> "${OUTPUT_DIR}/pci_checks.txt" 2>&1 || true
        fi
        ;;
        
    "hipaa")
        log "Collecting HIPAA specific evidence..."
        EVIDENCE_DIRS=(
            "/var/log/auth.log*"
            "/var/log/secure*"
            "/var/log/audit/audit.log*"
            "/etc/audit/auditd.conf"
            "/etc/rsyslog.conf"
            "/var/log/mysql/mysql.log*"
            "/var/log/postgresql/postgresql-*.log"
        )
        
        # HIPAA specific checks
        echo "=== HIPAA Compliance Checks ===" > "${OUTPUT_DIR}/hipaa_checks.txt"
        echo "Audit Configuration:" >> "${OUTPUT_DIR}/hipaa_checks.txt"
        if command -v auditctl &> /dev/null; then
            auditctl -l >> "${OUTPUT_DIR}/hipaa_checks.txt" 2>&1 || true
        fi
        
        echo "Database Access Logs:" >> "${OUTPUT_DIR}/hipaa_checks.txt"
        ls -la /var/log/mysql/ >> "${OUTPUT_DIR}/hipaa_checks.txt" 2>&1 || true
        ls -la /var/log/postgresql/ >> "${OUTPUT_DIR}/hipaa_checks.txt" 2>&1 || true
        ;;
        
    "sox")
        log "Collecting SOX specific evidence..."
        EVIDENCE_DIRS=(
            "/var/log/auth.log*"
            "/var/log/secure*"
            "/var/log/sudo.log*"
            "/etc/sudoers"
            "/etc/passwd"
            "/etc/group"
            "/home/*/.bash_history"
            "/root/.bash_history"
        )
        
        # SOX specific checks
        echo "=== SOX Compliance Checks ===" > "${OUTPUT_DIR}/sox_checks.txt"
        echo "User Access Controls:" >> "${OUTPUT_DIR}/sox_checks.txt"
        getent passwd >> "${OUTPUT_DIR}/sox_checks.txt" 2>&1 || true
        echo "" >> "${OUTPUT_DIR}/sox_checks.txt"
        echo "Sudo Privileges:" >> "${OUTPUT_DIR}/sox_checks.txt"
        cat /etc/sudoers >> "${OUTPUT_DIR}/sox_checks.txt" 2>&1 || true
        ;;
        
    *)
        log "Using general compliance evidence collection..."
        EVIDENCE_DIRS=(
            "/var/log"
            "/etc"
            "$HOME/security-policies"
            "/etc/crontab"
            "/var/spool/cron/crontabs"
        )
        ;;
esac

# System information collection
log "Collecting system information..."
echo "=== System Information ===" > "${OUTPUT_DIR}/system_info.txt"
echo "Hostname: $(hostname)" >> "${OUTPUT_DIR}/system_info.txt"
echo "OS Version: $(cat /etc/os-release 2>/dev/null || echo 'N/A')" >> "${OUTPUT_DIR}/system_info.txt"
echo "Kernel Version: $(uname -r)" >> "${OUTPUT_DIR}/system_info.txt"
echo "Uptime: $(uptime)" >> "${OUTPUT_DIR}/system_info.txt"
echo "Date: $(date)" >> "${OUTPUT_DIR}/system_info.txt"

# Network configuration
log "Collecting network configuration..."
echo "=== Network Configuration ===" > "${OUTPUT_DIR}/network_config.txt"
ip addr show >> "${OUTPUT_DIR}/network_config.txt" 2>&1 || ifconfig >> "${OUTPUT_DIR}/network_config.txt" 2>&1 || echo "Network info unavailable" >> "${OUTPUT_DIR}/network_config.txt"
echo "" >> "${OUTPUT_DIR}/network_config.txt"
netstat -tuln >> "${OUTPUT_DIR}/network_config.txt" 2>&1 || ss -tuln >> "${OUTPUT_DIR}/network_config.txt" 2>&1 || echo "Port info unavailable" >> "${OUTPUT_DIR}/network_config.txt"

# Running services
log "Collecting service information..."
echo "=== Running Services ===" > "${OUTPUT_DIR}/services.txt"
systemctl list-units --type=service --state=running >> "${OUTPUT_DIR}/services.txt" 2>&1 || service --status-all >> "${OUTPUT_DIR}/services.txt" 2>&1 || echo "Service info unavailable" >> "${OUTPUT_DIR}/services.txt"

# Installed packages
log "Collecting package information..."
echo "=== Installed Packages ===" > "${OUTPUT_DIR}/packages.txt"
if command -v dpkg &> /dev/null; then
    dpkg -l >> "${OUTPUT_DIR}/packages.txt" 2>&1
elif command -v rpm &> /dev/null; then
    rpm -qa >> "${OUTPUT_DIR}/packages.txt" 2>&1
else
    echo "Package manager not found" >> "${OUTPUT_DIR}/packages.txt"
fi

# Security updates
log "Collecting security update information..."
echo "=== Security Updates ===" > "${OUTPUT_DIR}/security_updates.txt"
if command -v apt &> /dev/null; then
    apt list --upgradable | grep -i security >> "${OUTPUT_DIR}/security_updates.txt" 2>&1 || echo "No security updates pending" >> "${OUTPUT_DIR}/security_updates.txt"
elif command -v yum &> /dev/null; then
    yum --security check-update >> "${OUTPUT_DIR}/security_updates.txt" 2>&1 || echo "No security updates pending" >> "${OUTPUT_DIR}/security_updates.txt"
fi

# Copy evidence files
log "Copying evidence files..."
for evidence_path in "${EVIDENCE_DIRS[@]}"; do
    if [[ -e "$evidence_path" ]]; then
        log "Copying: $evidence_path"
        # Create directory structure in output
        target_dir="${OUTPUT_DIR}$(dirname "$evidence_path")"
        mkdir -p "$target_dir"
        
        # Copy files with error handling
        if [[ -d "$evidence_path" ]]; then
            cp -r "$evidence_path" "$target_dir/" 2>/dev/null || log "Warning: Could not copy directory $evidence_path"
        else
            cp "$evidence_path" "$target_dir/" 2>/dev/null || log "Warning: Could not copy file $evidence_path"
        fi
    else
        log "Warning: Evidence path not found: $evidence_path"
    fi
done

# Generate checksums for integrity verification
log "Generating checksums for integrity verification..."
find "$OUTPUT_DIR" -type f -exec sha256sum {} \; > "${OUTPUT_DIR}/checksums.sha256"

# Create final archive
log "Creating final archive..."
tar -czf "$ARCHIVE_NAME" -C "$(dirname "$OUTPUT_DIR")" "$(basename "$OUTPUT_DIR")"

# Generate summary report
TOTAL_FILES=$(find "$OUTPUT_DIR" -type f | wc -l)
ARCHIVE_SIZE=$(du -h "$ARCHIVE_NAME" | cut -f1)

cat > "${OUTPUT_DIR}/collection_summary.txt" << EOF
=== Compliance Evidence Collection Summary ===
Framework: $FRAMEWORK
Timestamp: $TIMESTAMP
Total Files Collected: $TOTAL_FILES
Archive Size: $ARCHIVE_SIZE
Archive Name: $ARCHIVE_NAME

Evidence Categories Collected:
$(printf '%s\n' "${EVIDENCE_DIRS[@]}")

Collection completed successfully at: $(date)
EOF

log "Evidence collection completed successfully!"
log "Archive created: $ARCHIVE_NAME"
log "Summary available in: ${OUTPUT_DIR}/collection_summary.txt"

# Optional: Clean up working directory (uncomment if desired)
# rm -rf "$OUTPUT_DIR"

echo ""
echo "🎉 Compliance evidence collection complete!"
echo "📦 Archive: $ARCHIVE_NAME"
echo "📊 Files collected: $TOTAL_FILES"
echo "💾 Archive size: $ARCHIVE_SIZE"
