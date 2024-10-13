{ pkgs, ... }:
{
  imports = [
    ../secrets
  ];

  config = {
    nix.settings = {
      substituters = [ "http://nas:49310" ];
      trusted-public-keys = [ "cache.nas:nlGlXrh+kDHcfuzhyiSVkUVNKA6snAaCU77R7dXCXAY=" ];
      connect-timeout = 3;
    };

    environment.systemPackages = with pkgs; [
      tailscale
    ];

    services = {
      tailscale.enable = true;
    };

    security.sudo-rs.wheelNeedsPassword = false;
  };
}
