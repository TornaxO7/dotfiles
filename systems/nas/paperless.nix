{ ... }:
# CHECK: Make sure that all volume directories exist!
let
  zpool-name = "hdds";
  zpool-root = "/${zpool-name}";
  paperless-dir = "${zpool-root}/paperless";
in
{
  config = {
    virtualisation.oci-containers = {
      containers = {
        postgres = {
          image = "docker.io/library/postgres";
          environment = {
            "POSTGRES_DB" = "paperless";
            "POSTGRES_USER" = "paperless";
            "POSTGRES_PASSWORD" = "paperless";
          };
          ports = [ "5432:5432" ];
          volumes = [
            "/var/lib/postgresql/data:/var/lib/postgresql/data"
          ];
        };

        # use `docker exec` to get into the paperless container and do the stuff there
        paperless = {
          image = "ghcr.io/paperless-ngx/paperless-ngx:latest";
          environment = {
            "PAPERLESS_DBHOST" = "postgres";
            "PAPERLESS_REDIS" = "redis://redis:6379";
          };
          ports = [ "8000:8000" ];
          volumes = [
            "/var/lib/paperless/data:/usr/src/paperless/data"
            "/${paperless-dir}/media:/usr/src/paperless/media"
            "/var/lib/paperless/consume:/usr/src/paperless/consume"
          ];
          dependsOn = [
            "postgres"
            "redis"
          ];
        };

        redis = {
          image = "docker.io/library/redis";
          ports = [ "6379:6379" ];
        };
      };
    };
  };
}
