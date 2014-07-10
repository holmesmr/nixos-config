# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
     enable = true;
     version = 2;
     device = "/dev/sda";
     extraEntries =
''
menuentry "Windows 8.1" {
    chainloader (hd0,2)+1
}
'';
  };

  # mount Steam chroots at boot
  boot.postBootCommands = "init-steam-chrootenv && mount-steam-chrootenv";

  time.timeZone = "Europe/London";
  time.hardwareClockInLocalTime = true;
  
  # Network settings.

  networking = {
     hostName = "lambda-cephei";
     
     networkmanager.enable = true;
     
     firewall = {
       enable = true;
       allowPing = false;
     };
  };

  # Select internationalisation properties.
  i18n = {
  #   consoleFont = "lat9w-16";
     consoleKeyMap = "uk";
     defaultLocale = "en_GB.UTF-8";
  };

  # List packages installed in system profile. To search by name, run:
  # -env -qaP | grep wget
  environment.systemPackages = with pkgs; [
     wget
     chromium
     git
     pavucontrol
     steamChrootEnv
     kde4.kdemultimedia
     wget
     htop
     kde4.kdenetwork
     kde4.networkmanagement
     unzip
     kde4.kde_gtk_config
     jackaudio
     qjackctl
     fakechroot
     oxygen_gtk
     kde4.kwalletmanager
  ];

  # Use Adobe Flash (ew)
  nixpkgs.config.chromium.enableAdobeFlash = true;
  nixpkgs.config.chromium.enablePepperFlash = true;

  # List services that you want to enable:

  
  services = {
    # Enable network time.
    chrony.enable = true;
    
    # Enable CUPS printing.
    printing.enable = true;

    # Enable power management.
    upower.enable = true;

    # Enable X11.
    xserver = {
      enable = true;
      layout = "gb";
      xkbOptions = "eurosign:e";

      deviceSection = ''Option "Audio" "on"'';
      
      videoDrivers = ["nvidia" "vesa"];

      xrandrHeads = ["HDMI-0" "VGA-0"];

      synaptics = {
        enable = true;
        twoFingerScroll = true;
        palmDetect = true;
      };

      # Enable and use the KDE4 Desktop environment
      displayManager.kdm.enable = true;
      desktopManager.kde4.enable = true;
    };
  };

  # Allow 32-bit applications to get GLX acceleration
  hardware.opengl.driSupport32Bit = true;
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.cepheus = {
    name = "cepheus";
    group = "users";
    extraGroups = [ "wheel" "audio" "networkmanager" ];
    uid = 1000;
    createHome = true;
    home = "/home/cepheus";
    shell = "/run/current-system/sw/bin/bash";
  };
  
  # Sound system settings.

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudio.override { jackaudioSupport = true; };
  };

  # RealTime capability for PulseAudio.
  security.rtkit.enable = true;

  # Enable better rng
  security.rngd.enable = true;
}
