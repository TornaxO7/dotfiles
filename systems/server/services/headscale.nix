utils: { config, services-root, pkgs, ... }:
let
  network-name = "headscale-network";

  paths = rec {
    root = "${services-root}/headscale";
    config = "${root}/headscale-config";
  };

  names = utils.createContainerNames "headscale" [ "server" ];
  domain = "headscale.tornaxo7.de";
in
{
  systemd = {
    tmpfiles.settings = {
      "${paths.root}" = utils.createDirs config [ paths.root ];
      "${paths.config}" = utils.createDirs config [ paths.config ];
    };

    services = {
      create-headscale-network = utils.createPodmanNetworkService pkgs network-name (builtins.attrValues names.service-full);
    };
  };

  virtualisation.oci-containers.containers = {
    "${names.containers.server}" = {
      image = "headscale/headscale:latest";
      volumes = [
        "${paths.config}:/etc/headscale"
      ];
      labels = {
        "traefik.enable" = "true";

        "traefik.http.routers.headscale-8080.rule" = "Host(`${domain}`)";
        "traefik.http.routers.headscale-8080.service" = "headscale-8080";
        "traefik.http.routers.headscale-8080.tls" = "true";
        "traefik.http.routers.headscale-8080.tls.certresolver" = "main";
        "traefik.http.services.headscale-8080.loadbalancer.server.port" = "8080";

        "traefik.http.routers.headscale-9090.rule" = "Host(`${domain}`)";
        "traefik.http.routers.headscale-9090.service" = "headscale-9090";
        "traefik.http.routers.headscale-9090.tls" = "true";
        "traefik.http.routers.headscale-9090.tls.certresolver" = "main";
        "traefik.http.services.headscale-9090.loadbalancer.server.port" = "9090";
      };
    };
  };
}
