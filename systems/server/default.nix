{ config, pkgs, services-root, ... }:
let
  utils = import ../utils.nix;
  loadService = path: (import path) utils;
in
{
  imports = [
    ./secrets.nix
    ./hardware-configuration.nix

    ./services/traefik.nix
    (loadService ./services/ghost.nix)
    (loadService ./services/monitoring.nix)
    (loadService ./services/filebrowser.nix)
    (loadService ./services/homarr.nix)
    (loadService ./services/watchtower.nix)
    (loadService ./services/website.nix)
    (loadService ./services/headscale.nix)
    (loadService ./services/adguardhome.nix)
  ];

  config = {
    environment.systemPackages = with pkgs; [
      podman
      podman-compose
    ];

    systemd.tmpfiles.settings.services-dir = utils.createDirs config [ services-root ];

    services = {
      openssh.settings.PasswordAuthentication = false;
      qemuGuest.enable = true;
    };

    networking = {
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

    users.users.root.hashedPassword = "!";
  };
}
