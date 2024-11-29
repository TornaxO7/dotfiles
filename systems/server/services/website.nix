utils: { config, services-root, domain-root, ... }:
let
  names = utils.createContainerNames "website" [ "server" ];

  domain = domain-root;

  paths = {
    website = "${services-root}/website";
  };
in
{
  systemd.tmpfiles.settings.website-files = utils.createDirs config (builtins.attrValues paths);

  virtualisation.oci-containers.containers.website = {
    image = "joseluisq/static-web-server:latest";

    volumes = [
      "${paths.website}/public:/public"
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
