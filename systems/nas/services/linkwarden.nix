{ config, root-domain, zpool-root, ... }:
let
  domain = "linkwarden.${root-domain}";

  add-secret = path: {
    owner = config.services.linkwarden.user;
    file = path;
  };
in
{
  config = {
    age.secrets = {
      linkwarden-nextauth = add-secret ../../../secrets/linkwarden/nextauth.age;
      linkwarden-postgres-password = add-secret ../../../secrets/linkwarden/postgres_password.age;
    };

    services = rec {
      linkwarden = {
        enable = true;
        host = "127.0.0.1";
        port = 49202;
        storageLocation = "${zpool-root}/linkwarden";
        secretFiles = {
          NEXTAUTH_SECRET = config.age.secrets.linkwarden-nextauth.path;
          POSTGRES_PASSWORD = config.age.secrets.linkwarden-postgres-password.path;
        };
        environment = {
          MEILI_HOST = "http://${config.services.meilisearch.listenAddress}:${builtins.toString config.services.meilisearch.listenPort}";
        };
      };

      traefik.dynamicConfigOptions.http = {
        routers.linkwarden = {
          rule = "Host(`${domain}`)";
          service = "linkwarden";
        };

        services.linkwarden.loadbalancer.servers = [
          {
            url = "http://${linkwarden.host}:${builtins.toString linkwarden.port}";
          }
        ];
      };
    };
  };


}
