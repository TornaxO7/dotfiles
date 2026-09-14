{ config, tld, wg0, ... }:
let
  domain = "traefik.${wg0.big.host}";

  root-path = "/var/lib/traefik";

  ports = {
    http = 80;
    https = 443;
  };
in
{
  networking.firewall.interfaces.wg0.allowedTCPPorts = builtins.attrValues ports;

  age.secrets.traefik-dns = {
    owner = "traefik";
    file = ../../../secrets/traefik-dns-challenge.age;
  };

  systemd = {
    tmpfiles.rules = [
      "d ${root-path} 0750 traefik traefik -"
      "d ${root-path}/certs 0750 traefik traefik -"
    ];
  };

  # so that plugins can be stored
  systemd.services.traefik.serviceConfig.WorkingDirectory = config.services.traefik.dataDir;

  services.traefik = {
    enable = true;
    dataDir = root-path;
    # need to be able to access the podman socket
    group = "podman";

    environmentFiles = [
      config.age.secrets.traefik-dns.path
    ];

    staticConfigOptions = {
      entryPoints = {
        http = {
          address = "${wg0.big.addr}:${toString ports.http}";
          http.redirections.entryPoint = {
            to = "https";
            scheme = "https";
          };
        };

        https = {
          address = "${wg0.big.addr}:${toString ports.https}";
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
        email = "tornax@pm.me";
        storage = "${config.services.traefik.dataDir}/acme.json";
        dnsChallenge = {
          provider = "netcup";
          resolvers = [
            "second-dns.netcup.net"
            "root-dns.netcup.net"
            "third-dns.netcup.net"
          ];
        };
      };
    };

    dynamicConfigOptions = {
      http = {
        middlewares = {
          tornax07-redirect-to-tornaxo7 = {
            redirectRegex = {
              regex = "^https://(.*)tornax07.de/(.*)";
              replacement = "https://\${1}${tld}\${2}";
            };
          };
        };

        routers.dashboard = {
          entryPoints = [ "https" ];
          rule = "Host(`${domain}`)";
          service = "api@internal";
        };
      };
    };
  };
}
