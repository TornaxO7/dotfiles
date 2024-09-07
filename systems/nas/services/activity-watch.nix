port: { username, zpool-root, pkgs, ip-addr, ... }:
let
  portStr = toString port;

  # paths
  aw-root = "${zpool-root}/activity-watch";
  db-path = "${aw-root}/database.db";
in
{
  systemd = {
    services.aw-server = {
      description = "Activity Watch server";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.aw-server-rust}/bin/aw-server --host ${ip-addr} --port ${portStr} --dbpath ${db-path}";
      };
    };
  };
}
