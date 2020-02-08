#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Error:"
    echo "You must run this script as root!"
    exit 1
fi

CONFIG_DIR="/docker/pihole/"
mkdir -p $CONFIG_DIR/cloudflared_config/
mkdir -p $CONFIG_DIR/etc-pihole/
mkdir -p $CONFIG_DIR/etc-dnsmasq.d/

#If cloudflared config doesn't already exists
CLOUDFLARED_CFG="$CONFIG_DIR/cloudflared_config/config.yml"
if [ ! -f $CLOUDFLARED_CFG ]; then
    echo "proxy-dns: true"               > $CLOUDFLARED_CFG
    echo "proxy-dns-port: 5053"          >> $CLOUDFLARED_CFG
    echo "proxy-dns-address: 0.0.0.0"    >> $CLOUDFLARED_CFG
    echo "proxy-dns-upstream:"           >> $CLOUDFLARED_CFG
    echo " - https://1.1.1.1/dns-query"  >> $CLOUDFLARED_CFG
    echo " - https://1.0.0.1/dns-query"  >> $CLOUDFLARED_CFG
fi

chmod -R 775 $CONFIG_DIR/cloudflared_config
chmod -R 775 $CONFIG_DIR/etc-pihole
chmod -R 775 $CONFIG_DIR/etc-dnsmasq.d

#Set up containers
docker-compose up -d
#Clear the password of the pihole admin interface
#docker exec pihole pihole -a -p

echo " "
echo "Settings and container data can be found in $CONFIG_DIR"
