utils: { config, services-root, domain-root, ... }:
let
  username = config.users.users.main.name;

  paths = rec {
    root = "${services-root}/traefik";
    acme = "${root}/acme.json";
    certs-dir = "${root}/certs";
  };

  domain = "traefik.${domain-root}";
in
{
  systemd = {
    tmpfiles.settings = {
      traefik-dirs = utils.createDirs config (with paths; [ root certs-dir ]);
      traefik-acme."${paths.acme}".f = {
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

        # mail
        # "25:25/tcp"
        # "465:465/tcp"
        # "993:993/tcp"
      ];

      volumes = [
        "/var/run/podman/podman.sock:/var/run/docker.sock"
        "${paths.acme}:/acme.json"
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
    #     "${paths.acme}:/traefik/acme.json:ro"
    #     "${paths.certs-dir}:/output:rw"
    #   ];
    # };
  };
}
