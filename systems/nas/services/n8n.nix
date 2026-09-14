{ config, wg0, ... }:
let
  domain = "n8n.${wg0.nas.host}";
  port = 49206;
in
{
  age.secrets = {
    n8n-runners-auth-token-file = {
      owner = "root";
      file = ../../../secrets/n8n-runners-auth-token.age;
    };
  };

  services = {
    n8n = {
      enable = true;
      taskRunners = {
        enable = true;
        runners = {
          javascript.enable = true;
          python.enable = true;
        };
      };

      environment = {
        N8N_PORT = port;
        N8N_RUNNERS_AUTH_TOKEN_FILE = config.age.secrets.n8n-runners-auth-token-file.path;
      };
    };

    traefik.dynamicConfigOptions.http = {
      routers.n8n = {
        rule = "Host(`${domain}`)";
        service = "n8n";
      };

      services.n8n.loadbalancer.servers = [
        {
          url = "http://127.0.0.1:${toString port}";
        }
      ];
    };
  };
}
