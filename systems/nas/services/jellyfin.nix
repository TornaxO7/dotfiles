port: { username, zpool-root, ... }:
let
  utils = import ../utils.nix;
  portStr = toString port;

  metubePort = port + 1;
  metubePortStr = toString metubePort;

  jellyfin-dir = "${zpool-root}/music/jellyfin";
  config-dir = "${jellyfin-dir}/config";
  cache-dir = "${jellyfin-dir}/cache";
  songs-path = "${zpool-root}/music/songs";
in
{
  config = {
    systemd.tmpfiles.settings.jellyfin = utils.createDirs username [ jellyfin-dir config-dir cache-dir songs-path ];

    virtualisation.oci-containers.containers = {
      jellyfin = {
        image = "docker.io/jellyfin/jellyfin";

        login.username = username;

        ports = [
          "${portStr}:8096"
        ];

        volumes = [
          "${config-dir}:/config:Z"
          "${cache-dir}:/cache:Z"
          "${songs-path}:/media:z"
        ];
      };

      metube = {
        image = "ghcr.io/alexta69/metube";
        ports = [ "${metubePortStr}:8081" ];
        volumes = [ "${songs-path}:/downloads" ];
      };
    };
  };
}
