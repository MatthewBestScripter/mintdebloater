#!/bin/bash

echo "Starting Linux Mint debloat, but stronger !"

sudo apt update

echo "Limiting journald disk usage"

sudo mkdir -p /etc/systemd/journald.conf.d

echo "[Journal]
SystemMaxUse=50M
SystemKeepFree=100M
MaxRetentionSec=2week
Compress=yes" | sudo tee /etc/systemd/journald.conf.d/size-limit.conf

sudo systemctl restart systemd-journald

# Disabling unnecessary systemd services, remove services which you want to keep.

echo "Disabling non-essential services"

sudo systemctl disable cups.service 2>/dev/null || true
sudo systemctl disable cups-browsed.service 2>/dev/null || true
sudo systemctl disable bluetooth.service 2>/dev/null || true
sudo systemctl disable ModemManager.service 2>/dev/null || true
sudo systemctl disable avahi-daemon.service 2>/dev/null || true
sudo systemctl disable whoopsie.service 2>/dev/null || true

# If you never use laptop power profiles:
sudo systemctl disable power-profiles-daemon.service 2>/dev/null || true

# cleanup

sudo apt autoremove --purge -y
sudo apt autoclean -y
echo "Complete! Reboot recommended."
