{ config, root-domain, ... }:
let
  port = 49191;
  domain = "anubis.${root-domain}";
in
{
  services = {
    anubis = {
      defaultOptions = {
        settings = {
          WEBMASTER_EMAIL = "tornax@pm.me";
          DIFFICULTY = 6;
        };

        botPolicy = {
          bots = [
            { import = "(data)/meta/default-config.yaml"; }
          ];

          dnsbl = false;

          impressum = {
            footer = ''
              This website is hosted by TornaxO7. If you have any complaints or notes 
              about the service,
              please contact <a href="mailto:tornax@pm.me">tornax@pm.me</a> and we will assist you as soon as possible.
            '';
            page = {
              title = "Imprint and Privacy Policy";
              body = ''
                <h2>Information that is gathered from visitors</h2>
                <p>In common with other websites, log files are stored on the web server saving details such as the visitor's IP address, browser type, referring page and time of visit.</p>
                <p>Cookies may be used to remember visitor preferences when interacting with the website.</p>
              '';
            };
          };

          openGraph.enabled = false;

          status_codes = {
            CHALLENGE = 403;
            DENY = 403;
          };

          store.backend = "memory";

          thresholds = [
            {
              name = "no-suspicion";
              expression = "weight <= 0";
              action = "ALLOW";
            }
            {
              name = "mild-suspicion";
              expression.all = [
                # "weight >= 0"
                "weight < 10"
              ];
              action = "CHALLENGE";
              challenge = {
                algorithm = "fast";
                difficulty = 1;
              };
            }
            {
              name = "moderate-suspicion";
              expression.all = [
                "weight >= 10"
                "weight < 20"
              ];
              action = "CHALLENGE";
              challenge = {
                # https://anubis.techaro.lol/docs/admin/configuration/challenges/proof-of-work
                algorithm = "fast";
                difficulty = 2;
              };
            }
            {
              name = "mild-proof-of-work";
              expression.all = [
                "weight >= 20"
                "weight < 30"
              ];
              action = "CHALLENGE";
              challenge = {
                algorithm = "fast";
                difficulty = 4;
              };
            }
            {
              name = "extreme-suspicion";
              expression = "weight >= 30";
              action = "CHALLENGE";
              challenge = {
                algorithm = "fast";
                difficulty = 6;
              };
            }
          ];
        };
      };

      instances = {
        main = {
          enable = true;
          settings = {
            TARGET = " ";
            REDIRECT_DOMAINS = "*.${root-domain}";
            PUBLIC_URL = "https://${domain}";
            COOKIE_DOMAIN = root-domain;

            BIND_NETWORK = "tcp";
            BIND = "127.0.0.1:${builtins.toString port}";
          };
        };
      };
    };

    traefik = {
      staticConfigOptions.entryPoints.https.http.middlewares = "anubis@file";

      dynamicConfigOptions.http =
        let
          main = config.services.anubis.instances.main;

          anubis-url = "http://${main.settings.BIND}/.within.website/x/cmd/anubis/api/check";
        in
        {
          middlewares.anubis.forwardAuth.address = "${anubis-url}";

          routers.anubis = {
            rule = "Host(`${domain}`)";
            service = "anubis";
            middlewares = "";
          };

          services.anubis.loadbalancer.servers =
            [
              {
                url = "http://${main.settings.BIND}";
              }
            ];
        };
    };
  };
}
