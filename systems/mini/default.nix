{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/netcup.nix
    ./secrets

    # 53
    ./services/wireguard.nix
    # 3000, 49200
    ./services/adguardhome.nix

    # ./services/traefik.nix
    # ./services/stalwart.nix
    # ./services/homer.nix
  ];

  config = {
    networking = {
      useDHCP = false;
      useNetworkd = true;
    };

    services = {
      resolved.enable = false;
    };

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
          "202.61.242.79/22"
          "2a03:4000:52:316::/64"
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
