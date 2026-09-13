{ wg0, tld, ... }:
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
      "${wg0.pc.addr}" = [ "pc.vpn.${tld}" ];
      "${wg0.laptop.addr}" = [ "laptop.vpn.${tld}" ];
      "${wg0.nas.addr}" = [ "nas.vpn.${tld}" ];
      "${wg0.mobile.addr}" = [ "mobile.vpn.${tld}" ];

      "${wg0.mini.addr}" = [ "mini" "mini.vpn.${tld}" ];
      "${wg0.small.addr}" = [ "small" "small.vpn.${tld}" ];
      "${wg0.big.addr}" = [ "big.vpn.${tld}" ];

      "202.61.242.79" = [ "mini4" ];
      "2a03:4000:52:316::" = [ "mini6" ];

      "202.61.242.142" = [ "small4" ];
      "2a03:4000:52:ebc::" = [ "small6" ];

      "2.56.97.207" = [ "big" "big4" ];
      "2a03:4000:3e:26f::" = [ "big6" ];
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
