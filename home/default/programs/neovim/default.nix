{ config, pkgs, ... }:
{
  config = {
    programs.neovim = {
      enable = false;
      defaultEditor = false;
      extraPackages = with pkgs; [
        gcc13
        deno
      ];
      withPython3 = true;
      vimdiffAlias = true;

    };

    xdg.configFile.neovim = {
      enable = config.programs.neovim.enable;
      recursive = true;
      source = ./config-files;
      target = "nvim";
    };
  };
}
