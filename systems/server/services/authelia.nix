utils: { config, services-root, domain-root, ... }:
let
  domain = "auth.${domain-root}";

  dir = {
    root = "${services-root}/authelia";
  };

  port = 49162;

  # helper function to add secrets
  add-secret = path: {
    owner = config.services.authelia.instances."main".user;
    file = path;
  };
in
{
  systemd.tmpfiles.rules = [
    "d ${dir.root} 0777 ${config.services.authelia.instances."main".user} ${config.services.authelia.instances."main".group} -"
  ];

  age.secrets = {
    authelia-jwt = add-secret ../../../secrets/authelia-jwt.age;
    authelia-session = add-secret ../../../secrets/authelia-session.age;
    authelia-storage = add-secret ../../../secrets/authelia-storage.age;
  };

  services.authelia.instances."main" = {
    enable = true;
    group = "podman";
    settings = {
      theme = "dark";
      log.format = "text";

      server = {
        address = "tcp://127.0.0.1:${toString port}";
      };

      authentication_backend.file = {
        path = "/tmp/user_database.yml";
      };

      storage.local.path = "/tmp/db.sqlite3";

      session.cookies = [
        {
          name = "main";
          domain = "tornaxo7.de";
          authelia_url = "https://${domain}";
        }
      ];

      notifier.filesystem.filename = "${dir.root}/notifications.txt";

      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = "*.${domain-root}";
            policy = "one_factor";
          }
        ];
      };
    };

    secrets = {
      jwtSecretFile = config.age.secrets.authelia-jwt.path;
      sessionSecretFile = config.age.secrets.authelia-session.path;
      storageEncryptionKeyFile = config.age.secrets.authelia-storage.path;
    };
  };

  # == traefik stuff ==
  services.traefik.dynamicConfigOptions.http.routers.authelia = {
    rule = "Host(`${domain}`)";
    service = "authelia";
  };
  services.traefik.dynamicConfigOptions.http.routers.authelia.loadBalancer.server.url = "http://127.0.0.1:${toString port}";
}
