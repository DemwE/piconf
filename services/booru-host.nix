{ pkgs, ... }:

{
  systemd.services.booru-host = {
    description = "Reverse SSH tunnel to srv.us for booru";
    wantedBy = [ "multi-user.target" ];
    path = [
      pkgs.openssh
      pkgs.bash
      pkgs.coreutils
    ];

    after = [
      "network-online.target"
      "raid-data.mount"
    ];
    wants = [ "network-online.target" ];
    requires = [ "raid-data.mount" ];

    serviceConfig = {
      Type = "exec";
      User = "kali4";
      ExecStart = "${pkgs.bash}/bin/bash /raid/data/scripts/booru/booruHost.sh";
    };
  };

  systemd.services.booru-host-reset = {
    description = "Restart booru-host tunnel";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl restart booru-host.service";
    };
  };

  systemd.timers.booru-host = {
    description = "Restart booru-host tunnel every full hour";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      Unit = "booru-host-reset.service";
      OnCalendar = "hourly";
      AccuracySec = "1s";
      Persistent = true;
    };
  };
}
