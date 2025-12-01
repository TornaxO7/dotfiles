{ config, root-domain, ... }:
let
  domain = "grafana.${root-domain}";
  port = 49163;

  user = config.users.users.grafana.name;
  group = config.users.users.grafana.group;

  paths = rec {
    root = "/var/lib/grafana";
    db = "${root}/db.sqlite3";
    etc = "/etc/grafana";
  };
in
{
  systemd.tmpfiles.rules =
    [
      "d ${paths.root} 0750 ${user} ${group} -"
      "d ${paths.etc} 0750 ${user} ${group} -"
    ];

  age.secrets =
    let
      add-secret = path: {
        owner = user;
        file = path;
      };
    in
    {
      grafana = add-secret ../../../secrets/grafana.age;
    };

  services.grafana = {
    enable = true;
    provision = {
      enable = true;

      dashboards.settings.providers = [
        {
          name = "Dashboards";
          options.path = paths.etc;
        }
      ];
    };

    settings = {
      paths = {
        data = paths.root;
      };

      server = {
        protocol = "http";
        http_addr = "127.0.0.1";
        http_port = port;
        enable_gzip = true;
      };

      database = {
        type = "sqlite3";
        path = paths.db;
      };

      security = {
        admin_user = "tornax";
        admin_password = "$__file{${config.age.secrets.grafana.path}}";
        admin_email = "tornax@pm.me";
        cookie_secure = true;
        domain = domain;
      };
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.grafana = {
      rule = "Host(`${domain}`)";
      service = "grafana";
      middlewares = [ "authelia@file" ];
    };

    services.grafana.loadbalancer.servers = [
      {
        url = "http://127.0.0.1:${toString port}";
      }
    ];
  };
}
