{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/netcup.nix
  ];

  config = {
    systemd.network.networks.main1 = {
      matchConfig = {
        Name = "ens3";
      };
      networkConfig = {
        DHCP = "no";
        DHCPServer = "no";
      };
      addresses = [
        "202.61.242.142/22"
        "2a03:4000:52:ebc::/64"
      ];
    };
  };
}
