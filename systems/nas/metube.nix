{ username, ... }:
let
  host-path = "/hdds/music/songs";
in
{
  config = {
    systemd.tmpfiles.settings.metube.${host-path}.d.user = username;

    virtualisation.oci-containers.containers.metube = {
      image = "ghcr.io/alexta69/metube";
      ports = [ "8200:8081" ];
      volumes = [ "${host-path}:/downloads" ];
    };
  };
}
