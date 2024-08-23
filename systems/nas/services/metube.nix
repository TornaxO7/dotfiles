{ username, zpool-root, ... }:
let
  utils = import ../utils.nix;

  host-path = "${zpool-root}/music/songs";
in
{
  config = {
    systemd.tmpfiles.settings.metube = utils.createDirs username [ host-path ];

    virtualisation.oci-containers.containers.metube = {
      image = "ghcr.io/alexta69/metube";
      ports = [ "8030:8081" ];
      volumes = [ "${host-path}:/downloads" ];
    };
  };
}
