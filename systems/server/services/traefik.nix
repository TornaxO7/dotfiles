_utils: { config, services-root, unstable, domain-root, ts-ip, ip4, pkgs, ... }:
let
  domain = "traefik.${domain-root}";

  root-path = "${services-root}/traefik";

  ports = {
    http = 80;
    https = 443;
  };
in
{
  networking.firewall = {
    allowedTCPPorts = builtins.attrValues ports;
  };

  systemd.services.traefik = {
    requires = [ "crowdsec.service" ];
    serviceConfig = {
      WorkingDirectory = root-path;
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 10s";
    };
  };

  services.traefik = {
    enable = true;
    dataDir = root-path;
    # need to be able to access the podman socket
    group = "podman";

    staticConfigOptions = {
      entryPoints = {
        http = {
          address = "${ip4}:${toString ports.http}";

          forwardedHeaders.insecure = false;

          http.redirections.entryPoint = {
            to = "https";
            scheme = "https";
          };
        };

        https = {
          address = "${ip4}:${toString ports.https}";
          asDefault = true;

          forwardedHeaders.insecure = false;

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
        email = "postmaster@${domain-root}";
        storage = "${config.services.traefik.dataDir}/acme.json";
        tlsChallenge = { };
      };

      experimental.plugins.crowdsec-bouncer-traefik-plugin = {
        moduleName = "github.com/maxlerebourg/crowdsec-bouncer-traefik-plugin";
        version = "v1.4.2";
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
            middlewares = [
              dashboard-middleware
            ];
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
