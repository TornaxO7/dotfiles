{ tld, ... }:
let
  dir = "/var/lib/website";
in
{
  users = {
    users.website = {
      home = "/home/website";
      initialHashedPassword = "!";
      group = "website";
      isSystemUser = true;
    };

    groups.website = { };
  };

  systemd.tmpfiles.rules = [
    "d ${dir} 755 website website -"
  ];

  virtualisation.oci-containers.containers.website = {
    image = "docker.io/joseluisq/static-web-server:latest";

    volumes = [
      "${dir}:/public:ro"
    ];

    environment = {
      "TZ" = "Europe/Berlin";
    };

    labels = {
      "io.containers.autoupdate" = "registry";

      "traefik.enable" = "true";
      "traefik.http.routers.website.rule" = "Host(`${tld}`) || Host(`tornax07.de`)";
      "traefik.http.routers.website.service" = "website";
      "traefik.http.services.website.loadbalancer.server.port" = "80";
    };
  };
}
