{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./zfs
    # ./traefik.nix
    # ports which are reserveed, starting from port 8000 (incremented by 10)
    # 8000
    ./services/dashy.nix
    # 8010
    ./services/paperless.nix
    # 8020
    ./services/atomic-server.nix
    # 8030
    ./services/metube.nix
    # 8400
    # reserved for syncthing
    # 8050
    ./services/jellyfin.nix
    # 8060
    ./services/photoprism.nix

    # background services
    ./services/glances.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      podman
      podman-compose
    ];

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

