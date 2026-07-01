{ config, zpool-root, root-domain, ... }:
let
  domain = "audiobookshelf.${root-domain}";

  dir = "${zpool-root}/audiobookshelf";
in
{
  systemd.tmpfiles.settings."audiobookshelf" =
    let
      entry = {
        user = config.users.users.tornax.name;
      };
    in
    {
      "${dir}/config".d = entry;
      "${dir}/metadata".d = entry;

      "${dir}/content".d = entry;
    };

  virtualisation.oci-containers.containers.audiobookshelf = {
    image = "ghcr.io/advplyr/audiobookshelf:latest";

    volumes = [
      "${dir}/config:/config"
      "${dir}/metadata:/metadata"

      "${dir}/content:/content"
    ];

    environment = {
      TZ = "Europe/Berlin";
    };

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.audiobookshelf.rule" = "Host(`${domain}`)";
      "traefik.http.routers.audiobookshelf.service" = "audiobookshelf";
      "traefik.http.services.audiobookshelf.loadbalancer.server.port" = "80";
    };
  };
}
