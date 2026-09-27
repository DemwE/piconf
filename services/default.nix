{ ... }:
{
  imports = [
    ./booru-host.nix
    ./booru.nix
    ./cloudflared.nix
    ./docker.nix
    ./gambling-bot.nix
    ./samba.nix
    ./plan-bot.nix
    ./weather.nix
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
