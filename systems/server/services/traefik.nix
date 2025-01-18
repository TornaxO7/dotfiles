utils: { config, services-root, domain-root, ts-ip, ip4, ... }:
let
  domain = "traefik.${domain-root}";

  root-path = "${services-root}/traefik";

  ports = {
    https = 443;
  };
in
{
  networking.firewall = {
    allowedTCPPorts = builtins.attrValues ports;
  };

  services.traefik = {
    enable = true;
    dataDir = root-path;
    group = "podman";

    staticConfigOptions = {
      entryPoints = {
        https = {
          address = "${ip4}:${toString ports.https}";
          asDefault = true;
          http = {
            tls.certResolver = "main";
          };
        };
      };

      api = {
        dashboard = true;
        insecure = false;
      };

      providers.docker = {
        endpoint = "unix:///var/run/podman/podman.sock";
        exposedByDefault = false;
      };

      certificatesResolvers.main.acme = {
        email = "postmaster@tornaxo7.de";
        storage = "${config.services.traefik.dataDir}/acme.json";
        tlsChallenge = { };
      };
    };

    dynamicConfigOptions =
      let
        dashboard-middleware = "dashboard-auth";
      in
      {
        http = {
          routers.dashboard = {
            rule = "Host(`${domain}`)";
            service = "api@internal";
            middlewares = dashboard-middleware;
          };

          middlewares = {
            ${dashboard-middleware}.digestauth.users = "tornax:traefik:6080745fca78301e72297e62cf416a3b";
          };
        };
      };
  };
}
