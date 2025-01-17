# Simple, customized PXE

> Support BIOS and UEFI methods at the same time; Secure boot is not supported temporarily！

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

# Deploy the operating system
BIOS
![iShot_2025-01-16_17 30 53](https://github.com/user-attachments/assets/ad8a1a43-8f4a-4400-95f8-ba910451a494)

UEFI
![iShot_2025-01-16_17 30 38](https://github.com/user-attachments/assets/1221626f-8330-4156-9f44-82dedaee5ffb)
