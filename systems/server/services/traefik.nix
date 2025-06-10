{ config, domain-root, ... }:
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
          address = ":${toString ports.http}";
          http.redirections.entryPoint = {
            to = "https";
            scheme = "https";
          };
        };

        https = {
          address = ":${toString ports.https}";
          forwardedHeaders = {
            insecure = false;
          };
          http = {
            tls.certResolver = "main";
          };
        };
      };

      log = {
        # filepath = "${root-path}/traefik.log";
        level = "INFO";
      };

      accessLog = { };

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
