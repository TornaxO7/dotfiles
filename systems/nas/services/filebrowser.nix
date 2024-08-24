port: { username, zpool-root, ... }:
let
  portStr = toString port;

  filebrowser-root = "${zpool-root}/filebrowser";
  database-path = "${filebrowser-root}/database.db";
in
{
  config = {
    systemd.tmpfiles.settings.filebrowser.${database-path}.f.user = username;

    virtualisation.oci-containers.containers.filebrowser = {
      image = "filebrowser/filebrowser";
      ports = [ "${portStr}:80" ];
      volumes = [
        "${zpool-root}/syncthing:/srv"
        "${database-path}:/database.db"
      ];
    };
  };
}
