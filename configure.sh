#!/bin/sh

# --------------------------------------------------------------------------------------------
# CHECK PREREQUISITES
# --------------------------------------------------------------------------------------------

# Check if the current directory is a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "Error: Not a Git repository."
  exit 1
fi

# Get the remote URL for 'origin'
REMOTE_URL=$(git remote get-url origin)

# Check if the remote URL matches the desired URL
if [ "$REMOTE_URL" == "git@github.com:txtr/mynix.git" ]; then
  echo "Success: The current directory is a Git repository with the correct upstream origin."
else
  echo "Error: The upstream origin URL is incorrect."
  echo "Expected: $REMOTE_URL"
  echo "Found: $REMOTE_URL"
  exit 1
fi

# --------------------------------------------------------------------------------------------
# MOVE FILES
# --------------------------------------------------------------------------------------------

sudo cp ./configuration.nix /etc/nixos/configuration.nix
sudo cp ./wallpaper.jpeg /wallpaper.jpeg
dconf load / < ./dconf
sudo nixos-rebuild switch
sudo nixos-collect-garbage

cd ~/.mozilla/firefox/*.default
sudo rm -rf ./*
sudo rm -rf ./.*
git init -b main
git remote add origin "https://github.com/txtr/firefox_profile.git"
git fetch
git pull origin main

cd ~/.config/google-chrome/Default
rm -rf ./*
rm -rf ./.*
git init -b main
git remote add origin "https://github.com/txtr/chromium_profile.git"
git fetch
git pull origin main

