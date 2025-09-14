# Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:

{
  
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];


  #------------------------------------------------------------------------------------------------------------------------
  # NIXOS DEFAULTS 
  #------------------------------------------------------------------------------------------------------------------------
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?


  

  #------------------------------------------------------------------------------------------------------------------------
  # Bootloader
  #------------------------------------------------------------------------------------------------------------------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  #------------------------------------------------------------------------------------------------------------------------
  # SOUND
  #------------------------------------------------------------------------------------------------------------------------
  services.pulseaudio.enable = false; # PulseAudio sound server

  services.pipewire.enable = true; # PipeWire service
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;
  services.pipewire.jack.enable = false;

  ## RealtimeKit system service, which hands out realtime scheduling priority to user processes on demand. For example,
  ## PulseAudio and PipeWire use this to acquire realtime priority.
  security.rtkit.enable = true; 
  
  #------------------------------------------------------------------------------------------------------------------------
  # VIDEO
  #------------------------------------------------------------------------------------------------------------------------
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  
  hardware.graphics.extraPackages =  with pkgs; [
    rocmPackages.clr.icd # OpenCL
    pkgs.amdvlk # Vulkan
  ];
  hardware.graphics.extraPackages32 = [ pkgs.driversi686Linux.amdvlk ]; # Vulkan support for 32-bit applications

  environment.variables.ROC_ENABLE_PRE_VEGA = "1"; # Reenable OpenCL on Polaris-based cards above ROCm 4.5
  environment.variables.AMD_VULKAN_ICD = "RADV"; # Force RADV

  services.xserver.videoDrivers = [
    # Free AMD Video Drivers
    "amdgpu"

    # # Propreitary AMD Video Drivers
    # "amdgpu-pro"
  ];

  #------------------------------------------------------------------------------------------------------------------------
  # NETWORKING
  #------------------------------------------------------------------------------------------------------------------------
  networking.hostName = "zeus";

  networking.enableIPv6 = false; # IPv6

  
  networking.networkmanager.enable = true; # NetworkManager
  networking.networkmanager.wifi.backend = "wpa_supplicant";

  #------------------------------------------------------------------------------------------------------------------------
  # WIFI
  #------------------------------------------------------------------------------------------------------------------------
  networking.wireless.enable = false;  # wpa_supplicant

  networking.wireless.networks."Incognito".psk = "perfectfruit114"; # SSID and PSK

  #------------------------------------------------------------------------------------------------------------------------
  # BLUETOOTH
  #------------------------------------------------------------------------------------------------------------------------
  hardware.bluetooth.enable = true;
  systemd.services.bluetooth.enable = lib.mkForce false;
  
  #------------------------------------------------------------------------------------------------------------------------
  # MISC. HARDWARE
  #------------------------------------------------------------------------------------------------------------------------
  services.printing.enable = false; # Printing via CUPS
  services.libinput.enable = false; # Touchpad via Synaptic

  #------------------------------------------------------------------------------------------------------------------------
  # LOCALE
  #------------------------------------------------------------------------------------------------------------------------
  time.timeZone = "America/Chicago"; # Time zone
  i18n.defaultLocale = "en_US.UTF-8"; # Internationalisation

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };


  #------------------------------------------------------------------------------------------------------------------------
  # AUTO UPGRADE
  #------------------------------------------------------------------------------------------------------------------------
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-25.05";
  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;

  #------------------------------------------------------------------------------------------------------------------------
  # USERS
  #------------------------------------------------------------------------------------------------------------------------
  users.users.txtr = {
    isNormalUser = true;
    home = "/home/txtr";
    description = "txtr";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    packages = with pkgs; [
    ];

    openssh.authorizedKeys.keys = [
    ];

    shell = pkgs.zsh;
  };

  


  #------------------------------------------------------------------------------------------------------------------------
  # X11
  #------------------------------------------------------------------------------------------------------------------------
  services.xserver.enable = true; # X11 windowing system

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


  #------------------------------------------------------------------------------------------------------------------------
  # GNOME
  #------------------------------------------------------------------------------------------------------------------------
  services.xserver.displayManager.gdm.enable = true; # GNU Desktop Manager
  services.xserver.desktopManager.gnome.enable = true; # Gnome Desktop Environment
  services.gnome.core-apps.enable = false; # Gnome Core Apps
  services.gnome.games.enable = false; # Gnome Game Apps
  services.gnome.localsearch.enable = false; # Indexing via localsearch
  services.gnome.tinysparql.enable = false; # Indexing via tinysparql
  
  environment.gnome.excludePackages = with pkgs; [ gnome-tour ];
  #------------------------------------------------------------------------------------------------------------------------
  # APPLICATION MANAGEMENT
  #------------------------------------------------------------------------------------------------------------------------
  nixpkgs.config.allowUnfree = true; # UNFREE packages
  
  programs.appimage.enable = true; # Appimage
  programs.appimage.binfmt = true;

  services.flatpak.enable = true; # Flatpak
  

  

  #------------------------------------------------------------------------------------------------------------------------
  # SSH
  #------------------------------------------------------------------------------------------------------------------------
  services.openssh.enable = true; # OpenSSH
  services.openssh.settings.PasswordAuthentication = true; # Allow password authentication

  #------------------------------------------------------------------------------------------------------------------------
  # FIREWALL
  #------------------------------------------------------------------------------------------------------------------------
  networking.firewall.enable = false; # Firewall

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  #------------------------------------------------------------------------------------------------------------------------
  # PACKAGES
  #------------------------------------------------------------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    zsh-powerlevel10k
    meslo-lgs-nf
    gnome-console
    nautilus
    sushi
    nano
    btop
    curl
    wget
    aria2
    git
    rclone
    vlc
    # google-chrome
    # alacritty
  ];

  programs.firefox.enable = true; # Firefox

  services.xserver.excludePackages = [ pkgs.xterm ]; # XTerm Console Application
  
  documentation.nixos.enable = false; # Gnome's NixOS Manual Application

  environment.etc."powerlevel10k/p10k.zsh".source = ./p10k.zsh;
  environment.shellAliases = {
    nshell = "nix-shell --run $SHELL"
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 10000;
    promptInit = ''
      # this act as your ~/.zshrc but for all users (/etc/zshrc)
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source /etc/powerlevel10k/p10k.zsh

      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      # double single quotes ('') to escape the dollar char
      if [[ -r "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # uncomment if you want to customize your LS_COLORS
      # https://manpages.ubuntu.com/manpages/plucky/en/man5/dir_colors.5.html
      #LS_COLORS='...'
      #export LS_COLORS
    '';
    ohMyZsh = {
      enable = true;
      plugins = [
        "sudo"
        "systemadmin"
        "vi-mode"
        "git"
        "python"
        "man"
      ];
      theme = "powerlevel10k/powerlevel10k";
      customPkgs = [ pkgs.nix-zsh-completions ];
    };
  };
  users.defaultUserShell = pkgs.zsh;
  system.userActivationScripts.zshrc = "touch .zshrc"; # to avoid being prompted to generate the config for first time
  environment.shells = pkgs.zsh; # https://wiki.nixos.org/wiki/Zsh#GDM_does_not_show_user_when_zsh_is_the_default_shell
  environment.loginShellInit = ''
    # equivalent to .profile
    # https://search.nixos.org/options?show=environment.loginShellInit
  '';

  #------------------------------------------------------------------------------------------------------------------------
  # HELPERS
  #------------------------------------------------------------------------------------------------------------------------
  environment.etc."current-system-packages".text =
    let
      packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
      sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
      formatted = builtins.concatStringsSep "\n" sortedUnique;
    in
      formatted;
}
