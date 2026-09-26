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
        "force group" = "users";
        "create mask" = "0007"; # pliki 0660
        "directory mask" = "2007"; # katalogi 2770 (setgid - nowe rzeczy dziedzicza grupe users)
      };

      r2 = {
        "path" = "/raid/r2";
        "comment" = "Dane r2";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = [ "kali4" ];
        "force group" = "users";
        "create mask" = "0007";
        "directory mask" = "2007";
      };
    };
  };

  # Uprawnienia na zamontowanych subvolach ustawiane sa jednorazowo recznie
  # (btrfs trzyma uid/gid/mode w inode, wiec przezywaja restarty):
  #   chown kali4:users /raid/r1 /raid/r1/db
  #   chmod 2770 /raid/r1 /raid/r1/db
  # Ponownie tylko po utworzeniu subvolu od nowa.
  #
  # UWAGA: systemd.tmpfiles z "d" nadaje sie tutaj - leci przed local-fs, wiec
  # chown trafilby w pusty mountpoint na rootfs, a po zamontowaniu btrfs go
  # zaslania wlasciwielem korzenia subvolu.

  # smbd startuje po zamontowanych udzialach
  # (nazwy unitow: "/" w mountpointie zamieniane jest na "-")
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
