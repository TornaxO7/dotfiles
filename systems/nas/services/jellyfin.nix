{ username, ... }:
let
  jellyfin-dir = "/hdds/music/jellyfin";

  config-dir = "${jellyfin-dir}/config";
  cache-dir = "${jellyfin-dir}/cache";
in
{
  config = {
    systemd.tmpfiles.settings.jellyfin = {
      "${jellyfin-dir}".d.user = username;
      "${config-dir}".d.user = username;
      "${cache-dir}".d.user = username;
    };

    virtualisation.oci-containers.containers.jellyfin = {
      image = "docker.io/jellyfin/jellyfin";

      login.username = username;

      ports = [
        "8050:8096"
      ];

      volumes = [
        "${config-dir}:/config:Z"
        "${cache-dir}:/cache:Z"
        "/hdds/music/songs:/media:z"
      ];
    };
  };
}
