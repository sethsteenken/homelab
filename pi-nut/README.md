# Pi-NUT

Raspberry Pi used with NUT to monitor power from UPS and handle graceful shutdown of equipment

## Helper Commands

```bash
sudo upsc server-rack-ups
```

```bash
sudo upscmd -l server-rack-ups
```

```bash
sudo chmod +x /usr/local/bin/nut-upssched.sh
sudo chown root:nut /usr/local/bin/nut-upssched.sh
sudo chmod +x /usr/local/bin/shutdown-unas.sh
sudo chown root:nut /usr/local/bin/shutdown-unas.sh

sudo chmod +x /run/nut/upssched/
sudo chown root:nut /run/nut/upssched/
```

```bash
NOTIFYTYPE="ONBATT" UPSNAME="server-rack-ups@localhost" /usr/local/bin/nut-upssched.sh
```

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
