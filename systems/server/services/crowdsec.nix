utils:
{ lib, domain-root, services-root, ... }:
let
  prefix = "crowdsec";
  domain = "${prefix}.${domain-root}";

  collections = lib.strings.concatStringsSep " " [
    "crowdsecurity/linux"
    "crowdsecurity/iptables"
  ];

  binds = rec {
    root = "${services-root}/crowdsec";

    acquisitions = "${root}/acquis.d";
  };

  volumes = {
    config = "${prefix}-config";
    db = "${prefix}-db";
  };
in
{
  systemd.tmpfiles.settings = {
    crowdsec = utils.createDirsWith "root" (builtins.attrValues binds);
  };

  virtualisation.oci-containers.containers.crowdsec = {
    image = "crowdsecurity/crowdsec:latest-debian";
    environment = {
      COLLECTIONS = collections;
    };

    labels = {
      "traefik.enable" = "true";

      "traefik.http.routers.crowdsec.rule" = "Host(`${domain}`)";
      "traefik.http.routers.crowdsec.service" = "crowdsec";
      "traefik.services.crowdsec.loadbalancer.server.port" = "8080";
    };

    volumes = [
      # system logs
      "/var/log/journal:/run/log/journal"

      # crowdsec stuff
      "${volumes.config}:/etc/crowdsec"
      "${volumes.db}:/var/lib/crowdsec/data"
      "${binds.acquisitions}:/etc/crowdsec/acquis.d"
    ];
  };
}
