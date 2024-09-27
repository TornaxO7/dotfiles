{ pkgs, username, services-root, ... }:
let
  oldLoadService = path: port: (import path) port;
  utils = import ./utils.nix;
in
{
  imports = [
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

    (oldLoadService ./services/immich.nix 49260)
    (oldLoadService ./services/gotify.nix 49270)
    (oldLoadService ./services/localai.nix 49280)
    (oldLoadService ./services/gitea.nix 49290)
    (oldLoadService ./services/vikunja.nix 49300)
    (oldLoadService ./services/harmonia.nix 49310) # don't forget to update the substituter
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

