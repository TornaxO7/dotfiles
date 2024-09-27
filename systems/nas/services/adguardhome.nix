{ username, services-root, ... }:
let
  utils = import ../utils.nix;

  adguard-root-path = "${services-root}/adguard-home";

  work-path = "${adguard-root-path}/work";
  conf-path = "${adguard-root-path}/conf";
in
{
  systemd.tmpfiles.settings = {
    adguardhome = utils.createDirs username [ adguard-root-path work-path conf-path ];
  };

  virtualisation.oci-containers.containers.adguardhome = {
    image = "adguard/adguardhome";

    volumes = [
      "${work-path}:/opt/adguardhome/work"
      "${conf-path}:/opt/adguardhome/conf"
    ];

    extraOptions = [
      "--network=host"
    ];

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.adguardhome.rule" = "Host(`dns.local`)";
      "traefik.http.routers.adguardhome.service" = "adguardhome";
      "traefik.http.services.adguardhome.loadbalancer.server.port" = toString 49200;
    };
  };
}
