{ pkgs, ... }:
let
  ips = import ./ips.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/netcup.nix
    ./secrets.nix
  ];

  environment.systemPackages = with pkgs; [ podman-compose ];
  # minecraft
  networking.firewall = {
    # server
    allowedTCPPorts = [ 25565 ];

    # simple voice chat
    allowedUDPPorts = [ 24454 ];
  };

  services.openssh = {
    # openFirewall = false;
    settings.PasswordAuthentication = false;
  };

  virtualisation.containers.containersConf.settings.network.dns_bind_port = 53;

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
        { Gateway = "62.83.36.1"; }
        { Gateway = "fe80::1"; }
      ];
      linkConfig.RequiredForOnline = "routable";
    };
  };
}
