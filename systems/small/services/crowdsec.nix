{ config, ... }:
{
  age.secrets.crowdsec-enrollkey = {
    owner = "crowdsec";
    file = ../../../secrets/crowdsec-enrollkey.age;
  };

  services = {
    crowdsec = {
      enable = true;

      hub = {
        collections = [
          "crowdsecurity/linux"
          "crowdsecurity/iptables"
          "crowdsecurity/traefik"
          "crowdsecurity/http-dos"
          "crowdsecurity/http-cve"
          "LePresidente/grafana"
          "LePresidente/authelia"
        ];

        parsers = [
          "crowdsecurity/whitelists"
        ];
      };

      settings = {
        config.api.server.online_client.credentials_path = "/var/lib/crowdsec/data/online_api_credentials.yaml";

        console = {
          enrollKeyFile = config.age.secrets.crowdsec-enrollkey.path;
        };

        acquisitions = [
          {
            journalctl_filter = [
              "_SYSTEMD_UNIT=traefik.service"
            ];
            labels = {
              type = "syslog";
            };
            source = "journalctl";
          }
          {
            journalctl_filter = [
              "_SYSTEMD_UNIT=sshd.service"
            ];
            labels = {
              type = "syslog";
            };
            source = "journalctl";
          }
        ];

      };
    };

    crowdsec-firewall-bouncer = {
      enable = true;
    };
  };
}
