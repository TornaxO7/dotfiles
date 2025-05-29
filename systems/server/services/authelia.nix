utils: { config, services-root, domain-root, ... }:
let
  domain = "auth.${domain-root}";


  paths = rec {
    root = "${services-root}/authelia";
    user_db = "${root}/user_database.yml";
    storage_db = "${root}/db.sqlite3";
    notifications = "${root}/notifications.txt";
  };

  port = 49162;

  # helper function to add secrets
  add-secret = path: {
    owner = config.services.authelia.instances."main".user;
    file = path;
  };
in
{
  systemd.tmpfiles.rules =
    let
      user = config.services.authelia.instances."main".user;
      group = config.services.authelia.instances."main".group;
    in
    [
      "d ${paths.root} 0760 ${user} ${group} -"
      "f ${paths.user_db} 0760 ${user} ${group} -"
      "f ${paths.storage_db} 0760 ${user} ${group} -"
      "f ${paths.notifications} 0760 ${user} ${group} -"
    ];

  age.secrets = {
    authelia-jwt = add-secret ../../../secrets/authelia-jwt.age;
    authelia-session = add-secret ../../../secrets/authelia-session.age;
    authelia-storage = add-secret ../../../secrets/authelia-storage.age;
  };

  services.authelia.instances."main" = {
    enable = true;
    group = "services";
    settings = {
      theme = "dark";
      log.format = "text";

      server = {
        address = "tcp://127.0.0.1:${toString port}";
      };

      authentication_backend.file = {
        path = paths.user_db;
      };

      storage.local.path = paths.storage_db;

      session.cookies = [
        {
          name = "main";
          domain = domain-root;
          authelia_url = "https://${domain}";
        }
      ];

      notifier.filesystem.filename = paths.notifications;

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
