{ config, pkgs, services-root, ... }:
let
  username = config.users.users.main.name;
  loadPortService = path: port: (import path) port;
  utils = import ./utils.nix;
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
    ./services/watchtower.nix
    ./services/adguardhome.nix
    ./services/paperless.nix
    ./services/syncthing.nix
    ./services/jellyfin.nix
    ./services/filebrowser.nix
    ./services/immich.nix

    (loadPortService ./services/harmonia.nix 49310) # don't forget to update the substituter in modules/default.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      podman
      podman-compose
    ];

    systemd.tmpfiles.settings.services-dir = utils.createDirs username [ services-root ];

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

