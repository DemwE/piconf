{ pkgs, lib, ... }:

{
  # 1. Konsola i parametry jądra
  boot.kernelParams = [
    "console=tty0"
    "cma=128M"
  ];

  # Zezwolenie na oprogramowanie własnościowe i sterowniki
  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;

  networking.hostName = "PI-server";

  # 2. Wczytywanie modułów graficznych
  boot.initrd.availableKernelModules = [ "btrfs" "usbhid" "usb_storage" ];
  boot.initrd.kernelModules = [ 
    "vc4" 
    "v3d"
    "bcm2835_dma"
    "i2c_bcm2835"	 
  ];
  boot.initrd.supportedFilesystems = [ "btrfs" ];

  # 3. Jądro systemowe zoptymalizowane pod Raspberry Pi 4
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # 4. Konfiguracja Bootloadera U-Boot i Raspberry Pi
  #boot.loader.raspberryPi.firmwareConfig-ext = "";
  
  hardware.raspberry-pi.firmware.uboot.enable = true;
  hardware.raspberry-pi."4".fkms-3d.enable = false;

  # Włączenie generowania extlinux na partycji /boot (sda2)
  #boot.loader.generic-extlinux-linux-bootbuilder.enable = true;
  boot.loader.generic-extlinux-compatible.enable = true;

  # Nakładka KMS z opcją 'noaudio' dla czystego bootowania konsoli
  hardware.raspberry-pi.configtxt.settings = {
    all = {
      dtparam = {
        audio = "on";
      };
      dtoverlay = [
        "vc4-kms-v3d,noaudio"
      ];
    };
  };

  # Strefa czasowa i lokalizacja
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "pl_PL.UTF-8";

  # Serwer SSH
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
  };

  boot.zfs.forceImportRoot = false;

  # Użytkownik
  users.users.kali4 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "audio" "video" ];
    hashedPassword = "$6$0O1o1C8em03LaHwO$uXvJrbngRRebvdcb56uxOxFdc27L1gt5nf/9mNcv2mHMeO/rlq0c3Gnjlp5UU6M8n4VZJ.aW4T35XeW3JOvdf0";
  };

  # Pakiety systemowe
  environment.systemPackages = with pkgs; [
    btrfs-progs
    zsh
    fastfetch
    btop
    duf
    tree
    wget
    git
    git-lfs
    yazi
    fd
    bat
    usbutils
    pciutils
    net-tools
    ripgrep
    eza
    fzf
    neovim
    nh
  ];

  # Włączenie Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}
