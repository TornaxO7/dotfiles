port: { config, zpool-root, ... }:
let
  portStr = toString port;
  gotifyRoot = "${zpool-root}/gotify";
in
{
  config = {
    virtualisation.oci-containers.containers.gotify = {
      image = "ghcr.io/gotify/server";
      ports = [ "${portStr}:80" ];
      volumes = [ "${gotifyRoot}:/app/data" ];
      environment = {
        TZ = config.time.timeZone;
      };
    };
  };
}
