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
    (loadService ./services/gotify.nix 49270)
    (loadService ./services/localai.nix 49280)
    (loadService ./services/gitea.nix 49290)
    (loadService ./services/vikunja.nix 49300)
    (loadService ./attic.nix 49400)
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

      # allow DNS resolver for the docker networks
      firewall.allowedUDPPorts = [ 53 ];
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

