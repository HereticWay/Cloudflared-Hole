#!/bin/bash

CONFIG_DIR="/docker/cloudflared-hole/"

if [[ $EUID != 0 ]]; then
    echo "Please run this script as root!"
    exit 1
fi

echo "You are going to remove Cloudflared-hole."
read -p "Do you really want to proceed? [Y/N] " ANSWER
ANSWER=${ANSWER,,} # Convert to lowercase

if [[ $ANSWER != "y" && $ANSWER != "yes" ]]; then
    echo "Exiting..."
    exit 1
fi

docker-compose rm --stop -f
rm -rf $CONFIG_DIR
echo ""
echo "Cloudflared-hole removed from your system."
