{ config, zpool-root, root-domain, ... }:
let
  bind-root = "${zpool-root}/vikunja";
  binds = {
    files = "${bind-root}/files";
    db = "${bind-root}/db";
  };

  tmpfiles-entry = {
    user = config.users.users.tornax.name;
    group = config.users.users.tornax.name;
  };

  domain = "vikunja.${root-domain}";
in
{
  systemd.tmpfiles.settings.vikunja = {
    "${binds.files}".d = tmpfiles-entry;
    "${binds.db}".d = tmpfiles-entry;
  };

  virtualisation.oci-containers.containers = {
    vikunja = {
      image = "vikunja/vikunja";
      environment = {
        VIKUNJA_SERVICE_PUBLICURL = "http://${domain}/";
        VIKUNJA_DATABASE_PATH = "/db/vikunja.db";
        VIKUNJA_SERVICE_JWTSECRET = "<a super secure random secret>";
      };

      volumes = [
        "${binds.files}:/app/vikunja/files"
        "${binds.db}:/db"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.vikunja.rule" = "Host(`${domain}`)";
        "traefik.http.routers.vikunja.service" = "vikunja";
        "traefik.http.services.vikunja.loadbalancer.server.port" = "3456";
      };
    };
  };
}

