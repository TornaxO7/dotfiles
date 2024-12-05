utils: { config, services-root, pkgs, domain-root, ... }:
let
  network-name = "headscale-network";

  paths = rec {
    root = "${services-root}/headscale";
    config = "${root}/config";
    data = "${root}/data";
  };

  names = utils.createContainerNames "headscale" [ "server" "webui" ];
  domain = "headscale.${domain-root}";
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
      image = "headscale/headscale:latest";
      volumes = [
        "${paths.data}:/var/lib/headscale"
        "${paths.config}:/etc/headscale"
      ];
      labels = {
        "traefik.enable" = "true";

        "traefik.http.routers.${names.containers.server}.rule" = "Host(`${domain}`) && PathPrefix(`/`)";
        "traefik.http.routers.${names.containers.server}.service" = "${names.containers.server}";
        "traefik.http.routers.${names.containers.server}.tls" = "true";
        "traefik.http.routers.${names.containers.server}.tls.certresolver" = "main";
        "traefik.http.services.${names.containers.server}.loadbalancer.server.port" = "8080";
      };
      cmd = [ "serve" ];
      extraOptions = [ "--network=${network-name}" ];
    };

    "${names.containers.webui}" = {
      image = "ghcr.io/tale/headplane:latest";

      volumes = [
        "${paths.data}:/var/lib/headscale"
        "${paths.config}:/etc/headscale"
        "/var/run/podman/podman.sock:/var/run/docker.sock:ro"
      ];

      environmentFiles = [
        config.age.secrets.headplane-cookie.path
      ];

      environment = {
        HEADSCALE_URL = "https://${domain}";
        HEADSCALE_INTEGRATION = "docker";
        HEADSCALE_CONTAINER = names.containers.server;
        DISABLE_API_KEY_LOGIN = "true";
      };

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.${names.containers.webui}.rule" = "Host(`${domain}`) && PathPrefix(`/admin`)";
        "traefik.http.routers.${names.containers.webui}.service" = names.containers.webui;
        "traefik.http.routers.${names.containers.webui}.tls" = "true";
        "traefik.http.routers.${names.containers.webui}.tls.certresolver" = "main";
        "traefik.http.services.${names.containers.webui}.loadbalancer.server.port" = "3000";
      };

      extraOptions = [ "--network=${network-name}" ];
    };
  };
}
