# Linux Setup

## Install

Mostly choose defaults. 

* Install 3rd-party Software
* For storage setup, be sure entire size the disk applied to the VM is set under the SIZE of the ubuntu-lv device mounted at /
* Install OpenSSH Server
* Do NOT select any Server Snaps

After logging into the console or over SSH, run the following:

```bash
sudo apt update
sudo apt upgrade
sudo reboot
```

## Server Prereq Steps

### Install Docker

Install via the [*apt repository method*](https://docs.docker.com/engine/install/ubuntu/).

### Set Timezone

```bash
sudo timedatectl set-timezone America/New_York
```

Confirm:

```bash
ls -l /etc/localtime
```

[Reference](https://linuxize.com/post/how-to-set-or-change-timezone-in-linux/)
