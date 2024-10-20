{ config, services-root, ... }:
let
  utils = import ./utils.nix;

  paths = rec {
    root = "${services-root}/adguardhome";
    work = "${root}/work";
    conf = "${root}/conf";
  };
in
{
  systemd = {
    tmpfiles.settings.adguardhome = utils.createDirs config (builtins.attrValues paths);

    services.podman-adguardhome = {
      after = [ "network-online.target" ];
    };
  };

  virtualisation.oci-containers.containers.adguardhome = {
    image = "adguard/adguardhome";

    volumes = [
      "${paths.work}:/opt/adguardhome/work"
      "${paths.conf}:/opt/adguardhome/conf"
    ];

    labels =
      let
        dns = "adguardhome.tornaxo7.de";
      in
      {
        "traefik.enable" = "true";

        "traefik.http.routers.admin-ui.rule" = "Host(`${dns}`)";
        "traefik.http.routers.admin-ui.service" = "admin-ui";
        "traefik.http.services.admin-ui.loadbalancer.server.port" = toString 3000;
        "traefik.http.routers.admin-ui.tls" = "true";
        "traefik.http.routers.admin-ui.tls.certresolver" = "main";
      };
  };
}
