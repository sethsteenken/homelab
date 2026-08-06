# Pi-NUT

Raspberry Pi used with NUT to monitor power from UPS and handle graceful shutdown of equipment

## Setup

### Install

Install OS on Flash drive for Raspberry Pi and setup SSH. (https://www.raspberrypi.com/software/)[https://www.raspberrypi.com/software/]

```bash
sudo apt install -y nut
```

### Setup UPS Config

Plug in UPS to Pi and run scanner

```bash
sudo nut-scanner
```

Edit NUT's `ups.conf` and add the config for the UPS. See [ups.conf](./etc/nut/ups.conf).

```bash
sudo nano /etc/nut/ups.conf
```

### Setup NUT Server

Edit `nut.conf` to enable NUT. See [nut.conf](./etc/nut/nut.conf).

```bash
sudo nano /etc/nut/nut.conf
```

```bash
MODE=netserver
```

Edit `upsd.conf` to include listener. See [upsd.conf](./etc/nut/upsd.conf).

```bash
sudo nano /etc/nut/upsd.conf
```

```bash
LISTEN 0.0.0.0 3493
```

Edit `upsd.users` to have `admin` and `observer` users. See [upsd.users](./etc/nut/upsd.users).

```bash
sudo nano /etc/nut/upsd.users
```

### Setup NUT Monitor

Edit `upsmon.conf` values and include monitor directive, `NOTIFYCMD` and `NOTIFYFLAG` values. See [upsmon.conf](./etc/nut/upsmon.conf).

```bash
sudo nano /etc/nut/upsmon.conf
```

```bash
MONITOR server-rack-ups@localhost 1 admin ADMIN_PASSWORD_HERE primary

NOTIFYCMD /user/sbin/upssched

# + NOTIFYFLAG values from sample
```

### Setup Notify/Schedule

Edit `upssched.conf` to include `CMDSCRIPT` and `AT` values. See [upssched.conf](./etc/nut/upssched.conf).

```bash
sudo nano /etc/nut/upsched.conf
```

Include scripts in [user/local/bin](./user/local/bin/) in same location in the Pi.

Update [net-upsched.sh](./user/local/bin/nut-upssched.sh) `DISCORD_URL` to custom [Discord webhook](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks) to send UPS notifications.

### Finalize

Restart the NUT services and enable on-boot:

```bash
sudo systemctl restart nut-server
sudo systemctl enable nut-server
sudo systemctl restart nut-monitor
sudo systemctl enable nut-monitor
```

Confirm installation

```bash
upsc server-rack-ups
```

## Troubleshooting

```bash
sudo upscmd -l server-rack-ups
```

May need to confirm permissions are setup for nut user (or root if using that).

```bash
sudo chmod +x /usr/local/bin/nut-upssched.sh
sudo chown root:nut /usr/local/bin/nut-upssched.sh
sudo chmod +x /usr/local/bin/shutdown-unas.sh
sudo chown root:nut /usr/local/bin/shutdown-unas.sh

sudo chmod +x /run/nut/upssched/
sudo chown root:nut /run/nut/upssched/
```

Test the notify script directly

```bash
NOTIFYTYPE="ONBATT" UPSNAME="server-rack-ups@localhost" /usr/local/bin/nut-upssched.sh
```

Test the notify hook process for the UPS

```bash
NOTIFYTYPE="ONBATT" UPSNAME="server-rack-ups@localhost" /usr/sbin/upssched
```

## Planned Schedule

On Battery - 1 min
- Pi NUT - shuts down UNAS
- Main Server VM shuts down
- Private Server VM shuts down
- Secondary Server VM shuts down

On Battery - 3 mins
- Main Server Proxmox (1) shuts down
- Secondary Server Proxmox (2) shuts down

Low Battery
- Pi NUT - shuts down UDM PRO

FSD
- Pi NUT - kill switch for UPS
- Pi NUT shuts down

## References

[https://www.jeffgeerling.com/blog/2025/nut-on-my-pi-so-my-servers-dont-die/[(https://www.jeffgeerling.com/blog/2025/nut-on-my-pi-so-my-servers-dont-die/)]

