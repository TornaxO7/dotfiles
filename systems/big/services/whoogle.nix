utils: { domain-root, services-root, ... }:
let
  names = utils.createContainerNames "whoogle" [ "server" ];
  domain = "whoogle.${domain-root}";
in
{
  virtualisation.oci-containers.containers = {
    "${names.containers.server}" = {
      image = "benbusby/whoogle-search:latest";

      environment = {
        WHOOGLE_CONFIG_DISABLE = "true";
        WHOOGLE_CONFIG_URL = "https://${domain}";
      };

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.whoogle.rule" = "Host(`${domain}`)";
        "traefik.http.routers.whoogle.service" = names.containers.server;
        "traefik.http.routers.whoogle.tls" = "true";
        "traefik.http.routers.whoogle.tls.certresolver" = "main";
        "traefik.http.services.${names.containers.server}.loadbalancer.server.port" = "5000";
      };
    };
  };
}
