# Private Server

Ubuntu Linux Server VM setup instructions.

## Proxmox

Follow Instructions [here](/proxmox_setup.md)

## Create VM

* Leave Most Defaults (SeaBIOS, etc)
* Add *Local_Storage* (no more than half of available space)
* Use default vmbr0 bridge for networking
* !Important - Select appropriate VLAN tag for VPN outbound network

## Linux Install

Follow Instructions [here](/linux_setup.md)

### Traceroute to Test VPN

```bash
sudo apt install traceroute
```

```bash
traceroute google.com
```
