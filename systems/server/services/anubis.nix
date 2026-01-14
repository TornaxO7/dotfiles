{ config, root-domain, ... }:
let
  port = 49191;
  domain = "anubis.${root-domain}";
in
{
  services = {
    anubis = {
      defaultOptions = {
        settings = {
          WEBMASTER_EMAIL = "tornax@pm.me";
        };
      };

      instances = {
        main = {
          enable = true;
          settings = {
            TARGET = " ";
            REDIRECT_DOMAINS = root-domain;
            PUBLIC_URL = "https://${domain}";
            COOKIE_DOMAIN = root-domain;

            BIND_NETWORK = "tcp";
            BIND = "127.0.0.1:${builtins.toString port}";
          };
        };
      };
    };

    traefik = {
      staticConfigOptions.entryPoints.https.http.middlewares = "anubis@file";

      dynamicConfigOptions.http =
        let
          main = config.services.anubis.instances.main;

          anubis-url = "http://${main.settings.BIND}/.within.website/x/cmd/anubis/api/check";
        in
        {
          middlewares.anubis.forwardAuth.address = "${anubis-url}";

          routers.anubis = {
            rule = "Host(`${domain}`)";
            service = "anubis";
          };

          services.anubis.loadbalancer.servers =
            [
              {
                url = "http://${main.settings.BIND}";
              }
            ];
        };
    };
  };
}
