utils: { config, services-root, domain-root, ... }:
let
  # ZFS
  bind-root = "${services-root}/stalwart";

  names = utils.createContainerNames "stalwart" [ "server" ];

  services = {
    smtp = "stallwart-smtp";
    smtps = "stallwart-smtps";
    imaps = "stallwart-imaps";
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
      ];

      labels = {
        "traefik.enable" = "true";

        # smtp
        "traefik.tcp.routers.${services.smtp}.rule" = "HostSNI(`*`)";
        "traefik.tcp.routers.${services.smtp}.entrypoints" = "smtp";
        "traefik.tcp.routers.${services.smtp}.service" = "${services.smtp}";
        "traefik.tcp.services.${services.smtp}.loadbalancer.server.port" = "25";

        # smtps
        "traefik.tcp.routers.${services.smtps}.rule" = "HostSNI(`${domain}`)";
        "traefik.tcp.routers.${services.smtps}.entrypoints" = "smtps";
        "traefik.tcp.routers.${services.smtps}.service" = "${services.smtps}";
        "traefik.tcp.services.${services.smtps}.loadbalancer.server.port" = "25";
        "traefik.tcp.routers.${services.smtps}.tls" = "true";
        "traefik.tcp.routers.${services.smtps}.tls.certresolver" = "main";

        # imaps
        "traefik.tcp.routers.${services.imaps}.rule" = "HostSNI(`${domain}`)";
        "traefik.tcp.routers.${services.imaps}.entrypoints" = "imaps";
        "traefik.tcp.routers.${services.imaps}.service" = "${services.imaps}";
        "traefik.tcp.services.${services.imaps}.loadbalancer.server.port" = "143";
        "traefik.tcp.routers.${services.imaps}.tls" = "true";
        "traefik.tcp.routers.${services.imaps}.tls.certresolver" = "main";

        # https
        "traefik.http.routers.${services.https}.rule" = "Host(`${domain}`)";
        "traefik.http.routers.${services.https}.service" = "${services.https}";
        "traefik.http.services.${services.https}.loadbalancer.server.port" = "8080";
        "traefik.http.routers.${services.https}.tls" = "true";
        "traefik.http.routers.${services.https}.tls.certresolver" = "main";
      };
    };
  };
}
