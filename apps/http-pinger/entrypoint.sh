# Adding executable permissions
chmod +x /entrypoint.sh /var/scripts/pinger.sh

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

# You can execute any other script below this line
bash /var/scripts/pinger.sh >> /var/log/pinger.log 2>&1

# We'll tail logs 
tail -f /var/log/pinger.log