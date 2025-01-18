{ pkgs, services-root, ... }:
let
  utils = import ../utils.nix;
  loadService = path: (import path) utils;
in
{
  imports = [
    ./secrets.nix
    ./hardware-configuration.nix

    (loadService ./services/traefik.nix)
    # (loadService ./services/monitoring.nix)
    # (loadService ./services/filebrowser.nix)
    # (loadService ./services/homarr.nix)
    (loadService ./services/website.nix)
    # (loadService ./services/headscale.nix)
    # (loadService ./services/adguardhome.nix)
    # (loadService ./services/stalwart.nix)
  ];

  config = {
    environment.systemPackages = with pkgs; [
      podman
      podman-compose
    ];

    systemd.tmpfiles.settings.services-dir = {
      "${services-root}".d = {
        user = "root";
        group = "podman";
        mode = "0750";
      };
    };

    services = {
      openssh.settings.PasswordAuthentication = false;
      qemuGuest.enable = true;
      fail2ban = {
        enable = true;
        maxretry = 30;
        bantime = "24h";
      };
    };

    networking.networkmanager.enable = false;

    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      oci-containers.backend = "podman";
    };

    users = {
      mutableUsers = false;
      users = {
        main = {
          name = "main";
          isNormalUser = true;
          description = "General user for the server";
        };

        root.hashedPassword = "!";
      };
    };
  };
}
