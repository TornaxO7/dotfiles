{ ... }:
let
  ips = import ./ips.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/netcup.nix
    ./secrets.nix
  ];

  config = {
    services.openssh.hostKeys = [
      {
        path = "/etc/ssh/big";
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
          { Gateway = "2.56.96.1"; }
          { Gateway = "fe80::1"; }
        ];
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
}
