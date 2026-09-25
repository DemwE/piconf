{
  description = "Obraz NixOS Btrfs dla Raspberry Pi 4";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixos-hardware, disko }: {
    nixosConfigurations.rpi-btrfs = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        nixos-hardware.nixosModules.raspberry-pi-4

        ({ config, pkgs, lib, ... }: {
          boot.initrd.supportedFilesystems = [ "btrfs" ];
          boot.supportedFilesystems = [ "btrfs" ];
        })

        ./configuration.nix
        ./hardware-configuration.nix
      ];
    };
  };
}
