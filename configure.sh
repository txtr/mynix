#!/bin/sh

sudo nix-channel --update

echo "Checking internet connection..."
if ping -q -c 1 -W 2 8.8.8.8 >/dev/null; then
    echo "Internet connection detected."
    sudo cp ./configuration.nix /etc/nixos/configuration.nix
    sudo nixos-rebuild switch
    sudo nix-collect-garbage -d
    sudo nix-store --optimise
else
    echo "No internet connection. Exiting..."
    exit 1
fi

sudo cp ./wallpaper.jpeg /wallpaper.jpeg

dconf load / < ./dconf
cp ./.zshrc ~/.zshrc
