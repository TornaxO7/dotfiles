utils: { config, services-root, domain-root, ... }:
let
  paths = rec {
    root = "${services-root}/adguardhome";
    work = "${root}/work";
    conf = "${root}/conf";
  };

  names = utils.createContainerNames "dns" [ "server" ];

  domain = "dns.${domain-root}";
  ui-domain = "ui.${domain}";
in
{
  systemd = {
    tmpfiles.settings.adguardhome = utils.createDirs config (builtins.attrValues paths);

    services.podman-adguardhome = {
      after = [ "network-online.target" ];
    };
  };

  virtualisation.oci-containers.containers.${names.containers.server} = {
    image = "adguard/adguardhome";

    volumes = [
      "${paths.work}:/opt/adguardhome/work"
      "${paths.conf}:/opt/adguardhome/conf"
    ];

    labels = {
      "traefik.enable" = "true";

      # general 
      "traefik.http.routers.${names.containers.server}.rule" = "Host(`${domain}`)";
      "traefik.http.routers.${names.containers.server}.service" = "${names.containers.server}";
      "traefik.http.services.${names.containers.server}.loadbalancer.server.port" = "443";
      "traefik.http.routers.${names.containers.server}.tls" = "true";
      "traefik.http.routers.${names.containers.server}.tls.certresolver" = "main";

      # ui
      "traefik.http.routers.${names.containers.server}-ui.rule" = "Host(`${ui-domain}`)";
      "traefik.http.routers.${names.containers.server}-ui.service" = "${names.containers.server}-ui";
      "traefik.http.services.${names.containers.server}-ui.loadbalancer.server.port" = "3000";
      "traefik.http.routers.${names.containers.server}-ui.tls" = "true";
      "traefik.http.routers.${names.containers.server}-ui.tls.certresolver" = "main";
    };
  };
}
