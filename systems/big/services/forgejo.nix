{ wg0, ... }:
let
  domain = "forgejo.${wg0.big.host}";
  port = 49192;
in
{
  services = {
    forgejo = {
      enable = true;
      database.type = "sqlite3";
      lfs.enable = true;

      settings = {
        server = {
          DOMAIN = domain;
          HTTP_PORT = port;
          HTTP_ADDR = "127.0.0.1";
          PROTOCOL = "http";
          ROOT_URL = "https://${domain}";
        };
      };
    };

    traefik.dynamicConfigOptions.http = {
      routers.forgejo = {
        rule = "Host(`${domain}`)";
        service = "forgejo";
      };

      services.forgejo.loadbalancer.servers = [
        {
          url = "http://127.0.0.1:${toString port}";
        }
      ];
    };
  };
}
