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
      "raid-r1.mount"
      "raid-r1-db.mount"
    ];
    requires = [
      "docker.service"
      "raid-r1.mount"
      "raid-r1-db.mount"
    ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "kali4";
      WorkingDirectory = "/raid/r1/docker/containers/booru";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose --project-name booru up --detach --remove-orphans";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose --project-name booru stop";
      TimeoutStartSec = 300;
    };
  };
}
