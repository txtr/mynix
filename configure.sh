#!/bin/bash

# Exit immediately on error
set -e

# Function to check internet connection
check_internet() {
    echo "Checking internet connection..."
    if ping -q -c 1 -W 2 8.8.8.8 >/dev/null; then
        echo "✅ Internet connection detected."
    else
        echo "❌ No internet connection. Exiting..."
        exit 1
    fi
}

# Function to set the system hostname
set_hostname() {
    read -p "Enter hostname for this system: " new_hostname
    echo "Setting hostname to '$new_hostname'..."
    sudo hostnamectl set-hostname "$new_hostname"
    echo "networking.hostName = \"$new_hostname\";" >> configuration.nix
}

# Function to apply NixOS config and clean up
apply_nixos_config() {
    echo "Copying configuration.nix..."
    sudo cp ./configuration.nix /etc/nixos/configuration.nix

    echo "Rebuilding NixOS configuration..."
    sudo nixos-rebuild switch

    echo "Cleaning up unused packages..."
    sudo nix-collect-garbage -d
    sudo nix-store --optimise
}

# Function to set wallpaper and apply dconf settings
apply_user_customizations() {
    echo "Setting wallpaper..."
    sudo cp ./wallpaper.jpeg /wallpaper.jpeg

    echo "Applying dconf settings..."
    dconf load / < ./dconf
}

### MAIN SCRIPT STARTS HERE ###

check_internet
set_hostname
apply_nixos_c
