{ pkgs, ... }:
let
  utils = import ../../../utils.nix;

  names = utils.createContainerNames "crowdsec" [ "server" "firewall-bouncer" ];

  binds = rec {
    data = "/var/lib/crowdsec/data";
    conf = "/etc/crowdsec";
    acquis = "${conf}/acquis.d";
  };

  ports = {
    server = 49180;
  };
in
{
  systemd = {
    tmpfiles.rules = [
      "d ${binds.data} 0750 - - -"
      "d ${binds.conf} 0750 - - -"
    ];
  };

  systemd.services.traefik = {
    requires = [ names.service-full.server ];
    serviceConfig = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3s";
    };
  };

  services = {
    traefik = {
      staticConfigOptions = {
        experimental.plugins.crowdsec-bouncer-traefik-plugin = {
          moduleName = "github.com/maxlerebourg/crowdsec-bouncer-traefik-plugin";
          version = "v1.4.2";
        };

        entryPoints.https.http.middlewares = [ "crowdsec@file" ];
      };
      dynamicConfigOptions.http.middlewares = {
        crowdsec.plugin.crowdsec-bouncer-traefik-plugin = {
          CrowdsecMode = "stream";
          CrowdsecLapiScheme = "http";
          CrowdsecLapiHost = "127.0.0.1:${toString ports.server}";
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

  virtualisation.oci-containers.containers = {
    "${names.containers.server}" = {
      image = "crowdsecurity/crowdsec:latest-debian";

      volumes = [
        "${./acquis.d}:/etc/crowdsec/acquis.d"
        "${binds.data}:/var/lib/crowdsec/data/"
        "${binds.conf}:/etc/crowdsec"

        # required for journalctl
        "/var/log/journal:/run/log/journal:ro"
      ];

      environment = {
        COLLECTIONS = "\
            crowdsecurity/linux\
            crowdsecurity/iptables\
            crowdsecurity/traefik\
            crowdsecurity/http-dos\
            crowdsecurity/http-cve\

            LePresidente/grafana\
            LePresidente/authelia\
          ";
      };

      ports = [
        "127.0.0.1:${toString ports.server}:8080"
      ];
    };

    "${names.containers.firewall-bouncer}" = {
      image = "ghcr.io/shgew/cs-firewall-bouncer-docker:latest";
      extraOptions = [ "--network=host" ];
      capabilities = {
        NET_ADMIN = true;
        NET_RAW = true;
      };

      environment = {
        API_URL = "http://127.0.0.1:${toString ports.server}";
        API_KEY = "o5Nk+Zoq0RacZraYClZdaEJlItKrBbXhyOl/yygavl4";
      };

      volumes = [
        "${./crowdsec-firewall-bouncer.yaml}:/config/crowdsec-firewall-bouncer.yaml:ro"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };
  };
}
