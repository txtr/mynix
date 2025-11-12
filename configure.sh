#!/bin/sh

sudo nix-channel --update

echo "Checking internet connection..."
if ping -q -c 1 -W 2 8.8.8.8 >/dev/null; then
    echo "Internet connection detected."
    sudo cp -f ./*.nix /etc/nixos
    sudo nixos-rebuild switch
    sudo nix-collect-garbage -d
    sudo nix-store --optimise
else
    echo "No internet connection. Exiting..."
    exit 1
fi

sudo cp ./wallpaper.jpeg /wallpaper.jpeg
cp ./.zshrc ~/.zshrc

while true; do
    read -p "Apply dconf settings? [Y/n] " yn
    case "$yn" in
        "" | [Yy]* ) 
            echo "Resetting dconf settings..."
            dconf reset -f /
            echo "Applying dconf settings..."
            dconf load / < ./dconf
            echo "dconf settings applied!"
            break
            ;;
        [Nn]* )
            echo "dconf load skipped."
            break
            ;;
        * ) 
            echo "Please answer Y or n";;
    esac
done
gnome-extensions list | while read -r uuid; do gnome-extensions enable "$uuid"; done
