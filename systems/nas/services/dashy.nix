{ username, ... }:
let
  utils = import ../utils.nix;

  dashy-path = "/hdds/dashy";
in
{
  config = {
    systemd.tmpfiles.settings.dashy = utils.createDirs username [ dashy-path ];

    virtualisation.oci-containers.containers.dashy = {
      image = "docker.io/lissy93/dashy";
      ports = [ "8000:8080" ];
      volumes = [
        # CHECK: create the file!
        "${dashy-path}:/app/user-data"
      ];
    };
  };
}
