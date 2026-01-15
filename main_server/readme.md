# Main Server

Ubuntu Linux Server VM setup instructions.

## Proxmox

Follow [Instructions](/proxmox_setup.md)

## Create VM

* Leave Most Defaults (SeaBIOS, etc)
* Add *Local_Storage* (no more than half of available space)
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

## Mount NAS Shares

### Install NFS Client

See [details on nfs-common package](https://phoenixnap.com/kb/ubuntu-nfs-server#How_to_Install_NFS_Client).

```bash
sudo apt update
sudo apt install nfs-common
```

### Mount Samba Shares

Mount Samba shares directly via IP and credentials on the docker volume configuration in `docker-compose.yaml`. See [Mounting Samba Shares](https://docs.docker.com/engine/storage/volumes/#create-cifssamba-volumes) for more details.

### Mount NFS Shares

Using the [mount](https://phoenixnap.com/kb/linux-mount-command) commands below, mount the required shares from the NAS to the host Linux server.

NOTE: creating the docker volume via the command below instead of using Docker Compose later will cause a warning about the volume not being created by Docker Compose and how it should be labeled `external`. It may be better to wait until Docker Compose event to mount the NFS shares to the volumes.

```bash
sudo docker volume create --driver local --opt type=nfs --opt o=addr=<NAS IP ADDRESS>,rw,noatime,rsize=8192,wsize=8192,tcp,timeo=14,nfsvers=4 --opt device=:/mnt/<pool name>/<share name> <volume name>

sudo bash
mount -t nfs4 <NAS IP ADDRESS>:/mnt/<pool name>/<share name> /var/lib/docker/volumes/<volume name>/_data -o rw,noatime,rsize=8192,wsize=8192,tcp,timeo=14,nfsvers=4
```

See the latest [Docker Compose file](docker-compose.yaml) for the list of shares and volume names to use.

## Run Docker Compose

```bash
sudo docker compose up -d
```

## Task Schedule

| Task       | Dataset    | Schedule   |
|------------|------------|------------|
| Volumes Backup | * | Daily 3am |
| Watchtower | * | Daily 4am |
| Plex Cleanup | * | Daily 1am-2am |
| Healthchecks.io | * | Every 10 minutes |

## Notes

DNS configuration is set for each service to point to `pi_hole` container as well as use a public DNS server like Cloudflare's `1.1.1.1`. This is done to address unknown DNS resolution issue with containers not able to resolve public hostnames.
