# Create a new crontab file
touch /etc/cron.d/crontab

# Grep all env variable and COPY to crontab file
printenv | sed 's/^\(.*\)$/\1/g' > /etc/cron.d/crontab

echo "SHELL=/bin/bash

$CRON_SCHEDULE bash /var/scripts/pinger.sh >> /var/log/pinger.log 2>&1
# This line must be always present" >> /etc/cron.d/crontab

crontab /etc/cron.d/crontab

# Starting the cron daemon. The & is important and will allow to execute scripts below
cron -f &

bash /var/scripts/pinger.sh >> /var/log/pinger.log 2>&1
tail -f /var/log/pinger.log