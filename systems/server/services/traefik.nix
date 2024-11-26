{ config, services-root, domain-root, ... }:
let
  username = config.users.users.main.name;

  acme-path = "${services-root}/acme.json";

  domain = "traefik.${domain-root}";
in
{
  systemd = {
    tmpfiles.settings.acme_file."${acme-path}".f = {
      user = username;
      mode = "0600";
    };
  };

  virtualisation.oci-containers.containers.traefik = {
    image = "traefik:latest";
    cmd = [
      "--api=true"

      "--providers.docker=true"
      "--providers.docker.exposedbydefault=false"

      "--entryPoints.http.address=:80"
      "--entryPoints.https.address=:443"
      "--entryPoints.https.asDefault=true"

      # required for headscale
      # "--entryPoints.headscale8080.address=:8080"
      # "--entryPoints.headscale8080.address=:9090"

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
}
