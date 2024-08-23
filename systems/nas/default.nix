{ pkgs, ... }:
let
  loadService = path: port: (import path) port;
in
{
  imports = [
    ./hardware-configuration.nix

    ./zfs

    # == services ==
    # starting from 49200
    (loadService ./services/dashy.nix 49200)
    (loadService ./services/paperless.nix 49210)
    (loadService ./services/syncthing.nix 49220)
    (loadService ./services/jellyfin.nix 49230)
    (loadService ./services/filebrowser.nix 49240)
    (loadService ./services/microbin.nix 49250)
    (loadService ./services/immich.nix 49260)
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

