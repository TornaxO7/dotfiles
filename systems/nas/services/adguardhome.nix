{ username, services-root, ... }:
let
  utils = import ../utils.nix;

  adguard-root-path = "${services-root}/adguard-home";

  work-path = "${adguard-root-path}/work";
  conf-path = "${adguard-root-path}/conf";
in
{
  systemd = {
    tmpfiles.settings = {
      adguardhome = utils.createDirs username [ adguard-root-path work-path conf-path ];
    };

    services.podman-adguardhome = rec {
      requires = [ "tailscaled.service" ];
      after = requires;
    };
  };

  virtualisation.oci-containers.containers.adguardhome = {
    image = "adguard/adguardhome";

    volumes = [
      "${work-path}:/opt/adguardhome/work"
      "${conf-path}:/opt/adguardhome/conf"
    ];

    ports = [
      "100.88.51.57:53:53"
      "100.88.51.57:53:53/udp"
    ];

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.adguardhome.rule" = "Host(`dns.local`) || Host(`nas`)";
      "traefik.http.routers.adguardhome.service" = "adguardhome";
      "traefik.http.services.adguardhome.loadbalancer.server.port" = toString 3000;
    };
  };
}
