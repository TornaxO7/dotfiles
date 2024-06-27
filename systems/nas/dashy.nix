{ ... }:
{
  config.virtualisation.oci-containers.containers.dashy = {
    image = "docker.io/lissy93/dashy";
    ports = [ "8400:8080" ];
    volumes = [
      # CHECK: create the file!
      "/hdds/dashy:/app/user-data"
    ];
  };
}
