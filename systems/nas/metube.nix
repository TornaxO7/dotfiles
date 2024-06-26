{ ... }:
{
  config.virtualisation.oci-containers.containers.metube = {
    image = "ghcr.io/alexta69/metube";
    ports = [ "8200:8081" ];
    volumes = [ "/hdds/music/downloads:/downloads" ];
  };
}
