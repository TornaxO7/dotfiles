utils: { config, services-root, domain-root, ... }:
let
  paths = rec {
    root = "${services-root}/adguardhome";
    work = "${root}/work";
    conf = "${root}/conf";
  };

  names = utils.createContainerNames "dns" [ "server" ];

  domain = "dns.${domain-root}";
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

      "traefik.http.routers.${names.containers.server}.rule" = "Host(`${domain}`)";
      "traefik.http.routers.${names.containers.server}.service" = "${names.containers.server}";
      "traefik.http.services.${names.containers.server}.loadbalancer.server.port" = "3000";
      "traefik.http.routers.${names.containers.server}.tls" = "true";
      "traefik.http.routers.${names.containers.server}.tls.certresolver" = "main";
    };
  };
}
