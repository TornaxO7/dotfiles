{ ... }:
{
  config = {
    virtualisation.oci-containers.containers.glances = {
      image = "docker.io/nicolargo/glances:latest-full";
      volumes = [
        "/run/user/1000/podman/podman.sock:/run/user/1000/podman/podman.sock:ro"
      ];
      ports = [
        "61208:61208"
      ];
      environment = {
        "GLANCES_OPT" = "-w";
        "TZ" = "Europe/Berlin";
      };
      extraOptions = [
        "--network=host"
        "--privileged"
      ];
    };
  };
}
