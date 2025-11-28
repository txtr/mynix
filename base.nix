# Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:

{
  
  imports = [
    # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
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
  # BOOTLOADER
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

  #------------------------------------------------------------------------------------------------------------------------
  # NETWORKING
  #------------------------------------------------------------------------------------------------------------------------

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
  # FONTS
  #------------------------------------------------------------------------------------------------------------------------
  fonts.enableDefaultPackages = true;


  #------------------------------------------------------------------------------------------------------------------------
  # AUTO UPGRADE
  #------------------------------------------------------------------------------------------------------------------------
  system.autoUpgrade = {
    enable = false;
    channel = "https://channels.nixos.org/nixos-25.05";
    allowReboot = true;
  };

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
      # Add user-level packages
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

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.terminal-exec.enable = true;
  
  #------------------------------------------------------------------------------------------------------------------------
  # GNOME
  #------------------------------------------------------------------------------------------------------------------------

  services.xserver.displayManager.gdm.enable = true; # GNU Desktop Manager
  services.xserver.desktopManager.gnome.enable = true; # Gnome Desktop Environment

  services.gnome.core-apps.enable = false; # Gnome Core Apps
  services.gnome.games.enable = false; # Gnome Game Apps
  services.gnome.core-developer-tools.enable = false; # Gnome Developer Apps
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

  #------------------------------------------------------------------------------------------------------------------------
  # PACKAGES
  #------------------------------------------------------------------------------------------------------------------------

  environment.systemPackages = with pkgs; [
    gnome-console
    curl
    wget
    aria2
    git
    rclone
    ffmpeg-full
    python3Full
    nautilus
    gnome-disk-utility
    vlc
    pavucontrol
    (chromium.override { enableWideVine = true; })
    vscode
    gnomeExtensions.tiling-shell
    gnomeExtensions.just-perfection
  ];

  services.xserver.excludePackages = [ pkgs.xterm ]; # XTerm Console Application
  
  documentation.nixos.enable = false; # Gnome's NixOS Manual Application
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "docker"
        "git"
        "history"
        "man"
        "pip"
        "python"
        "systemadmin"
        "sudo"
      ];
      theme = "robbyrussell";
    };
  };

  #------------------------------------------------------------------------------------------------------------------------
  # CHROMIUM
  #------------------------------------------------------------------------------------------------------------------------
  programs.chromium = {
    enable = true;
    homepageLocation = "chrome://apps";
    extensions = [
      "ddkjiahejlhfcafbddmgiahcphecmpfh;https://clients2.google.com/service/update2/crx" # ublock origin lite
      "ghgabhipcejejjmhhchfonmamedcbeod;https://clients2.google.com/service/update2/crx" # click & clean
      "nngceckbapebfimnlniiiahkandclblb;https://clients2.google.com/service/update2/crx" # bitwarden
      "idgadaccgipmpannjkmfddolnnhmeklj;https://clients2.google.com/service/update2/crx" # text blaze
      "chphlpgkkbolifaimnlloiipkdnihall;https://clients2.google.com/service/update2/crx" # onetab
    ];
    extraOpts = {
        "BrowserSignin" = 0;
        "SyncDisabled" = true;
        "PasswordManagerEnabled" = false;
        "SpellcheckEnabled" = false;
        "SpellcheckLanguage" = [ "en-US" ];
        "WebAppInstallForceList" = [
        {
          "custom_name" = "Gmail";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://mail.google.com/mail";
        }
        {
          "custom_name" = "Whatsapp";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://web.whatsapp.com/";
        }
        {
          "custom_name" = "LinkedIn";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://www.linkedin.com/jobs/search/?f_EA=true&f_TPR=r86400&f_WT=1%2C3&geoId=90000031&keywords=%20Software%20Engineer&origin=JOB_SEARCH_PAGE_JOB_FILTER&refresh=true&sortBy=DD&spellCorrectionEnabled=true";
        }
        {
          "custom_name" = "Youtube Music";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://music.youtube.com/moods_and_genres";
        }
        {
          "custom_name" = "Ente Auth";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://auth.ente.io/";
        }
        ################################################################################
        ####    LLMs    ################################################################
        ################################################################################
        {
          "custom_name" = "Gemini";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://gemini.google.com/app";
        }
        {
          "custom_name" = "Copilot";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://copilot.microsoft.com/";
        }
        {
          "custom_name" = "Qwen";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://chat.qwen.ai/";
        }
        {
          "custom_name" = "Z.ai";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://chat.z.ai/";
        }
        {
          "custom_name" = "Grok";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://grok.com/";
        }
        {
          "custom_name" = "ChatGPT";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://chatgpt.com/";
        }
        {
          "custom_name" = "Mistral";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://chat.mistral.ai/";
        }
        {
          "custom_name" = "Meta AI";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://www.meta.ai/";
        }
        {
          "custom_name" = "Apertus";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://publicai.co/chat/";
        }
        {
          "custom_name" = "Granite";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://www.ibm.com/granite/playground";
        }
        {
          "custom_name" = "Ernie";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://ernie.baidu.com/";
        }
        {
          "custom_name" = "Solar";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://console.upstage.ai/playground/chat";
        }
        {
          "custom_name" = "Reka";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://app.reka.ai/";
        }
        {
          "custom_name" = "Perplexity";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://www.perplexity.ai/";
        }
        {
          "custom_name" = "LongCat";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://longcat.chat/";
        }
        {
          "custom_name" = "Duck.ai";
          "create_desktop_shortcut" = true;
          "default_launch_container" = "window";
          "url" = "https://duck.ai/";
        }
      ];
    };
  };

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
