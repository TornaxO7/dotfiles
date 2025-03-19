utils: { config, pkgs, zpool-name, zpool-root, domain-root, ... }:
let
  username = config.users.users.main.name;

  prefix = "jellyfin";

  volumes = {
    cache = "${prefix}-cache";
    config = "${prefix}-config";
  };

  binds = rec {
    root = "${zpool-root}/jellyfin";
    music = "${root}/music";
  };

  domain = "jellyfin.${domain-root}";
in
{
  config = {
    systemd = {
      tmpfiles.rules = [
        "d ${binds.music} - ${username} ${username} -"
      ];
    }
    //
    (utils.createSystemdZfsSnapshot pkgs "jellyfin" "${zpool-name}/jellyfin");

    virtualisation.oci-containers.containers = {
      jellyfin = {
        image = "docker.io/jellyfin/jellyfin";

        login.username = username;

        volumes = [
          "${volumes.cache}:/cache"
          "${volumes.config}:/config:Z"

          "${binds.music}:/media:z"
        ];

        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.jellyfin.rule" = "Host(`${domain}`)";
          "traefik.http.routers.jellyfin.service" = "jellyfin";
          "traefik.http.services.jellyfin.loadbalancer.server.port" = "8096";
        };
      };

      metube = {
        image = "ghcr.io/alexta69/metube";
        volumes = [ "${binds.music}:/downloads" ];

        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.metube.rule" = "Host(`metube.nas.local`)";
          "traefik.http.routers.metube.service" = "metube";
          "traefik.http.services.metube.loadbalancer.server.port" = "8081";
        };
      };
    };
  };
}
