{ pkgs, ... }:

let
  pythonEnv = pkgs.python314.withPackages (ps: [
    ps.discordpy
    ps.requests
    ps.python-dotenv
    ps.playwright
  ]);
  playwrightBrowsers = pkgs.playwright-driver.browsers.override {
    withFirefox = false;
    withWebkit = false;
  };
  scriptDir = "/raid/data/discord_bots/plan-bot";
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

    restartTriggers = [
      pythonEnv
      playwrightBrowsers
    ];

    serviceConfig = {
      Type = "exec";
      User = "kali4";
      WorkingDirectory = scriptDir;
      ExecStart = "${pythonEnv}/bin/python3 ${script}";
      Environment = [
        "PLAYWRIGHT_BROWSERS_PATH=${playwrightBrowsers}"
        "PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true"
        "PYTHONUNBUFFERED=1"
      ];
      Restart = "on-failure";
      RestartSec = 30;
    };
  };
}
