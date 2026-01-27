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
      "${wg.pc.addr}" = [ wg.pc.host ];
      "${wg.laptop.addr}" = [ wg.laptop.host ];
      "${wg.nas.addr}" = [ wg.nas.host ];
      "${wg.server.addr}" = [ wg.server.host ];
      "${wg.mobile.addr}" = [ wg.mobile.host ];
    };

    users = {
      groups = {
        plugdev = { };
      };

      users.tornax = {
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
      };
    };
  };
}
