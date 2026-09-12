{ pkgs, ip4, ip6, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/netcup.nix
    ./secrets

    # 53
    ./services/wireguard.nix
    # 3000, 49200
    ./services/adguardhome.nix

    ./services/traefik.nix
    ./services/stalwart-docker.nix
    ./services/homer
  ];

  config = {
    networking = {
      useDHCP = false;
      useNetworkd = true;
    };

    services = {
      resolved.enable = false;
    };

    environment.systemPackages = with pkgs; [
      dnsutils
    ];

    # avoid collapse with wg0
    virtualisation.containers.containersConf.settings.network.dns_bind_port = 54;

    systemd.network = {
      enable = true;

      networks."10-main" = {
        matchConfig = {
          Name = "ens3";
        };
        networkConfig = {
          DHCP = "no";
          DHCPServer = "no";
        };
        address = [
          "${ip4}/22"
          "${ip6}/64"
        ];
        routes = [
          { Gateway = "202.61.240.1"; }
          { Gateway = "fe80::1"; }
        ];
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
}
