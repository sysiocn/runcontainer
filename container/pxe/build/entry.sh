#!/usr/bin/env bash
set -Eeuo pipefail

if [ -z "$(ls -A /var/tftp)" ]; then
    echo "/var/tftp is empty. Copying files..."
    cp -rp /usr/local/dufs/* /var/tftp/
fi

exec dnsmasq "--conf-file=/etc/dnsmasq.conf" --no-daemon --no-resolv
