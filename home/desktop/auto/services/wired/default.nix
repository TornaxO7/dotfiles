{ inputs, system, ... }:
{
  config.services.wired = {
    enable = true;
    package = inputs.wired.packages.${system}.default;
    config = ./config-files/wired.ron;
  };
}
