{ root-domain, services-root, ... }:
let
  utils = import ../../../utils.nix;
  domain = "headscale.${root-domain}";

  paths = rec{
    root = "${services-root}/headscale";
    config = "${root}/config";
  };

  vol-prefix = "headscale";

  names = utils.createContainerNames "headscale" [ "server" ];
in
{
  systemd.tmpfiles.rules = [
    "L+ ${paths.config}/config.yaml - - - - ${./config.yaml}"
    "L+ ${paths.config}/acl.json - - - - ${./acl.json}"
  ];

  virtualisation.oci-containers.containers = {
    ${names.containers.server} = {
      image = "headscale/headscale:latest";

      volumes = [
        "${./config.yaml}:${./config.yaml}:ro"
        "${./acl.json}:${./acl.json}:ro"

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
