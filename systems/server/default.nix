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
    (loadService ./services/whoami.nix)
    # (loadService ./services/monitoring.nix)
    # (loadService ./services/filebrowser.nix)
    (loadService ./services/website.nix)
    (loadService ./services/headscale)
    (loadService ./services/adguardhome.nix)
    (loadService ./services/homarr.nix)
    # (loadService ./services/stalwart.nix)
    (loadService ./services/crowdsec.nix)
  ];

  config = {
    environment.systemPackages = with pkgs; [
      podman
      podman-compose
      helix
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

    security.sudo-rs.enable = true;

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
