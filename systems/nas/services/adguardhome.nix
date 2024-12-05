utils: { config, services-root, ip-addr, domain-root, ... }:
let
  adguard-root-path = "${services-root}/adguard-home";

  work-path = "${adguard-root-path}/work";
  conf-path = "${adguard-root-path}/conf";

  names = utils.createContainerNames "dns" [ "server" ];
  domain = "dns.${domain-root}";
in
{
  systemd = {
    tmpfiles.settings = {
      adguardhome = utils.createDirs config [ adguard-root-path work-path conf-path ];
    };

    services.${names.service-prefixes.server} = {
      requires = [ "tailscaled.service" ];
      after = [ "network-online.target" ];
    };
  };

  virtualisation.oci-containers.containers.${names.containers.server} = {
    image = "adguard/adguardhome";

    volumes = [
      "${work-path}:/opt/adguardhome/work"
      "${conf-path}:/opt/adguardhome/conf"
    ];

    ports = [
      "${ip-addr}:53:53"
      "${ip-addr}:53:53/udp"
    ];

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.${names.containers.server}.rule" = "Host(`${domain}`) || Host(`nas`)";
      "traefik.http.routers.${names.containers.server}.service" = "${names.containers.server}";
      "traefik.http.services.${names.containers.server}.loadbalancer.server.port" = "3000";
    };
  };
}
