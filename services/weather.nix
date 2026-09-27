{ pkgs, ... }:

let
  pythonEnv = pkgs.python314.withPackages (ps: [
    ps.flask
    ps.sqlite3
  ]);
  scriptDir = "/raid/data/python_things/weather_project/server_new_version";
  script = "${scriptDir}/server.py";
in
{
  systemd.services.weather-project = {
    description = "Weather project";
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
