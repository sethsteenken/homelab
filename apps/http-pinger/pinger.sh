#!/bin/bash

# HTTP Pinger with health monitoring integration

HEALTH_FILE="/var/log/health_status.txt"

# Function to update health status
update_health_status() {
    local exit_code=$1
    
    if [ ! -f "$HEALTH_FILE" ]; then
        echo "0" > "$HEALTH_FILE"
    fi
    
    local failure_count=$(cat "$HEALTH_FILE" 2>/dev/null || echo "0")
    
    # Ensure failure_count is numeric
    if ! [[ "$failure_count" =~ ^[0-9]+$ ]]; then
        failure_count=0
    fi
    
    if [ $exit_code -eq 0 ]; then
        echo "0" > "$HEALTH_FILE"

        # Success - reset failure counter if there were previous failures
        if [ $failure_count -gt 0 ]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Health status reset: consecutive failures = 0 (recovered from $failure_count failures)"
        fi
    else
        # Failure - increment counter
        failure_count=$((failure_count + 1))
        echo "$failure_count" > "$HEALTH_FILE"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Health status updated: consecutive failures = $failure_count"
    fi
}

# Check if URL is set
if [ -z "$URL" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: URL environment variable is not set"
    update_health_status 1
    exit 1
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Pinging $URL"

# Use curl with proper error handling and response code checking
HTTP_CODE=$(curl -sS -w "%{http_code}" -o /tmp/response.txt --max-time 30 --retry 3 --retry-delay 5 "$URL" 2>/tmp/curl_error.txt)
CURL_EXIT_CODE=$?

# Check if curl command failed (network issues, DNS resolution, etc.)
if [ $CURL_EXIT_CODE -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: curl command failed with exit code $CURL_EXIT_CODE"
    if [ -s /tmp/curl_error.txt ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - curl error details: $(cat /tmp/curl_error.txt)"
    fi
    # Clean up temp files
    rm -f /tmp/response.txt /tmp/curl_error.txt
    update_health_status 1
    exit 1
fi

# Check HTTP response code
if [[ "$HTTP_CODE" =~ ^2[0-9][0-9]$ ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - SUCCESS: Received HTTP $HTTP_CODE response"
    # Optionally log response size
    if [ -f /tmp/response.txt ]; then
        RESPONSE_SIZE=$(wc -c < /tmp/response.txt)
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Response size: $RESPONSE_SIZE bytes"
    fi
    # Clean up temp files
    rm -f /tmp/response.txt /tmp/curl_error.txt
    update_health_status 0
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Ping completed successfully"
    exit 0
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - WARNING: Received non-2xx HTTP response code: $HTTP_CODE"
    # Log response body for debugging if it's not too large
    if [ -f /tmp/response.txt ] && [ $(wc -c < /tmp/response.txt) -lt 1000 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Response body: $(cat /tmp/response.txt)"
    fi
    # Clean up temp files
    rm -f /tmp/response.txt /tmp/curl_error.txt
    update_health_status 1
    exit 2
fi