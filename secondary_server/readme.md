# Secondary Server

Ubuntu Linux Server VM setup instructions.

## Proxmox

Follow [Instructions](/proxmox_setup.md)

## Create VM

* Leave Most Defaults (SeaBIOS, etc)
* Add HDD storage if available
* Use default vmbr0 bridge for networking

## Linux Install

Follow [Instructions](/linux_setup.md)

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
NAS_IP_ADDRESS=
NAS_SSH_USER=
NAS_SSH_PASSWORD=
TIMEZONE=
HEALTHCHECKSIO_URL=
HEALTHCHECKSIO_CRON_SCHEDULE=
```

## Run Docker Compose

```bash
sudo docker compose up -d
```

## Notes

DNS configuration is set for each service to point to `pi_hole` container as well as use a public DNS server like Cloudflare's `1.1.1.1`. This is done to address unknown DNS resolution issue with containers not able to resolve public hostnames.
