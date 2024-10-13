{ pkgs, modulesPath, ... }:
{
  imports = [
    ./services/traefik.nix

    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  config = {
    environment.systemPackages = with pkgs; [
      podman
      podman-compose
    ];

    networking = {
      networkmanager.enable = false;
    };

    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      oci-containers.backend = "podman";
    };
  };
}
