{ config, domain-root, ip4, ... }:
let
  domain = "traefik.${domain-root}";

  root-path = "/var/lib/traefik";

  ports = {
    http = 80;
    https = 443;
  };
in
{
  networking.firewall.allowedTCPPorts = builtins.attrValues ports;

  systemd.tmpfiles.rules = [
    "d ${root-path} 0750 traefik traefik -"
  ];

  # so that plugins can be stored
  systemd.services.traefik.serviceConfig.WorkingDirectory = config.services.traefik.dataDir;

  services.traefik = {
    enable = true;
    dataDir = root-path;
    # need to be able to access the podman socket
    group = "podman";

    staticConfigOptions = {
      entryPoints = {
        http = {
          address = "${ip4}:${toString ports.http}";
          http.redirections.entryPoint = {
            to = "https";
            scheme = "https";
          };
        };

        https = {
          address = "${ip4}:${toString ports.https}";
          asDefault = true;
          forwardedHeaders = {
            # trustedIPs = [ ip4 ];
            insecure = false;
          };
          http = {
            tls.certResolver = "main";
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

    dynamicConfigOptions = {
      http = {
        routers.dashboard = {
          rule = "Host(`${domain}`)";
          service = "api@internal";
          middlewares = [
            "authelia"
          ];
        };
      };
    };
  };
}
