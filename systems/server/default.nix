{ config, pkgs, services-root, ... }:
let
  utils = import ./services/utils.nix;
in
{
  imports = [
    ./hardware-configuration.nix

    ./services/traefik.nix
    ./services/ghost.nix
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
    };

    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      oci-containers.backend = "podman";
    };

    users.users.root = {
      hashedPassword = "!";
      openssh.authorizedKeys.keys = config.users.users.main.openssh.authorizedKeys.keys;
    };
  };
}
