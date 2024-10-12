{ pkgs, username, services-root, ... }:
let
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
    ./services/image-updater.nix

    # docker services
    ./services/traefik.nix

    # each service here, can have a port, starting from 49200 (incrementing 10)
    ./services/adguardhome.nix
    ./services/homarr.nix
    ./services/paperless.nix
    ./services/syncthing.nix
    ./services/jellyfin.nix
    ./services/filebrowser.nix
    ./services/microbin.nix
    ./services/immich.nix
    ./services/gotify.nix
    ./services/vikunja.nix
    ./services/fusion.nix
    ./services/joplin.nix

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

