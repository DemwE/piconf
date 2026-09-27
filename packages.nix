{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    zsh
    fastfetch
    btop
    duf
    tree
    wget
    git
    git-lfs
    yazi
    fd
    bat
    usbutils
    pciutils
    net-tools
    ripgrep
    eza
    fzf
    nh
    neovim
    hdparm
    compsize
    cloudflared
  ];
}
