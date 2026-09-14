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
    ./services/crowdsec.nix
    ./services/traefik.nix
    ./services/website.nix
    ./services/gokapi.nix
    ./services/miasma.nix

    # 49192
    ./services/public-files.nix
  ];

  config = {
    services.openssh.hostKeys = [
      {
        path = "/etc/ssh/small";
        type = "ed25519";
      }
    ];

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
