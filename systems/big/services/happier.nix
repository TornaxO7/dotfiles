{ config, wg0, ... }:
let

  domain = "happier.${wg0.big.host}";
in
{
  networking.hosts = {
    "${wg0.big.addr}" = [ domain ];
  };

  age.secrets = {
    happier-env-file = {
      owner = "root";
      file = ../../../secrets/happier-env-vars.age;
    };
  };

  virtualisation.oci-containers.containers.happier = {
    image = "happierdev/relay-server:latest";
    volumes = [
      "happier-data:/data"
    ];

    environment = {
      HAPPIER_PUBLIC_SERVER_URL = "https://${domain}";
      HAPPIER_SERVER_TRUST_PROXY = "1";
    };

    environmentFiles = [
      config.age.secrets.happier-env-file.path
    ];

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.happier.rule" = "Host(`${domain}`)";
      "traefik.http.routers.happier.service" = "happier";
      "traefik.http.services.happier.loadbalancer.server.port" = "3005";
    };
  };
}
