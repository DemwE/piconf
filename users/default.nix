{ ... }:
{
  imports = [
    ./home.nix
  ];

  users.users.root.hashedPassword = "$6$0O1o1C8em03LaHwO$uXvJrbngRRebvdcb56uxOxFdc27L1gt5nf/9mNcv2mHMeO/rlq0c3Gnjlp5UU6M8n4VZJ.aW4T35XeW3JOvdf0";

  users.users.kali4 = {
    isNormalUser = true;
    description = "Admin";
    extraGroups = [
      "networkmanager"
      "wheel"
      "storage"
      "plugdev"
      "libvirtd"
      "docker"
      "podman"
      "wireshark"
      "dialout"
      "video"
      "audio"
      "input"
      "uucp"
      "adbusers"
      "incus-admin"
    ];
    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];
    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];
    hashedPassword = "$6$0O1o1C8em03LaHwO$uXvJrbngRRebvdcb56uxOxFdc27L1gt5nf/9mNcv2mHMeO/rlq0c3Gnjlp5UU6M8n4VZJ.aW4T35XeW3JOvdf0";
  };

  nix.settings.trusted-users = [ "kali4" ];
}
