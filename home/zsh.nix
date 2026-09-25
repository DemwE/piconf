{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = false;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
    };

    shellAliases = {
      # other
      cls = "clear";
    };

    history.path = "${config.xdg.stateHome}/zsh/history";
    initContent = ''
      if [[ $- == *i* ]]; then
          fastfetch
      fi'';
  };
}
