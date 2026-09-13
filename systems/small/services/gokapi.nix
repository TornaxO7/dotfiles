{ wg0, tld, ... }:
let
  prefix = "gokapi";
  domain = "${prefix}.${tld}";
  domain-vpn = "${prefix}.${wg0.small.host}";
in
{
  virtualisation.oci-containers.containers.gokapi = {
    image = "docker.io/f0rc3/gokapi:latest";

    volumes = [
      "gokapi-data:/app/data"
      "gokapi-config:/app/config"
    ];

    environment = {
      TZ = "Europe/Berlin";
    };

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.${prefix}.rule" = "Host(`${domain}`) && !(PathPrefix(`/setup`) || PathPrefix(`/admin`) || PathPrefix(`/apiKeys`) || PathPrefix(`/auth/token`) || PathPrefix(`/changePassword`) || PathPrefix(`/downloadPresigned`) || PathPrefix(`/e2eSetup`) || PathPrefix(`/filerequests`) || PathPrefix(`/logs`) || PathPrefix(`/uploadChunk`) || PathPrefix(`/uploadStatus`) || PathPrefix(`/users`))";
      "traefik.http.routers.${prefix}.service" = prefix;
      "traefik.http.services.${prefix}.loadbalancer.server.port" = "53842";

      "traefik.http.routers.${prefix}-vpn.rule" = "Host(`${domain-vpn}`)";
      "traefik.http.routers.${prefix}-vpn.entryPoints" = "https-vpn";
      "traefik.http.routers.${prefix}-vpn.service" = "${prefix}-vpn";
      "traefik.http.services.${prefix}-vpn.loadbalancer.server.port" = "53842";
    };
  };
}
