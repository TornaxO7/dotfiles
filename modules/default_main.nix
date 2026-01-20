{ ssh-keys, wg, ... }:
{
  imports = [
    ../secrets
    ../secrets/modules/gtt.nix
  ];

  config = {
    security.sudo-rs = {
      enable = true;
      wheelNeedsPassword = false;
    };

    # to use the substituters
    nix.settings.trusted-users = [ "@wheel" ];

    networking.hosts = {
      "${wg.pc.addr}" = [ "pc.vpn.${wg.domain}" ];
      "${wg.laptop.addr}" = [ "laptop.vpn.${wg.domain}" ];
      "${wg.nas.addr}" = [ "nas.vpn.${wg.domain}" ];
      "${wg.server.addr}" = [ "server.vpn.${wg.domain}" ];
      "${wg.mobile.addr}" = [ "mobile.vpn.${wg.domain}" ];
    };

    users = {
      groups = {
        plugdev = { };
      };

      users.main = {
        name = "tornax";
        isNormalUser = true;
        extraGroups = [
          "audio"
          "lp"
          "netdev"
          "networkmanager"
          "paperless"
          "plugdev"
          "video"
          "wheel"
          "docker"
        ];
        openssh.authorizedKeys.keys = ssh-keys;
      };
    };
  };
}
