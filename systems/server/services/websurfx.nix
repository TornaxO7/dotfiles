utils: { config, pkgs, services-root, domain-root, ... }:
let
  paths = {
    root = "${services-root}/websurfx";
  };

  names = utils.createContainerNames "websurfx" [
    "server"
    "redis"
  ];

  domain = "websurfx.${domain-root}";

  network-name = "websurfx-network";
in
{
  systemd = {
    tmpfiles.settings = {
      websurfx-root = utils.createDirs config [ paths.root ];
    };

    services = {
      create-websurfx-network = utils.createPodmanNetworkService pkgs network-name (builtins.attrValues names.service-full);

      ${names.containers.server}.requires = [ names.service-full.redis ];
    };
  };

  virtualisation.oci-containers.containers = {
    "${names.containers.server}" = {
      image = "neonmmd/websurfx:latest";
      volumes = [
        "${paths.root}:/etc/xdg/websurfx"
      ];
      extraOptions = [ "--network=${network-name}" ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.${names.containers.server}.rule" = "Host(`${domain}`)";
        "traefik.http.routers.${names.containers.server}.service" = "${names.containers.server}";
        "traefik.http.services.${names.containers.server}.loadbalancer.server.port" = "8080";
        "traefik.http.routers.${names.containers.server}.tls" = "true";
        "traefik.http.routers.${names.containers.server}.tls.certresolver" = "main";
      };
    };

    "${names.containers.redis}" = {
      image = "redis:latest";

      extraOptions = [ "--network=${network-name}" ];
    };
  };
}
