port: { config, username, zpool-root, unstable, ... }:
let
  utils = import ../utils.nix;
  portStr = toString port;

  glances-port = port + 1;
  glances-port-str = toString glances-port;

  dashy-path = "${zpool-root}/dashy";
in
{
  config = {
    systemd.tmpfiles.settings.dashy = utils.createDirs username [ dashy-path ];

    virtualisation.oci-containers.containers.dashy = {
      image = "docker.io/lissy93/dashy";
      ports = [ "${portStr}:8080" ];
      volumes = [
        "${dashy-path}:/app/user-data"
      ];
    };

    # glances
    systemd.services."glances" = {
      description = "Glances service https://github.com/nicolargo/glances";
      wants = [ "podman.socket" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${unstable.glances}/bin/glances -w --disable-webui -p ${glances-port-str}";
      };
      environment = {
        TZ = config.time.timeZone;
      };
    };
  };
}
