port: { ... }:
let
  portStr = toString port;
in
{
  config = {
    virtualisation.oci-containers.containers.microbin = {
      image = "docker.io/danielszabo99/microbin";
      ports = [ "${portStr}:8080" ];
    };
  };
}
