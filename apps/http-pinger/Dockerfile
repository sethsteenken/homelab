FROM debian:buster-slim

RUN apt-get update && apt-get install -y git cron bash curl && apt-get clean

ADD entrypoint.sh /var/scripts/
ADD pinger.sh /var/scripts/

RUN chmod +x /var/scripts/entrypoint.sh /var/scripts/pinger.sh

ENTRYPOINT /var/scripts/entrypoint.sh