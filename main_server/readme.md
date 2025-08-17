# Main Server

Ubuntu Linux Server VM setup instructions.

## Proxmox

Follow Instructions [here](/proxmox_setup.md)

## Create VM

* Leave Most Defaults (SeaBIOS, etc)
* Add *Local_Storage* (no more than half of available space)
* Use default vmbr0 bridge for networking

## Linux Install

Follow Instructions [here](/linux_setup.md)

## Docker Prereqs

### Disable Systemd

Pihole requres Systemd be disabled. Reference

```bash
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
```

### Authenticate with Docker Hub

```bash
docker login
```

### Docker Compose Setup

Follow [instructions here](/docker_compose.md) to setup docker-compose.yaml.

Environment variables for .env file:

```bash
HOST_IP_ADDRESS=
FOUNDRY_VTT_USERNAME=
FOUNDRY_VTT_PASSWORD=
NAS_IP_ADDRESS=
NAS_SSH_USER=
NAS_SSH_PASSWORD=
MQTT_HEALTH_PROBE_USER=
MQTT_HEALTH_PROBE_PASSWORD=
POSTGRES_USER=
POSTGRES_PASSWORD=
POSTGRES_VERSION=
KEGMONITOR_CONN_STRING=
KEGMONITOR_DOMAIN=
KEGMONITOR_MQTT_PASSWORD=
PGADMIN_DEFAULT_EMAIL=
PGADMIN_DEFAULT_PASSWORD=
VSCODE_PASSWORD=
PIHOLE_WEB_PASSWORD=
TIMEZONE=
CLOUDFLARE_DNS_ZONE=
CLOUDFLARE_API_KEY=
CONTAINERS_HEALTHCHECK_DISCORD_WEBHOOK=
HEALTHCHECKSIO_URL=
HEALTHCHECKSIO_CRON_SCHEDULE=
HEALTHCHECKSIO_STATUS_URL=
```

## Run Docker Compose

`
sudo docker compose up -d
`

## Task Schedule

| Task       | Dataset    | Schedule   |
|------------|------------|------------|
| Volumes Backup | * | Daily 3am |
| Watchtower | * | Daily 4am |
| Plex Cleanup | * | Daily 1am-2am |
| Healthchecks.io | * | Every 10 minutes |

## Notes

DNS configuration is set for each service to point to `pi_hole` container as well as use a public DNS server like Cloudflare's `1.1.1.1`. This is done to address unknown DNS resolution issue with containers not able to resolve public hostnames.