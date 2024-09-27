{ username, zpool-root, pkgs, ... }:
let
  utils = import ../utils.nix;

  dashy-path = "${zpool-root}/dashy";

  network-name = "dashy-network";

  dashy-service = "podman-dashy.service";
  glances-service = "podman-glances.service";
in
{
  config = {
    systemd = {
      tmpfiles.settings.dashy = utils.createDirs username [ dashy-path ];
      services = {
        create-dashy-network = utils.createPodmanNetworkService pkgs network-name [ dashy-service glances-service ];
      };
    };

    virtualisation.oci-containers.containers = {
      dashy = {
        image = "docker.io/lissy93/dashy";
        volumes = [
          "${dashy-path}:/app/user-data"
        ];
        extraOptions = [ "--network=${network-name}" ];
      };

      glances = {
        image = "nicolargo/glances:latest";
        volumes = [
          "/var/run/podman/podman.sock:/var/run/docker.sock"
          "/etc/os-release:/etc/os-release:ro"
        ];
        environment = {
          "GLANCES_OPT" = "-w --disable-webui";
        };
        extraOptions = [ "--network=${network-name}" ];
      };
    };
  };
}
