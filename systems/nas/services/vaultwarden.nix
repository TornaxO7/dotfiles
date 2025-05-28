utils: { domain-root, zpool-root, ... }:
let
  dir = "${zpool-root}/vaultwarden";
  domain = "vault.${domain-root}";

  names = utils.createContainerNames "vaultwarden" [ "server" ];
in
{
  config.virtualisation.oci-containers.containers.vaultwarden = {
    image = "vaultwarden/server:latest";
    environment = {
      DOMAIN = "http://${domain}";
    };

    volumes = [
      "${dir}:/data/"
    ];

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.${names.containers.server}.rule" = "Host(`${domain}`)";
      "traefik.http.routers.${names.containers.server}.service" = "${names.containers.server}";
      "traefik.http.services.${names.containers.server}.loadbalancer.server.port" = "80";
    };
  };
}
