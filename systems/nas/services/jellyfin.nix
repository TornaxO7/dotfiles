{ pkgs, username, zpool-name, zpool-root, ... }:
let
  utils = import ../utils.nix;

  jellyfin-dir = "${zpool-root}/music/jellyfin";
  config-dir = "${jellyfin-dir}/config";
  cache-dir = "${jellyfin-dir}/cache";
  songs-path = "${zpool-root}/music/songs";
in
{
  config = {
    systemd = {
      tmpfiles.settings.jellyfin = utils.createDirs username [ jellyfin-dir config-dir cache-dir songs-path ];
    }
    //
    (utils.createSystemdZfsSnapshot pkgs "jellyfin" "${zpool-name}/music");

    virtualisation.oci-containers.containers = {
      jellyfin = {
        image = "docker.io/jellyfin/jellyfin";

        login.username = username;

        volumes = [
          "${config-dir}:/config:Z"
          "${cache-dir}:/cache:Z"
          "${songs-path}:/media:z"
        ];

        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.jellyfin.rule" = "Host(`jellyfin.local`)";
          "traefik.http.routers.jellyfin.service" = "jellyfin";
          "traefik.http.services.jellyfin.loadbalancer.server.port" = toString 8096;
        };
      };

      metube = {
        image = "ghcr.io/alexta69/metube";
        volumes = [ "${songs-path}:/downloads" ];

        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.metube.rule" = "Host(`metube.local`)";
          "traefik.http.routers.metube.service" = "metube";
          "traefik.http.services.metube.loadbalancer.server.port" = toString 8081;
        };
      };
    };
  };
}
