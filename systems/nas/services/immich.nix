username:
{ config, zpool-root, root-domain, unstable, ... }:
let
  domain = "immich.${root-domain}";
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
