{ ... }:
let
  ips = import ./ips.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/netcup.nix
    ./secrets.nix

    # 53
    ./services/wireguard.nix
    ./services/traefik.nix
    ./services/happier.nix

    # 49192
    ./services/forgejo.nix
  ];

  config = {
    programs.nix-ld.enable = true;

    users.users.tornax.linger = true;

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

    home-manager.users.tornax = { ... }: {
      config = {
        services.ssh-agent.enable = true;
      };
    };
  };
}
