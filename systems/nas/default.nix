{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    networking = {
      networkmanager.enable = false;
      hostName = "nas";
    };
  };
}
