{ pkgs, ... }:

{
  systemd.services.booru = {
    description = "Docker Compose stack: booru";
    wantedBy = [ "multi-user.target" ];
    path = [
      pkgs.docker-compose
      pkgs.coreutils
    ];

    after = [
      "network-online.target"
      "docker.service"
      "raid-data.mount"
      "raid-data-db.mount"
    ];
    requires = [
      "docker.service"
      "raid-data.mount"
      "raid-data-db.mount"
    ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "kali4";
      WorkingDirectory = "/raid/data/docker/containers/booru";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose --project-name booru up --detach --remove-orphans";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose --project-name booru stop";
      TimeoutStartSec = 300;
    };
  };
}
