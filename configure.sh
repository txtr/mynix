#!/bin/sh

sudo cp ./configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch
sudo nix-collect-garbage -d
sudo nix-store --optimise

sudo cp ./wallpaper.jpeg /wallpaper.jpeg
dconf load / < ./dconf

google-chrome-stable
firefox

echo "Close Firefox and Google Chrome. Press any key to continue..."
read -n 1 -s
echo "You pressed a key! Continuing..."

cd ~/.mozilla/firefox/*.default
sudo rm -rf ./* ./.*
git init -b main
git remote add origin "https://github.com/txtr/firefox_profile.git"
git fetch
git pull origin main

cd ~/.config/google-chrome/Default
rm -rf ./* ./.*
git init -b main
git remote add origin "https://github.com/txtr/chromium_profile.git"
git fetch
git pull origin main
