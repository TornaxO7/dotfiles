{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./zfs
    ./traefik.nix
    ./paperless.nix
    ./atomic-server.nix
    ./metube.nix
    ./dashy.nix
    ./glances.nix
  ];

  config = {
    networking = {
      hostId = "17b02087";
      networkmanager.enable = false;
      hostName = "nas";
    };

    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      oci-containers.backend = "podman";
    };
  };
}

