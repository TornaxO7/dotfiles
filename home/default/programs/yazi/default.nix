{ config, inputs, system, ... }:
{
  config = {
    nix.settings = {
      extra-substituters = [ "https://yazi.cachix.org" ];
      extra-trusted-public-keys = [ "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" ];
    };

    programs.yazi = {
      enable = true;
      package = inputs.yazi.packages.${system}.default;
    };

    xdg.configFile.yazi = {
      enable = config.programs.yazi.enable;
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink /home/tornax/dotfiles/config/yazi;
      target = "yazi";
    };
  };
}
