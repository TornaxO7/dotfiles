{ wg0, root-domain, ... }:
let
  domain = "traefik.${root-domain}";
in
{
  networking.firewall.allowedTCPPorts = [ 80 ];

  services.traefik = {
    enable = true;

    # need to be able to access the podman socket
    group = "podman";

    staticConfigOptions = {
      entryPoints.http.address = "${wg0.nas.addr}:80";

      api = {
        dashboard = true;
        insecure = true;
      };

      providers.docker = {
        endpoint = "unix:///var/run/podman/podman.sock";
        exposedByDefault = false;
      };
    };

    dynamicConfigOptions.http.routers.dashboard = {
      rule = "Host(`${domain}`)";
      service = "api@internal";
    };
  };
}
