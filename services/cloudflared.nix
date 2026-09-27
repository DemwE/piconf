{ pkgs, ... }:

let
  tokenFile = "/raid/data/python_things/weather_project/cf_token";
  startScript = pkgs.writeShellScript "cloudflared-start" ''
    export TUNNEL_TOKEN="$(cat "$CREDENTIALS_DIRECTORY/tunnel-token")"
    exec ${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run
  '';
in
{
  systemd.services.weather-tunnel = {
    description = "Weather Tunnel";
    wantedBy = [ "multi-user.target" ];

    after = [
      "network-online.target"
      "weather-project.service"
    ];
    wants = [
      "network-online.target"
      "weather-project.service"
    ];

    path = [ pkgs.cloudflared ];

    serviceConfig = {
      Type = "exec";
      User = "kali4";
      LoadCredential = "tunnel-token:${tokenFile}";
      ExecStart = "${startScript}";
      Restart = "on-failure";
      RestartSec = 30;
    };
  };
}
