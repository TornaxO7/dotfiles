{ ... }:
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
    metrics = 49181;
  };

  # Things to consider:
  # 1. Edit the volume to journals of server
  # 2. Set the capacity in `/etc/crowdsec/scenarios`
in
{
  systemd = {
    tmpfiles.rules = [
      "d ${binds.data} 0750 - - -"
      "d ${binds.conf} 0750 - - -"
      "C+ ${binds.conf} - - - - ${./acquis.d}"
    ];
  };

  virtualisation.oci-containers.containers = {
    "${names.containers.server}" = {
      image = "crowdsecurity/crowdsec:latest-debian";

      volumes = [
        "${binds.data}:/var/lib/crowdsec/data/"
        "${binds.conf}:/etc/crowdsec"

        # required for journalctl
        "/var/log/journal/f9f3b607a52943eaa84719a6d6cd4d05:/run/log/journal:ro"
        # "/var/log/journal:/run/log/journal:ro"

        "/etc/localtime:/etc/localtime:ro"
      ];

      environment = {
        COLLECTIONS = "
          crowdsecurity/linux
          crowdsecurity/iptables
          crowdsecurity/traefik
          crowdsecurity/http-dos
          crowdsecurity/http-cve
          LePresidente/grafana
          LePresidente/authelia
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

