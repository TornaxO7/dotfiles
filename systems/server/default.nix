{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./services/traefik.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      podman
      podman-compose
    ];

    services.openssh.settings.PasswordAuthentication = false;

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
