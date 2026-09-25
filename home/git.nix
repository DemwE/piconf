{ config, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      submodule.recurse = true;
    };
  };
}
