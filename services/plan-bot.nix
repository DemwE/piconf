{ pkgs, ... }:

let
  pythonEnv = pkgs.python314.withPackages (ps: [
    ps.discordpy
    ps.requests
    ps.python-dotenv
  ]);
  scriptDir = "/raid/data/discord_bots/plan_bot";
  script = "${scriptDir}/main.py";
in
{
  systemd.services.plan-bot = {
    description = "Plan updater bot";
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
      WorkingDirectory = scriptDir;
      ExecStart = "${pythonEnv}/bin/python3 ${script}";
      Environment = "PYTHONUNBUFFERED=1";
      Restart = "on-failure";
      RestartSec = 30;
    };
  };
}
