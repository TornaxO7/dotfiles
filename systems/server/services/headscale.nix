utils: { config, services-root, pkgs, domain-root, ... }:
let
  network-name = "headscale-network";

  paths = rec {
    root = "${services-root}/headscale";
    config = "${root}/headscale-config";
    data = "${root}/headscale-data";
  };

  names = utils.createContainerNames "headscale" [ "server" "webui" ];
  server-domain = "headscale.${domain-root}";
  ui-domain = "ui.${server-domain}";
in
{
  systemd = {
    tmpfiles.settings = {
      headscale-root = utils.createDirs config [ paths.root ];
      headscale-config = utils.createDirs config [ paths.config ];
      headscale-data = utils.createDirs config [ paths.data ];
    };

    services = {
      create-headscale-network = utils.createPodmanNetworkService pkgs network-name (builtins.attrValues names.service-full);
    };
  };

  virtualisation.oci-containers.containers = {
    "${names.containers.server}" = {
      image = "headscale/headscale:stable";
      volumes = [
        "${paths.config}:/etc/headscale"
        "${paths.data}:/var/lib/headscale"
      ];
      labels = {
        "traefik.enable" = "true";

        "traefik.http.routers.headscale-8080.rule" = "Host(`${server-domain}`)";
        "traefik.http.routers.headscale-8080.service" = "headscale-8080";
        "traefik.http.routers.headscale-8080.tls" = "true";
        "traefik.http.routers.headscale-8080.tls.certresolver" = "main";
        "traefik.http.services.headscale-8080.loadbalancer.server.port" = "8080";

        "traefik.http.routers.headscale-9090.rule" = "Host(`${server-domain}`)";
        "traefik.http.routers.headscale-9090.service" = "headscale-9090";
        "traefik.http.routers.headscale-9090.tls" = "true";
        "traefik.http.routers.headscale-9090.tls.certresolver" = "main";
        "traefik.http.services.headscale-9090.loadbalancer.server.port" = "9090";
      };
    };

    "${names.containers.webui}" = {
      image = "ghcr.io/gurucomputing/headscale-ui:latest";

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.hoadscale-ui.rule" = "Host(`${ui-domain}`)";
        "traefik.http.routers.hoadscale-ui.service" = names.containers.webui;
        "traefik.http.routers.hoadscale-ui.tls" = "true";
        "traefik.http.routers.hoadscale-ui.tls.certresolver" = "main";
        "traefik.http.services.${names.containers.webui}.loadbalancer.server.port" = "8443";
      };
    };
  };
}
