{ username, ... }:
let
  utils = import ../utils.nix;

  jellyfin-dir = "/hdds/music/jellyfin";
  config-dir = "${jellyfin-dir}/config";
  cache-dir = "${jellyfin-dir}/cache";
in
{
  config = {
    systemd.tmpfiles.settings.jellyfin = utils.createDirs username [ jellyfin-dir config-dir cache-dir ];

    virtualisation.oci-containers.containers.jellyfin = {
      image = "docker.io/jellyfin/jellyfin";

      login.username = username;

      ports = [
        "8050:8096"
      ];

      volumes = [
        "${config-dir}:/config:Z"
        "${cache-dir}:/cache:Z"
        # from metube
        "/hdds/music/songs:/media:z"
      ];
    };
  };
}
