#!/bin/bash

echo "Starting Linux Mint debloater :D"
sudo apt update

echo "Removing libreOffice"
sudo apt purge -y libreoffice* || true

echo "Removing Thunderbird & Transmission"
sudo apt purge -y thunderbird* transmission* || true

echo "Removing media and viewer apps"
sudo apt purge -y \
    celluloid \
    hypnotix \
    pix \
    drawing \
    xreader \
    sticky \
    thingy \
    webapp-manager \
    simple-scan \
    gucharmap \
    yelp || true

# Might want to remove that if you use bluetooth

echo "Removing bluetooth"
sudo systemctl stop bluetooth 2>/dev/null || true
sudo apt purge -y blueman bluez bluez-obexd || true

# Might want to remove that if you use printers

echo "Removing printing stuff"
sudo systemctl stop cups.service cups-browsed.service 2>/dev/null || true

sudo apt purge -y \
    cups \
    cups-browsed \
    cups-client \
    cups-common \
    cups-core-drivers \
    cups-daemon \
    cups-filters \
    cups-ipp-utils \
    printer-driver-* \
    system-config-printer* || true

echo "Removing snap (ew)"
sudo systemctl stop snapd.service 2>/dev/null || true
sudo apt purge -y snapd || true

sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd
rm -rf ~/snap

echo "Blocking snap from reinstalling"
echo "Package: snapd
Pin: release a=*
Pin-Priority: -10" | sudo tee /etc/apt/preferences.d/no-snap.pref

# You might want to remove this part, as rollbacks are pretty useful. However, in my case, they aren't.

echo "Removing timeshift (no rollbacks mode)"
sudo apt purge -y timeshift || true

echo "Removing firewall gui (keeping backend)"
sudo apt purge -y gufw || true

echo "Removing fingerprint support"
sudo apt purge -y fprintd libpam-fprintd || true

echo "Removing accessibility keyboard"
sudo apt purge -y onboard || true

# Ssd optimization

echo "Enabling trim timer"
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer

echo "Setting swappiness to 10"
echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/99-swappiness.conf
sudo sysctl -p /etc/sysctl.d/99-swappiness.conf

echo "Adding noatime to fstab (if not already present)"
if ! grep -q "noatime" /etc/fstab; then
    sudo sed -i 's/defaults/defaults,noatime/g' /etc/fstab
fi

echo "autoremove and clean"
sudo apt autoremove --purge -y
sudo apt autoclean -y

echo "Done! Reboot recommended"
