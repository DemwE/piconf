{ config, pkgs, ... }:

let
  bootPartition = "/dev/sdb2";
  firmwarePartition = "/dev/sdb1";
  mountPoint = "/boot2";
  firmwareMountPoint = "/boot2/firmware";
in
{
  environment.systemPackages = [ pkgs.rsync pkgs.util-linux ];

  # 1. MOUTING BOOT AND FIRMWARE PARTITIONS
  fileSystems."${mountPoint}" = {
    device = bootPartition;
    fsType = "vfat";
    options = [ "nofail" "x-systemd.automount" "umask=0077" ];
  };

  fileSystems."${firmwareMountPoint}" = {
    device = firmwarePartition;
    fsType = "vfat";
    options = [ "nofail" "x-systemd.automount" "umask=0077" ];
  };

  # 2. SERVICE
  systemd.services.sync-boot-firmware = {
    description = "Quick synchronization of /boot -> /boot2 (FAT16/FAT32)";
    path = [ pkgs.util-linux pkgs.rsync ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";

      ExecStart = pkgs.writeShellScript "sync-boot" ''
        set -euo pipefail

        if ${pkgs.util-linux}/bin/mountpoint -q ${mountPoint} && ${pkgs.util-linux}/bin/mountpoint -q ${firmwareMountPoint}; then
          echo "Starting boot synchronization: /boot -> ${mountPoint}..."
          
          ${pkgs.rsync}/bin/rsync -rltD -vi --delete /boot/ ${mountPoint}/
          
          echo "Boot synchronization completed successfully."
        else
          echo "Warning: Mount points ${mountPoint} or ${firmwareMountPoint} are not ready. Skipping cycle."
        fi
      '';
    };
  };

  # 3. TIMER
  systemd.timers.sync-boot-firmware = {
    description = "30-second timer for boot partition synchronization";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnBootSec = "10s";
      OnUnitActiveSec = "30s";
      AccuracySec = "1s";
      Persistent = true;
    };
  };
}