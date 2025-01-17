# Simple, customized PXE

> Support BIOS and UEFI methods at the same time; Secure boot is not supported temporarily！

# Deploy the operating system
BIOS
![iShot_2025-01-16_17 30 53](https://github.com/user-attachments/assets/ad8a1a43-8f4a-4400-95f8-ba910451a494)

UEFI
![iShot_2025-01-16_17 30 38](https://github.com/user-attachments/assets/1221626f-8330-4156-9f44-82dedaee5ffb)

# System

| Name                          | Version                               | Verification   |
|-------------------------------|---------------------------------------|----------------|
| Ubuntu                        | 20.04、22.04、24.04                    | True           |
| RockyLinux                    | 8、9                                   | True           |

# Deployment

## Docker environment

## run pxe
```bash
# create dir
mkdir pxe && cd pxe

# download docker-compose.yml
wget https://raw.githubusercontent.com/sysiocn/runcontainer/refs/heads/main/container/pxe/docker-compose.yml

# run compose
docker-compose up -d
```

## Configuration

### grub.cfg
* Browser enters dufs address: `http://10.64.68.10:5000`
* Edit file: `boot/grub/grub.cfg`
* Update variable: `{dufs_node_ip}`
![image](https://github.com/user-attachments/assets/8896190e-9006-42a0-9a98-44f078a03571)

### dhcp
* Path: `./dnsmasq/dnsmasq.d`
```bash
cat > dnsmasq/dnsmasq.d/dhcp-option.conf << EOF
dhcp-range=192.168.0.50,192.168.0.150,255.255.255.0,12h
dhcp-option=3,192.168.0.1
dhcp-option=option:router,192.168.0.1
EOF
```

restart pxe
```bash
docker restart pxe
```

### upload os

#### redhat series
1. Extract the iso file and upload the decompressed file to the corresponding directory
![image](https://github.com/user-attachments/assets/4d32f92f-170b-4b2a-8755-fa80c578f8d5)

2. Update configuration item *menuentry* in `grub.cfg` file

* linux16 /os/rocky/9/9.5/x86_64/isolinux/vmlinuz
* initrd16 /os/rocky/9/9.5/x86_64/isolinux/initrd.img

```
menuentry 'Rocky Linux 9.5 (No KS) (BIOS)' --class fedora --class gnu-linux --class gnu --class os {
    echo "Loading Rocky Linux 9.5 kernel..."
    linux16 /os/rocky/9/9.5/x86_64/isolinux/vmlinuz inst.stage2=http://{dufs_node_ip}/os/rocky/9/9.5/x86_64/ ip=dhcp
    initrd16 /os/rocky/9/9.5/x86_64/isolinux/initrd.img
}
```
3. ks.cfg

Provide ks.cfg, and options such as network, disk, and time zone will be defined according to ks.cfg when deploying the system.

* ks.cfg: `/os/rocky/9/9.5/ks/`

#### ubuntu series
1. Upload images without decompression
![image](https://github.com/user-attachments/assets/fae18b7e-42db-49c5-a00d-0dcbb92a0162)

2. copy initrd、vmlinuz
```bash
# Mount image
mount -t iso9660 -o loop ubuntu-24.04.1-live-server-amd64.iso /mnt/

# copy initrd、vmlinuz
cp /mnt/casper/initrd.gz /os/ubuntu/24.04/boot/initrd
cp /mnt/casper/vmlinuz /os/ubuntu/24.04/boot/vmlinuz
```

3. Update configuration item *menuentry* in `grub.cfg` file

* linux /os/ubuntu/24.04/boot/vmlinuz
* initrd /os/ubuntu/24.04/boot/initrd

```
menuentry 'Ubuntu 24.04 live server amd64 (cloud-init) (UEFI)' {
    # ubuntu 24.04 ds=nocloud-net modify ds=nocloud
    linux /os/ubuntu/24.04/boot/vmlinuz $vt_handoff ip=dhcp url=http://{dufs_node_ip}/os/ubuntu/24.04/x86_64/ubuntu-24.04.1-live-server-amd64.iso autoinstall ds=nocloud\;s=http://{dufs_node_ip}/os/ubuntu/24.04/cloud-init/ ---
    initrd /os/ubuntu/24.04/boot/initrd
}
```

4. cloud-init

Ubuntu uses cloud-init to define configuration options for initializing the system.

* user-data: `/os/ubuntu/24.04/cloud-init/user-data`
* vendor-data: `/os/ubuntu/24.04/cloud-init/vendor-data`
* meta-data: `/os/ubuntu/24.04/cloud-init/meta-data`


