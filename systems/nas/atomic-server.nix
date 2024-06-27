{ username, ... }:
let
  atomic-server-dir = "/hdds/atomic-server";
in
{
  config = {
    systemd.tmpfiles.settings.atomic-server = {
      "${atomic-server-dir}".d.user = username;
    };

    virtualisation.oci-containers.containers.atomic-server = {
      image = "joepmeneer/atomic-server";
      ports = [ "8100:80" ];
      volumes = [
        "/hdds/atomic-server:/atomic-server"
      ];
    };
  };
}
