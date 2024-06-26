{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./zfs
    ./traefik.nix
    ./paperless.nix
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

