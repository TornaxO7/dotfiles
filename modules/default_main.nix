{ pkgs, ... }:
{
  nix.settings = {
    substituters = [ "http://nas:49310" ];
    trusted-public-keys = [ "cache.nas:nlGlXrh+kDHcfuzhyiSVkUVNKA6snAaCU77R7dXCXAY=" ];
  };

  environment.systemPackages = with pkgs; [
    tailscale
  ];

  security.sudo-rs.wheelNeedsPassword = false;
}
