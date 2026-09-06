# NUT Client on Proxmox

Install NUT Client on root Proxmox VE to connect to a NUT Server.

## Setup

SSH to Proxmox VE instance

```bash
ssh root@192.168.x.x
```

Install `nut-client`

```bash
apt install nut-client
```

Verifiy connection to NUT Server

```bash
upsc server-rack-ups@NUT_SERVER_IP_ADDRESS
```

## Configure

Edit `upsmon.conf` to setup MONITOR directive

```bash
nano /etc/nut/upsmon.conf
```

`NUT_SERVER_IP_ADDRESS` is the IP of the NUT Server connected to the UPS. `PASSWORD` is the secondary/`observer` password defined in `upsd.users` on the NUT Server.

```bash
RUN_AS_USER root

MONITOR server-rack-ups@NUT_SERVER_IP_ADDRESS 1 observer PASSWORD secondary

POLLFREQALERT 1
```

Edit `nut.conf` to enable the client

```bash
nano /etc/nut/nut.conf
```

```bash
MODE=netclient
```

Restart and enable NUT Client

```bash
systemctl restart nut-client
systemctl enable nut-client
```

## Confirm

SSH to the NUT Server machine and confirm the Proxmox IP appears as a client

```bash
upsc -c server-rack-ups
```