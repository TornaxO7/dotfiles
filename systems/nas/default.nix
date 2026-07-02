{ config, pkgs, services-root, ... }:
let
  utils = import ../utils.nix;

  loadService = path: (import path) utils;
in
{
  imports = [
    ../../modules/default_main.nix
    ./hardware-configuration.nix
    ./wireguard.nix
    ./home
    # ./led.nix

    ./zfs

    # == services ==
    ./services/traefik.nix
    # 49200
    ./services/immich.nix
    # 49201
    ./services/meilisearch.nix
    # 49202
    ./services/linkwarden.nix
    # 49203
    ./services/paperless.nix
    # 49204
    ./services/syncthing.nix
    # 49205
    ./services/memos.nix

    # each service here, can have a port, starting from 49200 (incrementing 10)
    ./services/jellyfin.nix
    (loadService ./services/filebrowser.nix)
    (loadService ./services/vikunja.nix)
    (loadService ./services/gotify.nix)
    ./services/timetagger.nix
  ];

  config = {

    environment.systemPackages = with pkgs; [
      podman
      podman-compose
    ];

    systemd.tmpfiles.settings.services-dir = utils.createDirs config [ services-root ];

    networking = {
      hostId = "17b02087";

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

