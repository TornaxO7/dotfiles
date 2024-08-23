{ username, ... }:
let
  utils = import ../utils.nix;

  filebrowser-root = "/hdds/filebrowser";

  database-path = "${filebrowser-root}/filebrowser.db";
in
{
  config = {
    systemd.tmpfiles.settings.filebrowser = utils.createDirs username [ database-path ];

    virtualisation.oci-containers.containers.filebrowser = {
      image = "filebrowser/filebrowser";
      ports = [ "8060:80" ];
      volumes = [
        "/hdds/syncthing:/srv"
        "${database-path}:/database/filebrowser.db"
      ];
    };
  };
}
