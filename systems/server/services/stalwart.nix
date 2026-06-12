{ root-domain, wg0, ... }:
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

  domain = "mail.${root-domain}";
  vpn-domain = "mail.${wg0.server.host}";
in
{
  networking.firewall.allowedTCPPorts = builtins.attrValues ports;

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
    stalwart = {
      image = "stalwartlabs/stalwart:v0.16";
      volumes = [
        "stalwart-etc:/etc/stalwart"
        "stalwart-data:/var/lib/stalwart"

        "/etc/localtime:/etc/localtime:ro"
      ];

      environment = {
        STALWART_PUBLIC_URL = "https://${domain}";
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
        "traefik.tcp.routers.${services.smtps}.service" = "${services.smtp}";
        # "traefik.tcp.routers.${services.smtps}.service" = "${services.smtps}";
        # "traefik.tcp.services.${services.smtps}.loadbalancer.server.port" = "465";
        "traefik.tcp.services.${services.smtps}.loadbalancer.proxyProtocol.version" = "2";
        # "traefik.tcp.routers.${services.smtps}.tls.passthrough" = "true";

        # jmap
        "traefik.tcp.routers.${services.jmaps}.rule" = "HostSNI(`*`)";
        "traefik.tcp.routers.${services.jmaps}.entrypoints" = "https";
        "traefik.tcp.routers.${services.jmaps}.service" = "${services.jmaps}";
        "traefik.tcp.services.${services.jmaps}.loadbalancer.server.port" = "8080";
        # "traefik.tcp.services.${services.jmaps}.loadbalancer.server.port" = "443";
        "traefik.tcp.services.${services.jmaps}.loadbalancer.proxyProtocol.version" = "2";
        # "traefik.tcp.routers.${services.jmaps}.tls.passthrough" = "true";

        # vpn http
        "traefik.http.routers.${services.vpn}.rule" = "Host(`${vpn-domain}`) || Host(`autodiscover.${vpn-domain}`) || Host(`autoconfig.${vpn-domain}`)";
        "traefik.http.routers.${services.vpn}.entrypoints" = "http-vpn";
        "traefik.http.routers.${services.vpn}.service" = "${services.http}";

        # https
        # "traefik.http.routers.${services.http}.rule" = "(Host(`${domain}`) && !PathPrefix(`/vpn`)) || Host(`autodiscover.${root-domain}`) || Host(`autoconfig.${root-domain}`) || Host(`mta-sts.${root-domain}`)";
        "traefik.http.routers.${services.http}.rule" = "Host(`mta-sts.${root-domain}`)";
        "traefik.http.routers.${services.http}.entrypoints" = "https";
        "traefik.http.routers.${services.http}.service" = "${services.http}";
        "traefik.http.services.${services.http}.loadbalancer.server.port" = "8080";
      };
    };
  };
}
