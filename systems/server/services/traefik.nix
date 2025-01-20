utils: { config, services-root, unstable, domain-root, ts-ip, ip4, ... }:
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

  systemd.services.traefik.serviceConfig = {
    WorkingDirectory = root-path;
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
            middlewares = [ "crowdsec@file" ];
          };
        };
      };

      log = {
        # filepath = "${root-path}/traefik.log";
        level = "WARN";
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

      experimental.plugins.crowdsec-bouncer-traefik-plugin = {
        moduleName = "github.com/maxlerebourg/crowdsec-bouncer-traefik-plugin";
        version = "v1.3.5";
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
            crowdsec.plugin.crowdsec-bouncer-traefik-plugin = {
              CrowdsecMode = "stream";
              CrowdsecLapiScheme = "http";
              CrowdsecLapiHost = "127.0.0.1:8080";
              CrowdsecLapiKey = "h5naEQ8J73qF52uuzqdfAf9fhWfT53tJktpYqczkNYDJvnkxnMpEKx9EdVrcx7SL";
              ClientTrustedIPs = [
                "100.64.0.0/10"
                "fd7a:115c:a1e0::/48"
              ];
              Enabled = true;
            };
          };
        };
      };
  };
}
