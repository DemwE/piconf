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

r1 = {
        "path" = "/raid/r1";
        "comment" = "Raid 1";
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

      r2 = {
        "path" = "/raid/r2";
        "comment" = "Raid r2";
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
      "raid-r1.mount"
      "raid-r1-db.mount"
      "raid-r2.mount"
    ];
    wants = [
      "raid-r1.mount"
      "raid-r1-db.mount"
      "raid-r2.mount"
    ];
  };
}
