{ config, pkgs, services-root, ... }:
let
  utils = import ./services/utils.nix;
in
{
  imports = [
    ./hardware-configuration.nix

    ./services/traefik.nix
    ./services/ghost.nix
    ./services/monitoring.nix
    ./services/filebrowser.nix
    ./services/vikunja.nix
    ./services/homarr.nix
    ./services/gotify.nix
    ./services/watchtower.nix
    ./services/joplin.nix
    # ./services/adguardhome.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      podman
      podman-compose
    ];

    systemd.tmpfiles.settings.services-dir = utils.createDirs config [ services-root ];

    services.openssh.settings.PasswordAuthentication = false;

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
