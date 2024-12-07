{ config, pkgs, services-root, ... }:
let
  utils = import ../utils.nix;

  loadService = path: (import path) utils;
in
{
  imports = [
    ../../modules/default_main.nix
    ./hardware-configuration.nix

    ./zfs

    # == services ==
    ./services

    # docker services
    ./services/traefik.nix

    # each service here, can have a port, starting from 49200 (incrementing 10)
    (loadService ./services/watchtower.nix)
    (loadService ./services/immich-new.nix)
    (loadService ./services/adguardhome.nix)
    (loadService ./services/paperless.nix)
    (loadService ./services/syncthing.nix)
    (loadService ./services/jellyfin.nix)
    (loadService ./services/filebrowser.nix)
    (loadService ./services/vikunja.nix)
    (loadService ./services/gotify.nix)
    (loadService ./services/joplin.nix)

    # (loadPortService ./services/harmonia.nix 49310) # don't forget to update the substituter in modules/default_main.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      podman
      podman-compose
    ];

    systemd.tmpfiles.settings.services-dir = utils.createDirs config [ services-root ];

    networking = {
      hostId = "17b02087";
      networkmanager.enable = false;

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

