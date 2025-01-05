utils: { config, services-root, domain-root, ... }:
let
  bind-root = "${services-root}/stalwart";

  names = utils.createContainerNames "stalwart" [ "server" ];

  services = {
    smtp = "stallwart-smtp";
    smtps = "stallwart-smtps";
    imaps = "stallwart-imaps";
    jmaps = "stallwart-jmaps";
    https = "stallwart-https";
  };

  domain = "mail.${domain-root}";
in
{
  systemd.tmpfiles.settings.stalwart = utils.createDirs config [ bind-root ];

  virtualisation.oci-containers.containers = {
    ${names.containers.server} = {
      image = "stalwartlabs/mail-server:latest";
      volumes = [
        "${bind-root}:/opt/stalwart-mail"
        "/services/certs:/data/certs:ro"
        "/etc/localtime:/etc/localtime:ro"
      ];

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
        "traefik.tcp.services.${services.smtps}.loadbalancer.server.port" = "465";
        "traefik.tcp.services.${services.smtps}.loadbalancer.proxyProtocol.version" = "2";
        "traefik.tcp.routers.${services.smtps}.tls.passthrough" = "true";

        # imaps
        "traefik.tcp.routers.${services.imaps}.rule" = "HostSNI(`*`)";
        "traefik.tcp.routers.${services.imaps}.entrypoints" = "imaps";
        "traefik.tcp.routers.${services.imaps}.service" = "${services.imaps}";
        "traefik.tcp.services.${services.imaps}.loadbalancer.server.port" = "993";
        "traefik.tcp.services.${services.imaps}.loadbalancer.proxyProtocol.version" = "2";
        "traefik.tcp.routers.${services.imaps}.tls.passthrough" = "true";

        # jmap
        "traefik.tcp.routers.${services.jmaps}.rule" = "HostSNI(`*`)";
        "traefik.tcp.routers.${services.jmaps}.entrypoints" = "https";
        "traefik.tcp.routers.${services.jmaps}.service" = "${services.jmaps}";
        "traefik.tcp.services.${services.jmaps}.loadbalancer.server.port" = "443";
        "traefik.tcp.services.${services.jmaps}.loadbalancer.proxyProtocol.version" = "2";
        "traefik.tcp.routers.${services.jmaps}.tls.passthrough" = "true";

        # https
        "traefik.http.routers.${services.https}.rule" = "Host(`${domain}`) || Host(`autodiscover.${domain-root}`) || Host(`autoconfig.${domain-root}`) || Host(`mta-sts.${domain-root}`)";
        "traefik.http.routers.${services.https}.entrypoints" = "https";
        "traefik.http.routers.${services.https}.service" = "${services.https}";
        "traefik.http.services.${services.https}.loadbalancer.server.port" = "8080";
        "traefik.http.routers.${services.https}.tls" = "true";
        "traefik.http.routers.${services.https}.tls.certresolver" = "main";
      };
    };
  };
}
