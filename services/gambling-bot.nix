{ pkgs, ... }:

let
  pythonEnv = pkgs.python314.withPackages (ps: [
    ps.discordpy
    ps.requests
    ps.python-dotenv
  ]);
  script = "/raid/data/discord_bots/gambling_bot/main.py";
in
{
  systemd.services.gambling-bot = {
    description = "Gambling bot";
    wantedBy = [ "multi-user.target" ];

    path = [
      pythonEnv
      pkgs.coreutils
    ];

    after = [
      "network-online.target"
      "raid-data.mount"
    ];
    wants = [ "network-online.target" ];
    requires = [ "raid-data.mount" ];

    restartTriggers = [ pythonEnv ];

    serviceConfig = {
      Type = "exec";
      User = "kali4";
      ExecStart = "${pythonEnv}/bin/python3 ${script}";
      Restart = "on-failure";
      RestartSec = 30;
    };
  };
}
