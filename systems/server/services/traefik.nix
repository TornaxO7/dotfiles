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
            # middlewares = "my-fail2ban";
          };
        };

        # ts-https = {
        #   address = "${ts-ip}:${toString ports.https}";
        #   http.tls.certResolver = "main";
        # };
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

      # experimental.plugins = {
      #   fail2ban = {
      #     moduleName = "github.com/tomMoulard/fail2ban";
      #     version = "v0.8.3";
      #   };
      # };
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

            # my-fail2ban.plugin.fail2ban.rules = {
            #   bantime = "6h";
            #   enabled = true;
            #   findtime = "10m";
            #   maxretry = "5";
            #   statuscode = "400,401,403-499";
            # };
          };
        };
      };
  };
}
