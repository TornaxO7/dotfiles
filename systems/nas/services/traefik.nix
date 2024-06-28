{ ... }:
{
  config = {
    virtualisation.oci-containers.containers.traefik = {
      image = "docker.io/traefik:latest";
      ports = [
        "80:80"
        "8080:8080"
      ];
      cmd = [
        "--api.insecure=true"
        "--providers.docker"
        "--log.level=debug"
      ];
      volumes = [
        "/run/user/1000/podman/podman.sock:/var/run/docker.sock"
      ];
    };

    # services.traefik = {
    #   enable = true;
    #   staticConfigOptions = {
    #     entryPoints = {
    #       http = {
    #         address = ":80";
    #       };
    #       web = {
    #         address = ":8080";
    #       };
    #     };
    #   };
    # };
  };
}
