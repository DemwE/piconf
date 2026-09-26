{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  boot.initrd.availableKernelModules = [
    "btrfs"
    "usbhid"
    "usb_storage"
    "xhci_pci"
    "uas" 
  ];
  boot.initrd.kernelModules = [
    "vc4"
    "v3d"
    "bcm2835_dma"
    "i2c_bcm2835"
  ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.initrd.supportedFilesystems = [ "btrfs" ];
  boot.supportedFilesystems = [ "btrfs" ];
  boot.kernelParams = [
    "console=tty0"
    "cma=128M"
    "rootflags=degraded"
    "usb-storage.quirks=*:u"
  ];
  hardware.raspberry-pi.firmware.uboot.enable = true;
  hardware.raspberry-pi."4".fkms-3d.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
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

  # Kernel version
  boot.kernelPackages = pkgs.linuxPackages_6_12;
}
