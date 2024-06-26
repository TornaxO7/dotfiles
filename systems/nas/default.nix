{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./zfs
  ];

  config = {
    networking = {
      hostId = "17b02087";
      networkmanager.enable = false;
      hostName = "nas";
    };
  };
}

