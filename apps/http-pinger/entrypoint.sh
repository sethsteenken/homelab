#!/bin/bash

# Ensure log directory exists and has proper permissions
mkdir -p /var/log
touch /var/log/pinger.log
touch /var/log/health_status.txt

# Initialize health status
echo "0" > /var/log/health_status.txt

# Create a new crontab file
touch /etc/cron.d/crontab

# Grep all env variable and COPY to crontab file
printenv | sed 's/^\(.*\)$/\1/g' > /etc/cron.d/crontab

echo "SHELL=/bin/bash

$CRON_SCHEDULE bash /var/scripts/pinger.sh >> /var/log/pinger.log 2>&1
# This line must be always present" >> /etc/cron.d/crontab

crontab /etc/cron.d/crontab

echo "$(date '+%Y-%m-%d %H:%M:%S') - HTTP Pinger container starting..."
echo "$(date '+%Y-%m-%d %H:%M:%S') - Target URL: $URL"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Cron Schedule: $CRON_SCHEDULE"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Health check will mark container unhealthy after 3 consecutive failures"

# Starting the cron daemon. The & is important and will allow to execute scripts below
cron -f &

# Run initial ping
bash /var/scripts/pinger.sh >> /var/log/pinger.log 2>&1

# Tail the log file to keep container running and show logs
tail -f /var/log/pinger.log