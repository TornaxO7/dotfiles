{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bottom
    dnsutils
    helix
    systemctl-tui
  ];

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    # avoid collapse with wg0
    containers.containersConf.settings.network.dns_bind_port = 54;

    oci-containers.backend = "podman";
  };

  networking = {
    useDHCP = false;
    useNetworkd = true;
  };

  services = {
    qemuGuest.enable = true;
    resolved.enable = false;
  };

  users = {
    mutableUsers = false;
    users = {
      tornax = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwQ1FO2lkd7ecYc/3GCo2yTWgo1V86uYUpX87bzFPhU tornax@pc"
        ];
      };
    };
  };
}
