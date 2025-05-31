{ config, ... }:
let
  utils = import ../../../utils.nix;

  names = utils.createContainerNames "crowdsec" [ "server" "firewall-bouncer" ];

  binds = rec {
    data = "/var/lib/crowdsec/data";
    conf = "/etc/crowdsec";
    acquis = "${conf}/acquis.yaml";
  };

  user = config.virtualisation.oci-containers.containers.${names.containers.server}.user;
  group = config.virtualisation.oci-containers.containers.${names.containers.server}.group;
in
{
  systemd.tmpfiles.rules = [
    "d ${binds.data} 0750 ${user} ${group} -"
    "d ${binds.conf} 0750 ${user} ${group} -"
    "L+ ${binds.acquis} - - - - ${./acquis.yaml}"
  ];

  virtualisation.oci-containers.containers = {
    "${names.containers.server}" = {
      image = "crowdsecurity/crowdsec:latest";

      volumes = [
        "${binds.acquis}:/etc/crowdsec/acquis.yaml"
        "${binds.data}:/var/lib/crowdsec/data/"
        "${binds.conf}:/etc/crowdsec"
      ];
    };
  };
}
