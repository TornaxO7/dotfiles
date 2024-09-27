{ username, pkgs, zpool-name, zpool-root, ... }:
let
  utils = import ../utils.nix;
in
{

  systemd = {
    tmpfiles.settings.syncthing = {
      "/var/lib/syncthing".d.user = username;
    };
  }
  //
  (utils.createSystemdZfsSnapshot pkgs "syncthing" "${zpool-name}/syncthing");

  virtualisation.oci-containers.containers.syncthing = {
    image = "syncthing/syncthing";
    hostname = "nas-syncthing";

    environment = {
      USER = "1000";
      GROUP = "1000";
    };

    volumes = [
      "/var/lib/syncthing:/var/syncthing"
      "${zpool-root}/syncthing:/sync-dir"
    ];

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.syncthing.rule" = "Host(`syncthing.local`)";
      "traefik.http.routers.syncthing.service" = "syncthing";
      "traefik.http.services.syncthing.loadbalancer.server.port" = toString 8384;
    };

    ports = [
      "22000:22000" # Sync protocol port
      "21027:21027/udp" # Local discovery port 
    ];
  };
}
