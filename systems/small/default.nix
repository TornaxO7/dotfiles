{ ... }:
let
  ips = import ./ips.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/netcup.nix

    # ./services/traefik.nix
    # ./services/website.nix
    # ./services/gokapi.nix
    # ./services/crowdsec.nix
    # ./services/public-files.nix
  ];

  config = {
    systemd.network.networks."10-main" = {
      matchConfig = {
        Name = "ens3";
      };
      networkConfig = {
        DHCP = "no";
        DHCPServer = "no";
      };
      addresses = [
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
}
