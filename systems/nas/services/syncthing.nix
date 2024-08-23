port: { username, pkgs, zpool-name, ip-addr, ... }:
let
  utils = import ../utils.nix;

  portStr = toString port;
in
{
  config = {
    systemd = {
      tmpfiles.settings.syncthing = {
        "/var/lib/syncthing".d.user = username;
      };
    }
    //
    (utils.createSystemdZfsSnapshot pkgs "syncthing" "${zpool-name}/syncthing");

    services.syncthing = {
      enable = true;
      user = username;
      relay.enable = false;
      openDefaultPorts = true;
      guiAddress = "${ip-addr}:${portStr}";
    };
  };
}
