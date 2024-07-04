{ ... }:
{
  config = {
    virtualisation.oci-containers.containers.microbin = {
      image = "docker.io/danielszabo99/microbin";
      ports = [ "8070:8080" ];
    };
  };
}
