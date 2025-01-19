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

    nix.settings.trusted-users = [ username ];

    security = {
      sudo.enable = false;
      sudo-rs = {
        enable = true;
        wheelNeedsPassword = false;
      };
    };

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
