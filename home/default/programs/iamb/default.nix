{ inputs, pkgs, ... }:
{
  config = {
    home.packages = [ inputs.iamb.packages.${pkgs.system}.default ];

    xdg.configFile.iamb = {
      recursive = true;
      source = ./config-files;
      target = "iamb";
    };
  };
}
