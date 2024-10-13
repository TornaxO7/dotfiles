{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./services/traefik.nix
  ];

  config = {
    security.sudo-rs.extraRules = [
      {
        users = [ "colmena" ];
        commands = [ "ALL" ];
        options = [ "NOPASSWD" ];
      }
    ];

    users = {
      groups.colmena = { };
      users.colmena = {
        password = null;
        openssh.authorizedKeys.keys = config.users.users.tornax.openssh.authorizedKeys.keys;
        isSystemUser = true;
      };
    };

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
