{ ip4, ip6, ... }:
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
}
