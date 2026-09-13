{ config, root-domain, ... }:
let
  domain = root-domain;
  files = "/var/lib/website";
in
{
  systemd.tmpfiles.rules = [
    "d ${files} 755 ${config.users.users.tornax.name} root -"
  ];

  virtualisation.oci-containers.containers.website = {
    image = "docker.io/joseluisq/static-web-server:latest";

    volumes = [
      "${files}/public:/public:ro"
    ];

    environment = {
      "TZ" = "Europe/Berlin";
    };

    labels = {
      "io.containers.autoupdate" = "registry";

      "traefik.enable" = "true";
      "traefik.http.routers.website.rule" = "Host(`${domain}`) || Host(`tornax07.de`)";
      "traefik.http.routers.website.service" = "website";
      # "traefik.http.routers.${names.containers.server}.middlewares" = "anubis@file";
      "traefik.http.services.website.loadbalancer.server.port" = "80";
    };
  };
}
