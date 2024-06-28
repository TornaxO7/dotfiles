{ username, ... }:
let
  importer-path = "/tmp/photoprism-importer";
in
{
  config = {
    systemd.tmpfiles.settings.photoprism = {
      "${importer-path}".d = {
        user = username;
        group = "photoprism";
        mode = "0775";
      };
    };

    services.photoprism = {
      enable = true;
      port = 8060;
      address = "100.88.51.57";

      originalsPath = "/hdds/photoprism/originals";

      settings = {
        PHOTOPRISM_ADMIN_USER = username;
        PHOTOPRISM_IMPORT_PATH = importer-path;
        PHOTOPRISM_ADMIN_PASSWORD = "password123";
        PHOTOPRISM_ORIGINALS_LIMIT = "-1";
        PHOTOPRISM_RESOLUTION_LIMIT = "-1";
        PHOTOPRISM_LOG_LEVEL = "debug";
        PHOTOPRISM_UPLOAD_NSFW = "1";
      };
    };
  };
}
