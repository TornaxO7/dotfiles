{ ... }:
let
  ips = import ./ips.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/netcup.nix
    ./secrets.nix

    ./services/wireguard.nix
    ./services/traefik.nix
    ./services/openhands.nix

    # 49192
    ./services/forgejo.nix
  ];

  config = {
    services.openssh.hostKeys = [
      {
        path = "/etc/ssh/big";
        type = "ed25519";
      }
    ];

    networking.nameservers = [
      # -- adguard
      "94.140.14.14"
      "94.140.15.15"
      "2a10:50c0::ad1:ff"
      "2a10:50c0::ad2:ff"

      # -- cloudflare
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"

      # -- google
      "8.8.8.8"
      "8.8.4.4"
      "2001:4860:4860::8888"
      "2001:4860:4860::8844"

      # -- quad
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"

      # -- dns.sb
      "185.222.222.222"
      "45.11.45.11"
      "2a09::"
      "2a11::"

      # --joindns4.eu
      "86.54.11.13"
      "2a13:1001::86:54:11:13"
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
