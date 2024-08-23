{ pkgs, ... }:
{
  config = {
    systemd.services."glances" = {
      description = "Glances service https://github.com/nicolargo/glances";
      wants = [ "podman.socket" ];
      serviceConfig = {
        ExecStart = "${pkgs.glances}/bin/glances -w --disable-webui -p 49200";
      };
      environment = {
        TZ = "Europe/Berlin";
      };
    };
  };
}
