{ config, pkgs, ... }:

{
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };
}
