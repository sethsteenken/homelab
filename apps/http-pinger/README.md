# HTTP Pinger

Docker image for a service that periodically pings an HTTP endpoint based on a given cron schedule.

This image is designed to be run as a container in a Docker environment. It periodically sends HTTP requests to a specified endpoint to check if it's up and running. You can specify the cron schedule for the pings using the `CRON_SCHEDULE` environment variable.

To use this image, you need to provide the following environment variables:

- `URL`: the URL of the endpoint to ping
- `CRON_SCHEDULE`: the cron schedule for the pings (e.g. `*/5 * * * *` for every 5 minutes)

# Build and Run
docker build . -t sethsteenken/http-pinger

docker run -d -e URL="https://hc-ping.com/00000000-0000-0000-0000-000000000000" -e CRON_SCHEDULE="* * * * *" sethsteenken/http-pinger 

# Docker Hub

This image is hosted on Docker Hub at [https://hub.docker.com/r/sethsteenken/http-pinger](https://hub.docker.com/r/sethsteenken/http-pinger).