#!/bin/bash -eux

# Disable the release upgrader
echo "==> Disabling the release upgrader"
sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades

echo "==> Updating list of repositories"
aptitude -y update

echo "==> Performing upgrade"
aptitude -y safe-upgrade

echo "==> Rebooting"
reboot
sleep 60
