#!/bin/sh

# Exit immediately on error
set -e

echo "Checking internet connection..."
if ping -q -c 1 -W 2 8.8.8.8 >/dev/null; then
    echo "Internet connection detected."
else
    echo "No internet connection. Exiting..."
    exit 1
fi

sudo cp ./configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch
sudo nix-collect-garbage -d
sudo nix-store --optimise


sudo cp ./wallpaper.jpeg /wallpaper.jpeg

dconf load / < ./dconf
