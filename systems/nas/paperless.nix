{ username, ... }:
let
  zpool-name = "hdds";
  zpool-root = "/${zpool-name}";
  paperless-dir = "${zpool-root}/paperless";
in
{
  config =
    let
      postgres-path = "/var/lib/postgresql/data";
      paperless-paths = {
        data = "/var/lib/paperless/data";
        media = "${paperless-dir}/media";
        consume = "/var/lib/paperless/consume";
      };
    in
    {
      systemd.tmpfiles.settings = {
        postgres.${postgres-path}.d = { };
        paperless = {
          "${paperless-paths.data}".d.user = username;
          "${paperless-paths.media}".d.user = username;
          "${paperless-paths.consume}".d.user = username;
        };
      };

      virtualisation.oci-containers = {
        containers = {
          postgres = {
            image = "docker.io/library/postgres";
            environment = {
              "POSTGRES_DB" = "paperless";
              "POSTGRES_USER" = "paperless";
              "POSTGRES_PASSWORD" = "paperless";
            };
            ports = [ "8012:5432" ];
            volumes = [
              "${postgres-path}:/var/lib/postgresql/data"
            ];
          };

          # use `docker exec` to get into the paperless container and do the stuff there
          paperless = {
            image = "ghcr.io/paperless-ngx/paperless-ngx:latest";
            environment = {
              "PAPERLESS_DBHOST" = "paperless-postgres";
              "PAPERLESS_DBPORT" = 8012;
              "PAPERLESS_REDIS" = "redis://paperless-redis:8011";
            };
            ports = [ "8010:8000" ];
            volumes = [
              "${paperless-paths.data}:/usr/src/paperless/data"
              "${paperless-paths.media}:/usr/src/paperless/media"
              "${paperless-paths.consume}:/usr/src/paperless/consume"
            ];
            dependsOn = [
              "postgres"
              "paperless-redis"
            ];
          };

          paperless-redis = {
            image = "docker.io/library/redis";
            ports = [ "8011:6379" ];
          };
        };
      };
    };
}
