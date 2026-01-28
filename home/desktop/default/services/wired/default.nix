{ inputs, pkgs, ... }:
{
  config.services.wired = {
    enable = false;
    package = inputs.wired.packages.${pkgs.system}.default;
    config = ./config-files/wired.ron;
  };
}
