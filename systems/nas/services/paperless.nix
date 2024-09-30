{ lib, username, pkgs, zpool-name, zpool-root, ... }:
let
  utils = import ../utils.nix;

  paperless-dir = "${zpool-root}/paperless";

  postgres-path = "/var/lib/postgresql/data";
  paperless-paths = {
    data = "${paperless-dir}/data";
    media = "${paperless-dir}/media";
    consume = "/var/lib/paperless/consume";
  };

  container-names = utils.createContainerNames "paperless" [ "server" "postgres" "redis" ];
  service-prefixes = builtins.mapAttrs (name: value: "podman-${value}") container-names;
  service-full-names = builtins.mapAttrs (name: value: "${value}.service") service-prefixes;

  network-name = "paperless-network";
in
{
  config = {
    systemd = lib.attrsets.recursiveUpdate
      {
        tmpfiles.settings = {
          "${container-names.postgres}" = utils.createDirs username [ postgres-path ];
          "${container-names.server}" = utils.createDirs username (builtins.attrValues paperless-paths);
        };

        services = {
          create-paperless-network = utils.createPodmanNetworkService pkgs network-name (builtins.attrValues service-full-names);

          # make sure that whenever a service gets restarted, everything gets correctly restarted
          "${service-prefixes.server}".requires = with service-full-names; [ postgres redis ];
          "${service-prefixes.postgres}".requires = with service-full-names; [ redis ];
        };
      }
      (utils.createSystemdZfsSnapshot pkgs "paperless" "${zpool-name}/paperless");


    virtualisation.oci-containers = {
      containers = {
        "${container-names.server}" = {
          image = "ghcr.io/paperless-ngx/paperless-ngx:latest";
          environment = {
            PAPERLESS_DBHOST = "${container-names.postgres}";
            PAPERLESS_REDIS = "redis://${container-names.redis}:6379";
            PAPERLESS_OCR_USER_ARGS = "{\"continue_on_soft_render_error\": true}";
          };
          volumes = [
            "${paperless-paths.data}:/usr/src/paperless/data"
            "${paperless-paths.media}:/usr/src/paperless/media"
            "${paperless-paths.consume}:/usr/src/paperless/consume"
          ];
          extraOptions = [ "--network=${network-name}" ];

          labels = {
            "traefik.enable" = "true";
            "traefik.http.routers.paperelss.rule" = "Host(`paperless.local`)";
            "traefik.http.routers.paperelss.service" = "paperelss";
            "traefik.http.services.paperelss.loadbalancer.server.port" = toString 8000;
          };
        };

        "${container-names.redis}" = {
          image = "docker.io/library/redis:7";
          extraOptions = [ "--network=${network-name}" ];
        };

        "${container-names.postgres}" = {
          image = "docker.io/library/postgres:16";
          environment = {
            "POSTGRES_DB" = "paperless";
            "POSTGRES_USER" = "paperless";
            "POSTGRES_PASSWORD" = "paperless";
          };
          extraOptions = [ "--network=${network-name}" ];
          volumes = [
            "${postgres-path}:/var/lib/postgresql/data"
          ];
        };
      };
    };
  };
}

