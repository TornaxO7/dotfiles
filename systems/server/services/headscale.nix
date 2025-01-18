utils: { config, domain-root, services-root, ip4, ... }:
let
  domain = "headscale.${domain-root}";

  paths = rec{
    root = "${services-root}/headscale";
    config = "${root}/config";
  };

  vol-prefix = "headscale";

  names = utils.createContainerNames "headscale" [ "server" "metrics" ];
in
{
  systemd.tmpfiles.settings.headscale-dirs = utils.createDirsWith "root" (builtins.attrValues paths);

  virtualisation.oci-containers.containers = {
    ${names.containers.server} = {
      image = "headscale/headscale:latest";

      volumes = [
        "${paths.config}:/etc/headscale"
        "${vol-prefix}-lib:/var/lib/headscale"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.${names.containers.server}.rule" = "Host(`${domain}`)";
        "traefik.http.routers.${names.containers.server}.service" = "${names.containers.server}";
        "traefik.http.services.${names.containers.server}.loadbalancer.server.port" = "8080";
      };

      cmd = [ "serve" ];
    };
  };
}
