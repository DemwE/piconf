{ systemVersion, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./services
    ./users
    ./packages.nix
    ./hardware.nix
    ./systemd
  ];

  # Allow unfree packages globally
  nixpkgs.config.allowUnfree = true;

  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Timezone and locale settings
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  # System version - inherited from flake.nix
  system.stateVersion = systemVersion;

  # Enable Zsh globally and set as default shell for new users
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
}
