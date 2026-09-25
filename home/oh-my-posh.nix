{ config, pkgs, ... }:
{
  programs.oh-my-posh = {
    enable = true;
    useTheme = "amro";
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}
