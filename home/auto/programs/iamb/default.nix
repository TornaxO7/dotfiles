{ inputs, system, ... }:
{
  config = {
    home.packages = [ inputs.iamb.packages.${system}.default ];

    xdg.configFile.iamb = {
      recursive = true;
      source = ./config-files;
      target = "iamb";
    };
  };
}
