port: { ... }:
let
  portStr = toString port;
in
{
  virtualisation.oci-containers.containers.localai = {
    image = "localai/localai:latest-aio-cpu";
    ports = [ "${portStr}:8080" ];
  };
}
