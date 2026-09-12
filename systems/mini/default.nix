{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/netcup.nix
    ./secrets

    # ./services/wireguard.nix
    # ./services/adguardhome.nix
    # ./services/traefik.nix
  ];

  config = {
    networking = {
      useDHCP = false;
      useNetworkd = true;
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
