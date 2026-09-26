{ ... }:

{
  services.samba = {
    enable = true;
    openFirewall = true;

    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "PI-server";
        "server min protocol" = "SMB2_02";
      };

      data = {
        "path" = "/raid/data";
        "comment" = "Raid data share";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = [ "kali4" ];
        "force user" = "kali4";
        "force group" = "users";
        "create mask" = "0664";
        "directory mask" = "0775";
        "force create mode" = "0664";
        "force directory mode" = "0775";
      };

      nfs = {
        "path" = "/raid/nfs";
        "comment" = "Raid nfs share";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = [ "kali4" ];
        "force user" = "kali4";
        "force group" = "users";
        "create mask" = "0664";
        "directory mask" = "0775";
        "force create mode" = "0664";
        "force directory mode" = "0775";
      };
    };
  };

  systemd.services.samba-smbd = {
    after = [
      "raid-data.mount"
      "raid-data-db.mount"
      "raid-nfs.mount"
    ];
    wants = [
      "raid-data.mount"
      "raid-data-db.mount"
      "raid-nfs.mount"
    ];
  };
}
