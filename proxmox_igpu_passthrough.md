# Proxmox iGPU Passthrough Guide

This guide walks through passing an Intel integrated GPU (iGPU) through to a VM in Proxmox for hardware-accelerated transcoding (e.g., Plex/Jellyfin) or GPU workloads. It also includes a reference video and a concise summary of its description.

> Note: Intel GVT-g (mediated vGPU) was removed from newer kernels. The recommended approach today is standard PCI passthrough of the iGPU where supported. If you only run media services in LXC or Docker on the Proxmox host, consider mapping `/dev/dri` to the container instead of PCI passthrough.

## Prerequisites

- VT-d/AMD-Vi (IOMMU) enabled in BIOS/UEFI.
- Proxmox VE 7/8 with up-to-date kernel.
- Ability to access the host via SSH or console if the iGPU is the only display device (host may need to run headless).
- Back up your VM and host configs before making changes.

## Step 1 — Enable IOMMU on Proxmox

Edit GRUB defaults to enable IOMMU (Intel shown; use `amd_iommu=on` for AMD):

```bash
sudo nano /etc/default/grub
```

Find `GRUB_CMDLINE_LINUX_DEFAULT` and append:

```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt"
```

Then update GRUB and reboot:

```bash
sudo update-grub
sudo reboot
```

For AMD, use:

```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on iommu=pt"
```

## Step 2 — Identify the iGPU and related functions

Locate the GPU and its HDMI audio function (if present):

```bash
lspci -nnk | grep -E "VGA|Audio" -A3
```

Note the PCI IDs in the form `vendor:device` (e.g., `8086:9bc8`). You may need to passthrough both the VGA controller and its audio device.

## Step 3 — Prevent the host from binding the iGPU (PCI passthrough)

On a host meant to pass the iGPU to a VM, the Proxmox host should not bind `i915` to the iGPU. Blacklist and bind to `vfio-pci` instead.

1) Blacklist host drivers (adjust as needed):

```bash
echo -e "blacklist i915\nblacklist snd_hda_intel" | sudo tee /etc/modprobe.d/blacklist-igpu.conf
```

2) Bind GPU PCI IDs to `vfio-pci` (replace with your IDs):

```bash
sudo nano /etc/modprobe.d/vfio.conf
```

Add a line:

```bash
options vfio-pci ids=8086:XXXX,8086:YYYY disable_vga=1
```

3) Ensure VFIO core modules load on boot:

```bash
echo -e "vfio\nvfio_iommu_type1\nvfio_pci\nvfio_virqfd" | sudo tee -a /etc/modules
```

4) Update initramfs and reboot:

```bash
sudo update-initramfs -u
sudo reboot
```

After reboot, confirm devices bind to `vfio-pci`:

```bash
lspci -nnk | grep -E "VGA|Audio" -A3
```

Look for `Kernel driver in use: vfio-pci` for the iGPU and its audio function (if passed).

## Step 4 — Attach the iGPU to the VM

In the Proxmox UI:

- Select the VM → Hardware → Add → PCI Device.
- Choose the Intel GPU and (optionally) its audio function.
- Enable `PCI-Express`.
- Consider `All Functions` if required by your hardware.
- Do not enable `Primary GPU` unless you intend to use it as the VM’s display.

Start the VM. If it fails to start, review `dmesg` and Proxmox logs for IOMMU/ACS errors and ensure the host no longer binds to `i915`.

## Step 5 — Guest OS setup

### Linux guest (Debian/Ubuntu)

Install Intel media/VAAPI drivers and tools:

```bash
sudo apt update
sudo apt install -y vainfo intel-media-va-driver-non-free
# On some distros: intel-media-driver
```

Verify VAAPI/QSV:

```bash
vainfo
ffmpeg -hide_banner -hwaccel qsv -v verbose -i sample.mp4 -f null -
```

For Docker media servers in the guest:

```bash
docker run --rm \
	--device /dev/dri:/dev/dri \
	--group-add video \
	-p 8096:8096 \
	jellyfin/jellyfin:latest
```

Enable hardware acceleration in the app settings (VAAPI/QSV). Plex/Jellyfin logs should show `qsv`/`vaapi` in use.

### Windows guest

- Install the latest Intel Graphics driver inside Windows.
- Enable hardware acceleration in Plex/Jellyfin.
- Verify with transcoding logs or tools indicating QSV/DXVA usage.

## Verification & Troubleshooting

- Check IOMMU groups: `find /sys/kernel/iommu_groups -type l` to ensure isolation.
- If the host fails to boot (no display), access via SSH/serial and remove `blacklist-igpu.conf` or bind back to `i915`.
- Some platforms require passing both GPU and audio functions together (`All Functions`).
- GVT-g is deprecated; if you followed older guides, switch to PCI passthrough.
- If you run media servers on the Proxmox host or LXC, do not blacklist `i915`. Instead, map `/dev/dri` into containers.

## Alternative: LXC/Container acceleration on host (no PCI passthrough)

If you prefer keeping the iGPU on the host for LXC/Docker:

1) Ensure `i915` is loaded on the host:

```bash
echo i915 | sudo tee -a /etc/modules
sudo update-initramfs -u
sudo reboot
```

2) For LXC containers, add to the container config (`/etc/pve/lxc/<CTID>.conf`):

```
lxc.cgroup.devices.allow: c 226:* rwm
lxc.mount.entry: /dev/dri dev/dri none bind,create=dir 0 0
```

3) In Docker, run with:

```bash
docker run --rm --device /dev/dri:/dev/dri --group-add video ...
```

## Video Reference

- YouTube: https://www.youtube.com/watch?v=UoL8YJAc-vE

### Summary of the video description

The referenced video demonstrates enabling Intel iGPU hardware acceleration with Proxmox, highlighting BIOS/UEFI settings, IOMMU configuration, and passing the iGPU to a guest for media transcoding. It covers the practical steps to attach the device in Proxmox and verify acceleration inside the guest (e.g., Plex/Jellyfin), along with common pitfalls and checks to confirm the GPU is correctly utilized.

> Copyright notice: I haven't included the full video description verbatim to avoid reproducing copyrighted text. The summary above conveys the key points, and the direct link is provided for full context.

