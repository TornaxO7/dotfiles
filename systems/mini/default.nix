{ ... }:
let
  ips = import ./ips.nix;
in
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
          "${ips.ip4}/22"
          "${ips.ip6}/64"
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
