utils: { config, domain-root, services-root, ... }:
let
  prefix = "gotify";

  domain = "${prefix}.${domain-root}";

  paths = {
    root = "${services-root}/${prefix}";
  };
in
{
  config = {
    systemd.tmpfiles.rules = [
      "d ${paths.root} 0744 tornax - - -"
    ];

    virtualisation.oci-containers.containers.gotify = {
      image = "ghcr.io/gotify/server";
      volumes = [ "${paths.root}:/app/data" ];
      environment = {
        TZ = config.time.timeZone;
      };

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.gotify.rule" = "Host(`${domain}`)";
        "traefik.http.routers.gotify.service" = "gotify";
        "traefik.http.services.gotify.loadbalancer.server.port" = "80";
      };
    };
  };
}
