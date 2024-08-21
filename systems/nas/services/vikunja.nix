{ ... }:
{
  config = {
    virtualisation.oci-containers.containers.vikunja = {
      image = "docker.io/vikunja/vikunja";
      ports = [ "8080:3456" ];
      volumes = [
        # CHECK: create the file!
        "/hdds/vikunja/db:/db"
        "/hdds/vikunja/files:/app/vikunja/files"
      ];
    };
  };
}
