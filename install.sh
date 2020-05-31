#!/bin/bash
set -e

CONFIG_DIR="/docker/cloudflared-hole/"


if [ "$EUID" -ne 0 ]; then
    echo "Error:"
    echo "You must run this script as root!"
    exit 1
fi

echo " ##################################################"
echo "#                                                  #"
echo "#             Cloudflared-hole setup               #"
echo "#   This simple script installs and configures     #"
echo "#   PiHole and cloudflared inside docker environ-  #"
echo "#   ment to achieve network-wide AD blocking and   #"
echo "#   DNS-over-HTTPS with Raspberry PI.              #"
echo "#                                                  #"
echo " ##################################################"
echo ""
echo "#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#"
echo "#  Please make sure docker and docker-compose are  #"
echo "#  properly installed before you run the script!   #"
echo "#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#"
read -p "Do you want to continue? [Y/N] " ANSWER
ANSWER="${ANSWER,,}" # Convert answer to lowercase
echo ""

if [[ $ANSWER != "y" && $ANSWER != "yes" ]]; then
    echo "Exiting..."
    exit 1
fi

mkdir -p $CONFIG_DIR/cloudflared/ $CONFIG_DIR/pihole/etc-pihole/ $CONFIG_DIR/pihole/etc-dnsmasq.d/

#If cloudflared config doesn't already exists
CLOUDFLARED_CFG="$CONFIG_DIR/cloudflared/config.yml"
if [ ! -f $CLOUDFLARED_CFG ]; then
    echo "proxy-dns: true"               > $CLOUDFLARED_CFG
    echo "proxy-dns-port: 5053"          >> $CLOUDFLARED_CFG
    echo "proxy-dns-address: 0.0.0.0"    >> $CLOUDFLARED_CFG
    echo "proxy-dns-upstream:"           >> $CLOUDFLARED_CFG
    echo " - https://1.1.1.1/dns-query"  >> $CLOUDFLARED_CFG
    echo " - https://1.0.0.1/dns-query"  >> $CLOUDFLARED_CFG
fi

chmod -R 775 $CONFIG_DIR

#Set up containers
chmod +x ./rebuild.sh
./rebuild.sh
#Clear the password of the pihole admin interface
#docker exec pihole pihole -a -p

echo " "
echo "Settings can be found in $CONFIG_DIR"
