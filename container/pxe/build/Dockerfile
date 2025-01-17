FROM alpine:3.21.2

RUN set -eu && \
    apk --no-cache add tini bash dnsmasq && \
    mkdir -p /etc/default && \
    echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq && \
    mkdir -p /var/tftp && \
    mkdir -p /usr/local/dufs && \
    rm -rf /tmp/* /var/cache/apk/*

# Copy files with correct permissions
COPY dufs /usr/local/dufs/
COPY entry.sh /usr/bin/entry.sh
COPY dnsmasq.conf /etc/dnsmasq.conf

# Define environment variables
ENV DNS1="1.0.0.1" \
    DNS2="1.1.1.1"

# Expose necessary ports
EXPOSE 53/tcp 53/udp 67/udp

# Use tini for process management and specify entrypoint
ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/entry.sh"]
