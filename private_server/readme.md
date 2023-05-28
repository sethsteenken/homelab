# Private Server

Ubuntu Linux Server VM setup instructions.

## Proxmox

TODO

* Download Ubuntu Server 22+ ISO [here](https://ubuntu.com/download/server).
* Add ISO to Proxmox


## Linux Install

Mostly choose defaults. Do NOT install docker.

```bash
sudo apt update
sudo apt upgrade
sudo reboot
```

## Server Prereq Steps

### Install Docker

Install via the *apt repository method*. Follow steps [here](https://docs.docker.com/engine/install/ubuntu/).

### Set Timezone

```bash
sudo timedatectl set-timezone America/New_York
```

Confirm:

```bash
ls -l /etc/localtime
```
[Reference](https://linuxize.com/post/how-to-set-or-change-timezone-in-linux/)

### Traceroute to Test VPN

```bash
sudo apt install traceroute
```

```bash
traceroute google.com
```
