{ wg0, ... }:
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
      "${wg0.pc.addr}" = [ wg0.pc.host ];
      "${wg0.laptop.addr}" = [ wg0.laptop.host ];
      "${wg0.nas.addr}" = [ wg0.nas.host ];
      "${wg0.server.addr}" = [ wg0.server.host ];
      "${wg0.mobile.addr}" = [ wg0.mobile.host ];

      "202.61.242.79" = [ "mini-ip4" ];
      "2a03:4000:52:316::" = [ "mini-ip6" ];

      "202.61.242.142" = [ "small-ip4" ];
      "2a03:4000:52:ebc::" = [ "small-ip6" ];

      "2.56.97.207" = [ "big-ip4" ];
      "2a03:4000:3e:26f::" = [ "big-ip6" ];
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

    home-manager.users.tornax = { ... }: {
      imports = [
        ./home-manager/packages.nix
        ./home-manager/session_paths.nix
        ./home-manager/session_variables.nix
        ./home-manager/programs
        ./home-manager/services.nix
      ];

      config = {
        nixpkgs.config.allowUnfree = true;
      };
    };
  };
}
