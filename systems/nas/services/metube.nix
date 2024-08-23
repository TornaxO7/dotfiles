port: { username, zpool-root, ... }:
let
  utils = import ../utils.nix;

  portStr = toString port;

in
{
  config = {
    systemd.tmpfiles.settings.metube = utils.createDirs username [ host-path ];

    virtualisation.oci-containers.containers.metube = { };
  };
}
