utils: { config, domain-root, services-root, ... }:
let
  domain = "headscale.${domain-root}";

  paths = rec{
    root = "${services-root}/headscale";
    config = "${root}/config";
    lib = "${root}/lib";
  };


  names = utils.createContainerNames "headscale" [ "server" ];
in
{
  systemd.tmpfiles.settings.headscale-dirs = utils.createDirs config (builtins.attrValues paths);

  virtualisation.oci-containers.containers = {

    ${names.containers.server} = {
      image = "headscale/headscale:latest";

      volumes = [
        "${paths.config}:/etc/headscale"
        "${paths.lib}:/var/lib/headscale"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.${names.containers.server}.rule" = "Host(`${domain}`)";
        "traefik.http.routers.${names.containers.server}.service" = "${names.containers.server}";
        "traefik.http.services.${names.containers.server}.loadbalancer.server.port" = "8080";
        "traefik.http.routers.${names.containers.server}.tls" = "true";
        "traefik.http.routers.${names.containers.server}.tls.certresolver" = "main";
      };

      cmd = [ "serve" ];
    };
  };
}
