{ config, services-root, domain-root, ... }:
let
  username = config.users.users.main.name;

  acme-path = "${services-root}/acme.json";
  certs-path = "${services-root}/certs";

  domain = "traefik.${domain-root}";
in
{
  systemd = {
    tmpfiles.settings = {
      acme_file."${acme-path}".f = {
        user = username;
        mode = "0600";
      };
      certs-path."${certs-path}".d = {
        user = username;
        mode = "0600";
      };
    };
  };

  virtualisation.oci-containers.containers = {
    traefik = {
      image = "traefik:latest";
      cmd = [
        "--api=true"

        "--providers.docker=true"
        "--providers.docker.exposedbydefault=false"

        "--entryPoints.http.address=:80"
        "--entryPoints.https.address=:443"
        "--entryPoints.https.asDefault=true"

        # "--entryPoints.DoT.address=:853"

        # == mail
        # smtp
        # "--entryPoints.smtp.address=:25"
        # smtps
        # "--entryPoints.smtps.address=:465"
        # imaps
        # "--entryPoints.imaps.address=:993"

        "--certificatesresolvers.main.acme.email=tornax@tornaxo7.de"
        "--certificatesresolvers.main.acme.storage=acme.json"
        "--certificatesresolvers.main.acme.httpchallenge.entrypoint=http"
      ];

      extraOptions = [
        "--hostuser=${username}"
      ];

      ports = [
        "80:80"
        "443:443"

        # DoT
        # "853:853/tcp"

        # mail
        "25:25/tcp"
        "465:465/tcp"
        "993:993/tcp"
      ];

      volumes = [
        "/var/run/podman/podman.sock:/var/run/docker.sock"
        "${acme-path}:/acme.json"
        "/etc/passwd:/etc/passwd:ro"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.dashboard.rule" = "Host(`${domain}`)";
        "traefik.http.routers.dashboard.service" = "api@internal";
        "traefik.http.routers.dashboard.tls" = "true";
        "traefik.http.routers.dashboard.tls.certresolver" = "main";

        "traefik.http.routers.dashboard.middlewares" = "auth";
        "traefik.http.middlewares.auth.digestauth.users" = "tornax:traefik:6080745fca78301e72297e62cf416a3b";
      };
    };

    # traefik-certs-dumper = {
    #   image = "ghcr.io/kereis/traefik-certs-dumper:latest";
    #   dependsOn = [ "traefik" ];
    #   volumes = [
    #     "/etc/localtime:/etc/localtime:ro"
    #     "${acme-path}:/traefik/acme.json:ro"
    #     "${certs-path}:/output:rw"
    #   ];
    # };
  };
}
