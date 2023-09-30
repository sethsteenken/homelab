FROM debian:buster-slim

RUN apt-get update && apt-get install -y git cron bash curl && apt-get clean

ADD entrypoint.sh /entrypoint.sh
ADD pinger.sh /var/scripts/

ENTRYPOINT /entrypoint.sh