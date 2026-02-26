{ config, services-root, root-domain, ... }:
let
  utils = import ../../utils.nix;
  names = utils.createContainerNames "website" [ "server" ];

  domain = root-domain;

  paths = {
    root = "${services-root}/website";
  };
in
{
  systemd.tmpfiles.rules = [
    "d ${paths.root} 755 ${config.users.users.tornax.name} root -"
  ];

  virtualisation.oci-containers.containers.website = {
    image = "joseluisq/static-web-server:latest";

    volumes = [
      "${paths.root}/public:/public:ro"
    ];

    environment = {
      "TZ" = "Europe/Berlin";
    };

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.${names.containers.server}.rule" = "Host(`${domain}`) || Host(`tornax07.de`)";
      "traefik.http.routers.${names.containers.server}.service" = names.containers.server;
      # "traefik.http.routers.${names.containers.server}.middlewares" = "anubis@file";
      "traefik.http.services.${names.containers.server}.loadbalancer.server.port" = "80";
    };
  };
}
