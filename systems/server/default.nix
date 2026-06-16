{ config, pkgs, services-root, ip6, ... }:
{
  imports = [
    ./secrets.nix
    ./hardware-configuration.nix

    # ports: 80, 443
    ./services/traefik.nix
    ./services/website.nix

    ./services/github-runner/vibe-ci.nix

    # ports: 53, 3000
    ./services/adguardhome.nix
    ./services/homarr.nix
    ./services/watchtower.nix

    # port: 49162
    ./services/authelia
    # port: 49163
    ./services/grafana.nix
    # ports: [49170 - 49180)
    ./services/victoria-metrics
    # ports: [49180 - 49190)
    # soon: Switch to crowdsec (in a good way)
    ./services/crowdsec-docker

    # port: 49190
    ./services/wireguard.nix
    # port: 49191
    ./services/anubis.nix
    # port: 49192
    ./services/emojis.nix
    # port: 49193
    ./services/public-files.nix
    # port: 49194
    # other wireguard
    # port: 49195
    ./services/miasma.nix

    ./services/stalwart.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      podman-compose
      helix
      bottom
    ];

    systemd.tmpfiles.rules = [
      "d ${services-root} 0751 root ${config.users.groups.services.name} -"
    ];

    services = {
      openssh = {
        openFirewall = false;
        settings.PasswordAuthentication = false;
      };
      qemuGuest.enable = true;
    };

    networking = {
      interfaces.ens3.ipv6.addresses = [
        {
          address = ip6;
          prefixLength = 64;
        }
      ];
    };

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
        tornax = {
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwQ1FO2lkd7ecYc/3GCo2yTWgo1V86uYUpX87bzFPhU tornax@pc"
          ];
        };
      };

      groups = {
        # To access `services-root`
        services = { };
      };
    };
  };
}
