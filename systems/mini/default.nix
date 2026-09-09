{ config, ... }:
{
  imports = [
    ../../modules/netcup.nix
  ];

  config = {
    systemd.network.networks.main1 = {
      matchConfig = {
        Name = "todo";
      };
      networkConfig = {
        DHCP = "no";
        DHCPServer = "no";
      };
      addresses = [
        "202.61.242.79/22"
        "2a03:4000:52:316::/64"
      ];
    };
  };
}
