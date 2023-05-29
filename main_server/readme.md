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

`
HOST_IP_ADDRESS=
NAS_IP_ADDRESS=
NAS_SSH_USER=
NAS_SSH_PASSWORD=
MQTT_HEALTH_PROBE_USER=
MQTT_HEALTH_PROBE_PASSWORD=
POSTGRES_USER=
POSTGRES_PASSWORD=
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
`
