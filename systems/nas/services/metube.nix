{ username, ... }:
let
  utils = import ../utils.nix;

  host-path = "/hdds/music/songs";
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
