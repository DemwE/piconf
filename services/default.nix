{ ... }:
{
  imports = [
    ./booru.nix
    ./docker.nix
    ./samba.nix
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  services.tailscale.enable = true;
}
