{ config, pkgs, services-root, ... }:
{
  imports = [
    ./secrets.nix
    ./hardware-configuration.nix

    # ports: 80, 443
    ./services/traefik.nix
    ./services/filebrowser.nix
    ./services/website.nix
    ./services/headscale
    # ports: 53, 3000
    ./services/adguardhome.nix
    ./services/homarr.nix
    ./services/watchtower.nix

    # port: 49162
    ./services/authelia
    # port: 49163
    ./services/grafana.nix
    # ports: [49170 - 49180)
    ./services/prometheus.nix
    # ports: [49180 - 49190)
    # soon: Switch to crowdsec (in a good way)
    ./services/crowdsec-docker
    # ./services/fail2ban.nix

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
