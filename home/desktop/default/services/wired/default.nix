{ inputs, pkgs, ... }:
{
  config.services.wired = {
    enable = true;
    package = inputs.wired.packages.${pkgs.system}.default;
    config = ./config-files/wired.ron;
  };
}
