{
  description = "NixOS configuration for Raspberry Pi 4B";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixos-hardware,
    }:
    let
      system = "aarch64-linux";
      systemVersion = "26.05";

      # Dynamic overlay: exposes nixpkgs-unstable as pkgs.unstable
      nixosModule =
        { ... }:
        {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                inherit system;
                config.allowUnfree = true;
              };
            })
          ];
        };
    in
    {
      # Host: PI-server (Raspberry Pi 4B, headless server)
      nixosConfigurations.PI-server = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit systemVersion;
        };
        modules = [
          nixosModule
          nixos-hardware.nixosModules.raspberry-pi-4
          ./configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };

      devShells.${system}.default =
        let
          pkgs' = nixpkgs.legacyPackages.${system};
        in
        pkgs'.mkShell {
          buildInputs = [ pkgs'.nixfmt ];
        };
    };
}
