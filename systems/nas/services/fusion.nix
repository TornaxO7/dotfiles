{ username, services-root, ... }:
let
  utils = import ../utils.nix;

  fusion-root = "${services-root}/fusion";
in
{
  systemd.tmpfiles.settings = {
    fusion-create-dirs = utils.createDirs username [ fusion-root ];
  };

  virtualisation.oci-containers.containers.fusion = {
    image = "rook1e404/fusion:latest";

    environment = {
      PASSWORD = "tornax";
    };

    volumes = [
      "${fusion-root}:/data"
    ];

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.fusion.rule" = "Host(`rss.local`)";
      "traefik.http.routers.fusion.service" = "fusion";
      "traefik.http.services.fusion.loadbalancer.server.port" = "8080";
    };
  };
}
