#!/bin/bash

# Simple Linux Health Check + Update Script
# Purpose:
# 1. Show basic system health information
# 2. Check for updates
# 3. Download and install updates if available
# 4. Save results to a log file

LOG_FILE="$HOME/health-update-report.txt"

echo "====================================" | tee "$LOG_FILE"
echo " Linux Health Check + Update Report" | tee -a "$LOG_FILE"
echo " Date: $(date)" | tee -a "$LOG_FILE"
echo " Hostname: $(hostname)" | tee -a "$LOG_FILE"
echo "====================================" | tee -a "$LOG_FILE"
echo | tee -a "$LOG_FILE"

echo "Logged-in user:" | tee -a "$LOG_FILE"
whoami | tee -a "$LOG_FILE"
echo | tee -a "$LOG_FILE"

echo "Uptime:" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"
echo | tee -a "$LOG_FILE"

echo "IP Address:" | tee -a "$LOG_FILE"
hostname -I | tee -a "$LOG_FILE"
echo | tee -a "$LOG_FILE"

echo "Memory Usage:" | tee -a "$LOG_FILE"
free -h | tee -a "$LOG_FILE"
echo | tee -a "$LOG_FILE"

echo "Disk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"
echo | tee -a "$LOG_FILE"

echo "Top 5 Largest Files in Your Home Folder:" | tee -a "$LOG_FILE"
find "$HOME" -type f -exec du -h {} + 2>/dev/null | sort -rh | head -n 5 | tee -a "$LOG_FILE"
echo | tee -a "$LOG_FILE"

echo "Failed systemd services:" | tee -a "$LOG_FILE"
systemctl --failed | tee -a "$LOG_FILE"
echo | tee -a "$LOG_FILE"

echo "====================================" | tee -a "$LOG_FILE"
echo " Checking for System Updates" | tee -a "$LOG_FILE"
echo "====================================" | tee -a "$LOG_FILE"
echo | tee -a "$LOG_FILE"

echo "Updating package list..." | tee -a "$LOG_FILE"
sudo apt update | tee -a "$LOG_FILE"

UPDATE_COUNT=$(apt list --upgradable 2>/dev/null | tail -n +2 | wc -l)

echo | tee -a "$LOG_FILE"

if [ "$UPDATE_COUNT" -gt 0 ]; then
    echo "$UPDATE_COUNT update(s) available." | tee -a "$LOG_FILE"
    echo "Downloading and installing updates..." | tee -a "$LOG_FILE"
    echo | tee -a "$LOG_FILE"

    sudo apt upgrade -y | tee -a "$LOG_FILE"

    echo | tee -a "$LOG_FILE"
    echo "Cleaning up unused packages..." | tee -a "$LOG_FILE"

    sudo apt autoremove -y | tee -a "$LOG_FILE"
    sudo apt autoclean | tee -a "$LOG_FILE"

    echo | tee -a "$LOG_FILE"
    echo "Updates installed successfully." | tee -a "$LOG_FILE"
else
    echo "No updates available. System is already up to date." | tee -a "$LOG_FILE"
fi

echo | tee -a "$LOG_FILE"

echo "====================================" | tee -a "$LOG_FILE"
echo " Reboot Check" | tee -a "$LOG_FILE"
echo "====================================" | tee -a "$LOG_FILE"

if [ -f /var/run/reboot-required ]; then
    echo "A reboot is required." | tee -a "$LOG_FILE"
    echo "Run this when ready:" | tee -a "$LOG_FILE"
    echo "sudo reboot" | tee -a "$LOG_FILE"
else
    echo "No reboot required." | tee -a "$LOG_FILE"
fi

echo | tee -a "$LOG_FILE"
echo "Health check and update process complete." | tee -a "$LOG_FILE"
echo "Report saved to: $LOG_FILE"