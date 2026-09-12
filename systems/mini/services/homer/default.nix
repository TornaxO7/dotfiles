{ config, wg0, ... }:
let
  domain = "homer.${wg0.server.host}";
in
{
  age.secrets.homer-config = {
    owner = "tornax";
    file = ../../secrets/homer-config.age;
  };

  virtualisation.oci-containers.containers.homer = {
    image = "b4bz/homer:latest";

    volumes = [
      "${config.age.secrets.homer-config.path}:/www/assets/config.yml"
    ];

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.homer.rule" = "Host(`${domain}`)";
      "traefik.http.routers.homer.service" = "homer";
      "traefik.http.services.homer.loadbalancer.server.port" = "8080";
    };
  };
}
