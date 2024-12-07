utils: { config, lib, pkgs, zpool-root, zpool-name, domain-root, ... }:
let
  names = utils.createContainerNames "vikunja" [ "server" ];

  bind-root = "${zpool-root}/vikunja";
  binds = {
    files = "${bind-root}/files";
    db = "${bind-root}/db";
  };

  domain = "vikunja.${domain-root}";
in
{
  systemd = lib.attrsets.recursiveUpdate
    {
      tmpfiles.settings.vikunja = utils.createDirs config (builtins.attrValues binds);
    }
    (utils.createSystemdZfsSnapshot pkgs "vikunja" "${zpool-name}/vikunja");

  virtualisation.oci-containers.containers = {
    "${names.containers.server}" = {
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
        "traefik.http.routers.${names.containers.server}.rule" = "Host(`${domain}`)";
        "traefik.http.routers.${names.containers.server}.service" = "${names.containers.server}";
        "traefik.http.services.${names.containers.server}.loadbalancer.server.port" = "3456";
      };
    };
  };
}

