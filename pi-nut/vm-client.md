# NUT Client on VM

Install NUT Client on VM setup on Proxmox or other Hyper-V to connect to a NUT Server.

## Early Shutdown Notice

This NUT Client will establish "early" shutdown logic so the VM will shutdown shortly after ON BATTERY signal. This will allow VMs to shut down prior to Proxmox/Hyper-V instances shutting down.

## Setup

SSH to VM

```bash
ssh <user>@192.168.x.x
```

Install `nut-client`

```bash
sudo apt install nut-client
```

Verifiy connection to NUT Server

```bash
upsc server-rack-ups@NUT_SERVER_IP_ADDRESS
```

## Configure

Edit `upsmon.conf` to setup MONITOR directive

```bash
sudo nano /etc/nut/upsmon.conf
```

`NUT_SERVER_IP_ADDRESS` is the IP of the NUT Server connected to the UPS. `PASSWORD` is the secondary/`observer` password defined in `upsd.users` on the NUT Server.

```bash
MONITOR server-rack-ups@NUT_SERVER_IP_ADDRESS 1 observer PASSWORD secondary

NOTIFYCMD /user/sbin/upssched
POLLFREQALERT 1

NOTIFYFLAG ONLINE       SYSLOG+WALL+EXEC
NOTIFYFLAG ONBATT       SYSLOG+WALL+EXEC
NOTIFYFLAG LOWBATT      SYSLOG+WALL+EXEC
```

Setup `upssched.conf` to handle early shutdown configuration

```bash
sudo nano /etc/nut/upssched.conf
```

```bash
CMDSCRIPT /usr/local/bin/nut-upssched.sh

PIPEFN /var/run/nut/upssched.pipe
LOCKFN /var/run/nut/upssched.lock

# 1. On Battery Early Shutdown
AT ONBATT * START-TIMER early-shutdown 60
AT ONLINE * CANCEL-TIMER early-shutdown
```

Create script for early shutdown. NOTE: may need to setup proper permissions for nut user

```bash
sudo touch /usr/local/bin/nut-upssched.sh
```

```bash
#!/bin/bash

case $1 in
    early-shutdown)
        logger -t upssched "Early Shutdown initiated."
        /usr/sbin/upsmon -c fsd
        ;;
    *)
        logger -t upssched "Unknown event received: $1"
        ;;
esac
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