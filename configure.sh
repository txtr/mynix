#!/bin/sh

sudo cp ./configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch
sudo nixos-collect-garbage

sudo cp ./wallpaper.jpeg /wallpaper.jpeg
dconf load / < ./dconf

firefox
cd ~/.mozilla/firefox/*.default
sudo rm -rf ./* ./.*
git init -b main
git remote add origin "https://github.com/txtr/firefox_profile.git"
git fetch
git pull origin main

google-chrome-stable
cd ~/.config/google-chrome/Default
rm -rf ./* ./.*
git init -b main
git remote add origin "https://github.com/txtr/chromium_profile.git"
git fetch
git pull origin main
