# Private Server

Ubuntu Linux Server VM setup instructions.

## Proxmox

TODO

## Linux Install

Mostly choose defaults. Do NOT install docker.

```bash
sudo apt update
sudo apt upgrade
sudo reboot
```

## Server Prereq Steps

### Install Docker
[Reference](https://docs.docker.com/engine/install/ubuntu/)

### Set Timezone

```bash
sudo timedatectl set-timezone America/New_York
```
[Reference](https://linuxize.com/post/how-to-set-or-change-timezone-in-linux/)


