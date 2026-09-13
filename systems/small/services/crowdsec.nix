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
        console = {
          enrollKeyFile = config.age.secrets.crowdsec-enrollkey.path;
        };
      };
    };

    crowdsec-firewall-bouncer = {
      enable = true;
    };
  };
}
