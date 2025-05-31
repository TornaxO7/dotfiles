{ pkgs, ... }:
let
  utils = import ../../../utils.nix;

  names = utils.createContainerNames "crowdsec" [ "server" "firewall-bouncer" ];

  binds = rec {
    data = "/var/lib/crowdsec/data";
    conf = "/etc/crowdsec";
    acquis = "${conf}/acquis.d";
  };

  network = "crowdsec";
in
{
  systemd = {
    services.create-crowdsec-network = utils.createPodmanNetworkService pkgs network (builtins.attrValues names.service-full);

    tmpfiles.rules = [
      "d ${binds.data} 0750 - - -"
      "d ${binds.conf} 0750 - - -"
      "L+ ${binds.acquis} - - - - ${./acquis.d}"
    ];
  };

  virtualisation.oci-containers.containers = {
    "${names.containers.server}" = {
      image = "crowdsecurity/crowdsec:latest-debian";

      volumes = [
        "${binds.acquis}:/etc/crowdsec/acquis.d"
        "${binds.data}:/var/lib/crowdsec/data/"
        "${binds.conf}:/etc/crowdsec"

        # required for journalctl
        "/var/log/journal:/run/log/journal"
      ];

      environment = {
        COLLECTIONS = "crowdsecurity/linux\
          crowdsecurity/traefik\
          LePresidente/grafana
        ";
      };

      networks = [ network ];
    };

    "${names.containers.firewall-bouncer}" = {
      image = "ghcr.io/shgew/cs-firewall-bouncer-docker:latest";
      extraOptions = [ "--network=host" ];
      capabilities = {
        NET_ADMIN = true;
        NET_RAW = true;
      };

      volumes = [
        "/etc/localtime:/etc/localtime:ro"
      ];

      networks = [ network ];
    };
  };
}
