{ config, root-domain, wg0, ... }:
let
  services = {
    smtp = "stallwart-smtp";
    smtps = "stallwart-smtps";
    jmaps = "stallwart-jmaps";
    http = "stallwart-http";
    vpn = "stallwart-vpn";
  };

  ports = {
    smtp = 25;
    smtps = 465;
  };

  uid = 2000;

  domain = "mail.${root-domain}";
  vpn-domain = "mail.${wg0.server.host}";
in
{
  networking.firewall.allowedTCPPorts = builtins.attrValues ports;

  users = {
    users.stalwart = {
      isSystemUser = true;
      uid = uid;
      group = "stalwart";
    };

    groups.stalwart = { };
  };

  services.traefik.staticConfigOptions = {
    entryPoints = {
      smtp = {
        address = ":${builtins.toString ports.smtp}";
      };

      smtps = {
        address = ":${builtins.toString ports.smtps}";
        http = {
          tls.certResolver = "main";
        };
      };
    };
  };

  virtualisation.oci-containers.containers = {
    stalwart-traefik-certs-dumper = {
      image = "ghcr.io/kereis/traefik-certs-dumper:latest";
      volumes = [
        "${config.services.traefik.dataDir}:/traefik:ro"
        "stalwart-certs:/output:rw"
      ];
      environment = {
        DOMAIN = domain;
        OVERRIDE_UID = toString uid;
        OVERRIDE_GID = toString uid;
      };
    };

    stalwart = {
      image = "stalwartlabs/stalwart:v0.16";
      volumes = [
        "stalwart-etc:/etc/stalwart"
        "stalwart-data:/var/lib/stalwart"
        "stalwart-certs:/certs:ro"

        "/etc/localtime:/etc/localtime:ro"
      ];

      environment = {
        STALWART_PUBLIC_URL = "http://${vpn-domain}";
      };

      labels = {
        "traefik.enable" = "true";

        # smtp
        "traefik.tcp.routers.${services.smtp}.rule" = "HostSNI(`*`)";
        "traefik.tcp.routers.${services.smtp}.entrypoints" = "smtp";
        "traefik.tcp.routers.${services.smtp}.service" = "${services.smtp}";
        "traefik.tcp.services.${services.smtp}.loadbalancer.server.port" = "25";
        "traefik.tcp.services.${services.smtp}.loadbalancer.proxyProtocol.version" = "2";

        # smtps
        "traefik.tcp.routers.${services.smtps}.rule" = "HostSNI(`*`)";
        "traefik.tcp.routers.${services.smtps}.entrypoints" = "smtps";
        "traefik.tcp.routers.${services.smtps}.service" = "${services.smtps}";
        "traefik.tcp.routers.${services.smtps}.tls.passthrough" = "true";
        "traefik.tcp.services.${services.smtps}.loadbalancer.server.port" = "465";
        "traefik.tcp.services.${services.smtps}.loadbalancer.proxyProtocol.version" = "2";

        # jmap
        "traefik.tcp.routers.${services.jmaps}.rule" = "HostSNI(`*`)";
        "traefik.tcp.routers.${services.jmaps}.entrypoints" = "https";
        "traefik.tcp.routers.${services.jmaps}.service" = "${services.jmaps}";
        "traefik.tcp.routers.${services.jmaps}.tls.passthrough" = "true";
        "traefik.tcp.services.${services.jmaps}.loadbalancer.server.port" = "443";
        "traefik.tcp.services.${services.jmaps}.loadbalancer.proxyProtocol.version" = "2";

        # vpn http
        "traefik.http.routers.${services.vpn}.rule" = "Host(`${vpn-domain}`) || Host(`autodiscover.${vpn-domain}`) || Host(`autoconfig.${vpn-domain}`)";
        "traefik.http.routers.${services.vpn}.entrypoints" = "http-vpn";
        "traefik.http.routers.${services.vpn}.service" = "${services.http}";

        # https
        "traefik.http.routers.${services.http}.rule" = "Host(`mta-sts.${root-domain}`)";
        "traefik.http.routers.${services.http}.entrypoints" = "https";
        "traefik.http.routers.${services.http}.service" = "${services.http}";
        "traefik.http.services.${services.http}.loadbalancer.server.port" = "8080";
      };
    };
  };
}
