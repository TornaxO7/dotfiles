{ username, pkgs, ... }:
let
  utils = import ../utils.nix;

  zpool-name = "hdds";
  zpool-root = "/${zpool-name}";
  paperless-dataset = "${zpool-name}/paperless";
  paperless-dir = "${zpool-root}/paperless";

  postgres-path = "/var/lib/postgresql/data";
  paperless-paths = {
    data = "/var/lib/paperless/data";
    media = "${paperless-dir}/media";
    consume = "/var/lib/paperless/consume";
  };

  snapshotScriptName = "paperless-snapshot-script";
  createSnapshot = utils.createSnapshotScript pkgs snapshotScriptName paperless-dataset;
in
{
  config = {
    systemd.tmpfiles.settings = {
      postgres = utils.createDirs username [ postgres-path ];
      paperless = utils.createDirs username (builtins.attrValues paperless-paths);
    };

    # snapshots
    systemd = {
      services."paperless-zfs-snapshots" = {
        description = "ZFS Snapshot cretor for paperless dataset";
        serviceConfig = {
          ExecStart = "${pkgs.bash}/bin/bash ${createSnapshot}/bin/${snapshotScriptName}";
          Type = "oneshot";
        };
      };

      timers."paperless-zfs-snapshots-timer" = {
        description = "Create zfs snapshot for paperless";
        wants = [ "paperless-zfs-snapshots.service" ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
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
          ports = [ "5432:5432" ];
          volumes = [
            "${postgres-path}:/var/lib/postgresql/data"
          ];
        };

        # use `docker exec` to get into the paperless container and do the stuff there
        paperless = {
          image = "ghcr.io/paperless-ngx/paperless-ngx:latest";
          labels = {
            "traefik.http.routers.paperless.rule" = "Host(`paperless.docker`)";
          };
          environment = {
            "PAPERLESS_DBHOST" = "postgres";
            "PAPERLESS_REDIS" = "redis://redis:6379";
          };
          ports = [ "8010:8000" ];
          volumes = [
            "${paperless-paths.data}:/usr/src/paperless/data"
            "${paperless-paths.media}:/usr/src/paperless/media"
            "${paperless-paths.consume}:/usr/src/paperless/consume"
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
