utils: { config, services-root, domain-root, ... }:
let
  names = utils.createContainerNames "website" [ "server" ];

  domain = domain-root;

  public-root = "${services-root}/website";
in
{
  systemd.tmpfiles.settings.website-files = utils.createDirs config [ public-root ];

  virtualisation.oci-containers.containers.website = {
    image = "joseluisq/static-web-server:latest";

    volumes = [
      "${public-root}:/public"
    ];

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.${names.containers.server}.rule" = "Host(`${domain}`)";
      "traefik.http.routers.${names.containers.server}.service" = names.containers.server;
      "traefik.http.routers.${names.containers.server}.tls" = "true";
      "traefik.http.routers.${names.containers.server}.tls.certresolver" = "main";
      "traefik.http.services.${names.containers.server}.loadbalancer.server.port" = "80";
    };
  };
}
