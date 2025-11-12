{ lib, config, pkgs, ... }:

{
  imports = [
    ./base.nix
  ];

  networking.hostName = "hera";
}
