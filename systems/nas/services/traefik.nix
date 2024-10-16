{ config, ... }:
let
  username = config.users.users.main.name;
  dynConfFilePath = "/dynamicConfigFile.yml";
  dynConfFilePath2 = "/dynamicConfigFile2.yml";
in
{
  virtualisation.oci-containers.containers.traefik = {
    image = "traefik:v3.1";
    cmd = [
      "--api.dashboard=true"
      "--providers.docker=true"
      "--providers.docker.exposedbydefault=false"
      "--entryPoints.http.address=:80"
      # "--providers.file.filename=${dynConfFilePath}"
      "--providers.file.filename=${dynConfFilePath2}"
    ];

    extraOptions = [
      "--hostuser=${username}"
    ];

    ports = [
      "80:80"
    ];

    volumes = [
      "/var/run/podman/podman.sock:/var/run/docker.sock"
      # "${config.age.secrets.traefik-dynamicConfigFile.path}:${dynConfFilePath}"
      "${./traefik.yml}:${dynConfFilePath2}"
    ];
  };
}
