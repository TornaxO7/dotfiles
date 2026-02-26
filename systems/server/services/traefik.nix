{ config, root-domain, wg0, ip4, ip6, ... }:
let
  domain = "traefik.${wg0.server.host}";

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

        http-ip4 = {
          address = "${ip4}:${toString ports.http}";
          http.redirections.entryPoint = {
            to = "https";
            scheme = "https";
          };
        };

        http-ip6 = {
          address = "[${ip6}]:${toString ports.http}";
          http.redirections.entryPoint = {
            to = "https";
            scheme = "https";
          };
        };

        http-vpn = {
          address = "${wg0.server.addr}:${toString ports.http}";
        };

        https = {
          address = ":${toString ports.https}";
          asDefault = true;
          http = {
            tls.certResolver = "main";
            middlewares = "tornax07-redirect-to-tornaxo7@file";
          };
        };

      };

      log = {
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
        email = "postmaster@${root-domain}";
        storage = "${config.services.traefik.dataDir}/acme.json";
        tlsChallenge = { };
      };
    };

    dynamicConfigOptions = {
      http = {
        middlewares = {
          tornax07-redirect-to-tornaxo7 = {
            redirectRegex = {
              regex = "^https://(.*)tornax07.de/(.*)";
              replacement = "https://\${1}${root-domain}\${2}";
            };
          };
        };

        routers.dashboard = {
          entryPoints = [ "http-vpn" ];
          rule = "Host(`${domain}`)";
          service = "api@internal";
        };
      };
    };
  };
}
