#!/bin/sh

read -p "Enter hostname for this system: " new_hostname
echo "networking.hostName = \"$new_hostname\";" >> configuration.nix

sudo cp ./configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch
sudo nix-collect-garbage -d
sudo nix-store --optimise


sudo cp ./wallpaper.jpeg /wallpaper.jpeg

dconf load / < ./dconf

