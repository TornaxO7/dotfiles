{ zpool-root, root-domain, unstable, ... }:
let
  domain = "immich.${root-domain}";
  user = "tornax";
in
{
  services = rec {
    immich = {
      enable = true;
      user = user;
      package = unstable.immich;
      host = "127.0.0.1";
      port = 49200;
      mediaLocation = "${zpool-root}/immich";

      database = {
        user = user;
        name = user;
      };
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
