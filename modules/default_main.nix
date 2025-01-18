username:
{ ssh-keys, ... }:
{
  imports = [
    ../secrets
    ../secrets/modules/gtt.nix
  ];

  config = {
    # nix.settings = {
    #   substituters = [ "http://nas:49310" ];
    #   trusted-public-keys = [ "cache.nas:nlGlXrh+kDHcfuzhyiSVkUVNKA6snAaCU77R7dXCXAY=" ];
    #   connect-timeout = 3;
    # };

    security.sudo-rs = {
      enable = false;
      wheelNeedsPassword = false;
    };

    nix.settings.trusted-users = [ username ];

    users = {
      groups = {
        plugdev = { };
      };

      users.main = {
        name = username;
        isNormalUser = true;
        description = username;
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
