#!/bin/bash

# Health monitor script for HTTP pinger
# Tracks consecutive failures and determines container health

HEALTH_FILE="/var/log/health_status.txt"
MAX_FAILURES=${MAX_FAILURES:-3}

# Initialize health file if it doesn't exist
if [ ! -f "$HEALTH_FILE" ]; then
    echo "0" > "$HEALTH_FILE"
fi

# Read current failure count
FAILURE_COUNT=$(cat "$HEALTH_FILE" 2>/dev/null || echo "0")

# Check if failure count is numeric
if ! [[ "$FAILURE_COUNT" =~ ^[0-9]+$ ]]; then
    FAILURE_COUNT=0
fi

# Validate MAX_FAILURES is numeric and positive
if ! [[ "$MAX_FAILURES" =~ ^[1-9][0-9]*$ ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - WARNING: Invalid MAX_FAILURES value '$MAX_FAILURES', using default of 3"
    MAX_FAILURES=3
fi

# Check if we've exceeded max failures
if [ "$FAILURE_COUNT" -ge "$MAX_FAILURES" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - UNHEALTHY: $FAILURE_COUNT consecutive failures (max: $MAX_FAILURES)"
    exit 1
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - HEALTHY: $FAILURE_COUNT consecutive failures (max: $MAX_FAILURES)"
    exit 0
fi