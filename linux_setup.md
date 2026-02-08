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

### Mount Local Disks

1. Identify the new disk:

    ```bash
    lsblk
    ```

2. Partition the disk (if necessary): If the disk is new and has no partitions, use `fdisk`  or `parted` to create a partition (e.g., `sudo fdisk /dev/sdb` ).

3. Format the partition: Format the new partition with a filesystem, such as ext4.

    ```bash
    sudo mkfs.ext4 /dev/sdb1
    ```

4. Create a mount point: Create a directory where the disk will be accessed.

    ```bash
    sudo mkdir -p /mnt/volumes
    ```

5. Get the UUID of the partition: Use `blkid` to find the UUID, which is more reliable than device names.

    ```bash
    sudo blkid /dev/sdb1
    ```

6. Edit `/etc/fstab`: Open the file with a text editor.

    ```bash
    sudo nano /etc/fstab
    ```

7. Add the entry: Add the following line to the end of the file.

    ```bash
    UUID=your-uuid /mnt/volumes ext4 defaults 0 2
    ```

8. Test the mount: Run `sudo mount -a` to test the configuration. If no errors are returned, the disk is properly configured.
