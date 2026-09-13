{ config, services-root, ... }:
let
  utils = import ./utils.nix;
  domain = "gotify.tornaxo7.de";
  paths = {
    root = "${services-root}/gotify";
  };
in
{
  config = {
    systemd.tmpfiles.settings = {
      gotify = utils.createDirs config (builtins.attrValues paths);
    };
    virtualisation.oci-containers.containers.gotify = {
      image = "ghcr.io/gotify/server";
      volumes = [
        "${paths.root}:/app/data"
      ];
      environment = {
        TZ = config.time.timeZone;
        GOTIFY_REGISTRATION = "false";
      };

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.gotify.rule" = "Host(`${domain}`)";
        "traefik.http.routers.gotify.service" = "gotify";
        "traefik.http.services.gotify.loadbalancer.server.port" = toString 80;
        "traefik.http.routers.gotify.tls" = "true";
        "traefik.http.routers.gotify.tls.certresolver" = "main";
      };
    };
  };
}
