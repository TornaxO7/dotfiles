{ config, root-domain, ... }:
let
  domain = "auth.${root-domain}";

  port = 49162;

  paths = rec {
    root = "/var/lib/authelia-main";
    user_db = "${root}/user_database.yml";
    storage_db = "${root}/db.sqlite3";
    notifications = "${root}/notifications.txt";
  };

  user = config.services.authelia.instances."main".user;
  group = config.services.authelia.instances."main".group;

  # helper function to add secrets
  add-secret = path: {
    owner = user;
    file = path;
  };
in
{
  systemd.tmpfiles.rules =
    [
      "d ${paths.root} 0750 ${user} ${group} -"
      "L+ ${paths.user_db} 0600 ${user} ${group} - ${./user_database.yml}"
    ];

  age.secrets = {
    authelia-jwt = add-secret ../../../../secrets/authelia-jwt.age;
    authelia-session = add-secret ../../../../secrets/authelia-session.age;
    authelia-storage = add-secret ../../../../secrets/authelia-storage.age;
  };

  services.authelia.instances."main" = {
    enable = true;
    settings = {
      theme = "dark";

      server = {
        address = "tcp://127.0.0.1:${toString port}";

        endpoints = {
          authz = {
            forward-auth = {
              implementation = "ForwardAuth";
              authn_strategies = [ ];
            };
          };
        };
      };

      authentication_backend = {
        file.path = paths.user_db;
      };

      storage.local.path = paths.storage_db;

      session.cookies = [
        {
          name = "main";
          domain = root-domain;
          authelia_url = "https://${domain}";
          default_redirection_url = "https://${root-domain}";
        }
      ];

      notifier.filesystem.filename = paths.notifications;

      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = "filebrowser.${root-domain}";
            policy = "bypass";
            resources = [
              "^/api/public/dl/*" # download stuff
              "^/api/public/share/*" # general access shared stuff
              "^/share/*" # shared assets
            ];
          }
          {
            domain = "*.${root-domain}";
            policy = "two_factor";
          }
        ];
      };

      totp = {
        issuer = domain;
        algorithm = "sha512";
        digits = 6;
        period = 30;
        skew = 1;
        secret_size = 32;
        allowed_algorithms = [ "SHA512" ];
        allowed_digits = [ 6 ];
        allowed_periods = [ 30 ];
        disable_reuse_security_policy = false;
      };

      regulation = {
        modes = [ "ip" ];
        max_retries = 3;
        find_time = "2m";
        ban_time = "1d";
      };

      log = {
        level = "info";
        format = "text";
      };
    };

    secrets = {
      jwtSecretFile = config.age.secrets.authelia-jwt.path;
      sessionSecretFile = config.age.secrets.authelia-session.path;
      storageEncryptionKeyFile = config.age.secrets.authelia-storage.path;
    };
  };

  # == traefik stuff ==
  services.traefik.dynamicConfigOptions.http = {
    middlewares.authelia.forwardAuth = {
      address = "http://127.0.0.1:${toString port}/api/authz/forward-auth";
      authResponseHeaders = [ "Remote-User" "Remote-Groups" "Remote-Email" "Remote-Name" ];
    };

    routers.authelia = {
      rule = "Host(`${domain}`)";
      service = "authelia";
    };

    services.authelia.loadbalancer.servers = [
      {
        url = "http://127.0.0.1:${toString port}";
      }
    ];
  };
}
