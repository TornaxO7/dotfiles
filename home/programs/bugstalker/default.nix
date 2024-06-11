{ inputs, system, ... }:
{
  home.packages = [
    inputs.bs.packages.${system}.default
  ];

  xdg.configFile.bugstalker = {
    enable = true;
    recursive = true;
    source = ./bs;
    target = "bs";
  };
}
