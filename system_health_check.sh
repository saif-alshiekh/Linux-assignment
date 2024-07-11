#!/bin/bash

# Define variables
LOG_FILE="/var/log/system_health_check.log"
TIMESTAMP=$(date +"%Y-%m-%d_(%H:%M:%S)")
REPORT_FILE="/var/log/health_report_${TIMESTAMP}.txt"


# Function to log messages
log_message() {
    echo "$1" | tee -a $LOG_FILE
}


# Disk space check
log_message "Checking disk space..."| tee -a $REPORT_FILE
df -h | tee -a $REPORT_FILE

# Network performance check
log_message "Checking network performance..."| tee -a $REPORT_FILE
ping -c 5 google.com | tee -a $REPORT_FILE


# Memory usage check
log_message "Checking memory usage..."| tee -a $REPORT_FILE
free -h | tee -a $REPORT_FILE


# Running services check
log_message "Checking running services..."| tee -a $REPORT_FILE
systemctl list-units --type=service --state=running | tee -a $REPORT_FILE


# System updates check
log_message "Checking for recent system updates..."| tee -a $REPORT_FILE
if command -v apt-get &> /dev/null; then
    apt-get update &> /dev/null
    apt-get -s upgrade | grep "upgraded," | tee -a $REPORT_FILE
elif command -v yum &> /dev/null; then
    yum check-update &> /dev/null
    yum list updates | tee -a $REPORT_FILE
else
    log_message "ERROR: Unsupported package manager."
fi

log_message "System health check complete. Report saved to $REPORT_FILE."
