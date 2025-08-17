# HTTP Pinger

Docker image for a service that periodically pings an HTTP endpoint based on a given cron schedule with built-in health monitoring.

This image is designed to be run as a container in a Docker environment. It periodically sends HTTP requests to a specified endpoint to check if it's up and running. The container includes health monitoring that will mark the container as unhealthy after a configurable number of consecutive ping failures.

## Features

- Periodic HTTP health checks based on cron schedule
- Robust error handling with retries and timeouts
- Container health monitoring with configurable failure tracking
- Detailed logging with timestamps
- Automatic container health status updates

## Environment Variables

- `URL`: the URL of the endpoint to ping
- `CRON_SCHEDULE`: the cron schedule for the pings (e.g. `*/5 * * * *` for every 5 minutes)
- `MAX_FAILURES`: the number of consecutive failures before marking the container as unhealthy (default: `3`, minimum: `1`)

## Health Monitoring

The container implements Docker health checks that:

- Run every 30 seconds
- Track consecutive ping failures
- Mark the container as **unhealthy** after the configured number of consecutive failures (default: 3)
- Reset the failure counter on successful pings

## Build and Run

```bash
docker build . -t sethsteenken/http-pinger

docker run -d \
  -e URL="https://example.com/health" \
  -e CRON_SCHEDULE="*/5 * * * *" \
  --name http-pinger \
  sethsteenken/http-pinger
```

## Docker Hub

This image is hosted on Docker Hub at [https://hub.docker.com/r/sethsteenken/http-pinger](https://hub.docker.com/r/sethsteenken/http-pinger).

## Monitoring Integration

The unhealthy container status can be monitored by:

- Docker orchestrators (Docker Swarm, Kubernetes)
- Monitoring tools (Prometheus with cAdvisor)
- Container management platforms
- Custom monitoring scripts checking `docker inspect` output