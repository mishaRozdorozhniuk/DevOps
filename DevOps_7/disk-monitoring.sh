#!/bin/bash

LOG_FILE="/var/log/disk.log"
DEFAULT_THRESHOLD=80

THRESHOLD_PERCENT="${THRESHOLD_PERCENT:-$DEFAULT_THRESHOLD}"

USAGE=$(df -P / | awk 'NR>1 {print $5}' | sed 's/%//')

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

if [[ -n "$USAGE" && "$USAGE" -ge "$THRESHOLD_PERCENT" ]]; then
    MESSAGE="WARNING: Disk usage on / is at ${USAGE}% (threshold: ${THRESHOLD_PERCENT}%)."

    echo "${TIMESTAMP} - ${MESSAGE}" | sudo tee -a "${LOG_FILE}"
fi

exit 0
