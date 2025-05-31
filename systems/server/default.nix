{ config, pkgs, services-root, ... }:
let
  loadPortService = path: port: (import path) port;
in
{
  imports = [
    ./secrets.nix
    ./hardware-configuration.nix

    ./services/traefik.nix
    ./services/filebrowser.nix
    ./services/website.nix
    ./services/headscale
    ./services/adguardhome.nix
    ./services/homarr.nix
    ./services/crowdsec.nix
    ./services/watchtower.nix

    (loadPortService ./services/authelia 49162)
    (loadPortService ./services/grafana.nix 49163)
    # ports: `[49170 - 49180)`
    ./services/prometheus.nix
    # (loadService ./services/stalwart.nix)
  ];

  config = {
    environment.systemPackages = with pkgs; [
      podman
      podman-compose
      helix
      bottom
    ];

    systemd.tmpfiles.rules = [
      "d ${services-root} 0751 root ${config.users.groups.services.name} -"
    ];

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

      groups = {
        # To access `services-root`
        services = { };
      };
    };
  };
}
