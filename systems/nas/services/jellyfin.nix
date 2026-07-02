{ config, zpool-root, root-domain, ... }:
let
  username = config.users.users.tornax.name;

  prefix = "jellyfin";

  volumes = {
    cache = "${prefix}-cache";
    config = "${prefix}-config";
  };

  binds = rec {
    root = "${zpool-root}/jellyfin";
    music = "${root}/music";
    cartoons = "${root}/cartoons";
  };

  domain = "jellyfin.${root-domain}";
  metube-domain = "metube.${root-domain}";
in
{
  config = {
    systemd = {
      tmpfiles.settings.jellyfin = {
        "${binds.music}".d = {
          user = username;
          group = username;
        };
      };
    };

    virtualisation.oci-containers.containers = {
      jellyfin = {
        image = "docker.io/jellyfin/jellyfin";

        login.username = username;

        volumes = [
          "${volumes.cache}:/cache"
          "${volumes.config}:/config:Z"

          "${binds.music}:/media:z"
          "${binds.cartoons}:/media2:z"
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
          "traefik.http.routers.metube.rule" = "Host(`${metube-domain}`)";
          "traefik.http.routers.metube.service" = "metube";
          "traefik.http.services.metube.loadbalancer.server.port" = "8081";
        };
      };
    };
  };
}
