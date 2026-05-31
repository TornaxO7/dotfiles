{ config, zpool-root, root-domain, ... }:
let
  user = "tornax";
  domain = "paperless.${root-domain}";
in
{
  config = {
    age.secrets.paperless = {
      owner = config.services.paperless.user;
      file = ../../../secrets/paperless.age;
    };

    services = {
      paperless = {
        enable = true;
        user = user;
        address = "127.0.0.1";
        port = 49203;
        passwordFile = config.age.secrets.paperless.path;
        domain = domain;
        settings = {
          PAPERLESS_ADMIN_USER = "tornax";
          # PAPERLESS_OCR_USER_ARGS = { continue_on_soft_render_error = true; };
        };
        exporter = {
          enable = true;
          directory = "${zpool-root}/paperless";
        };
      };

      traefik.dynamicConfigOptions.http = {
        routers.paperless = {
          rule = "Host(`${domain}`)";
          service = "paperless";
        };

        services.paperless.loadbalancer.servers = [
          {
            url = "http://${config.services.paperless.address}:${builtins.toString config.services.paperless.port}";
          }
        ];
      };
    };
  };
}

