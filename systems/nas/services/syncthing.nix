{ root-domain, ... }:
let
  domain = "syncthing.${root-domain}";
  port = 49204;
in
{
  services = {
    syncthing = {
      enable = true;
      user = "tornax";
      openDefaultPorts = true;
      guiAddress = "127.0.0.1:${toString port}";
      settings = {
        gui.insecureSkipHostcheck = true;
      };
    };

    traefik.dynamicConfigOptions.http = {
      routers.syncthing = {
        rule = "Host(`${domain}`)";
        service = "syncthing";
      };
      services.syncthing.loadbalancer.servers = [
        {
          url = "http://127.0.0.1:${toString port}";
        }
      ];
    };
  };
}
