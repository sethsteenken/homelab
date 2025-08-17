FROM debian:buster-slim

RUN apt-get update && apt-get install -y git cron bash curl && apt-get clean

ADD entrypoint.sh /var/scripts/
ADD pinger.sh /var/scripts/
ADD health_monitor.sh /var/scripts/

RUN chmod +x /var/scripts/entrypoint.sh /var/scripts/pinger.sh /var/scripts/health_monitor.sh

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=1 \
    CMD bash /var/scripts/health_monitor.sh

ENTRYPOINT /var/scripts/entrypoint.sh