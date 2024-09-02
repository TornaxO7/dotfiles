_port: { pkgs, ... }:
{
  systemd.services.wger = {
    description = "Wger docker service";
    path = with pkgs; [ podman-compose podman ];
    wantedBy = [ "multi-user.target" ];
    requires = [ "podman.socket" ];
    serviceConfig = {
      ExecStart = "${pkgs.podman-compose}/bin/podman-compose up";
      WorkingDirectory = "/home/tornax/wger";
    };
  };
}
