{ zpool-root, wg0, unstable, ... }:
let
  domain = "immich.${wg0.nas.host}";
in
{
  services = rec {
    immich = {
      enable = true;
      package = unstable.immich;
      host = "127.0.0.1";
      port = 49200;
      mediaLocation = "${zpool-root}/immich";
    };

    traefik.dynamicConfigOptions.http = {
      routers.immich = {
        rule = "Host(`${domain}`)";
        service = "immich";
      };

      services.immich.loadbalancer.servers = [
        {
          url = "http://${immich.host}:${builtins.toString immich.port}";
        }
      ];
    };
  };
}
