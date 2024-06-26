{ ... }:
{
  config = {
    virtualisation.oci-containers.containers.atomic-server = {
      image = "joepmeneer/atomic-server";
      ports = [ "8100:80" ];
      volumes = [
        "/var/lib/atomic-server:/atomic-server"
      ];
    };
  };
}
