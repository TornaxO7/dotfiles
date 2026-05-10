{ config, pkgs, ... }:
{
  # disabledModules = [ "services/security/crowdsec.nix" ];

  imports = [
    ./hardware-configuration.nix
    ./wireguard.nix
    ./home
    # ./crowdsec.nix

    ../../modules/default_main.nix
    ../../modules/desktop/default.nix
    ../../modules/desktop/xorg/default.nix
    ../../modules/desktop/wayland/cosmic.nix
    ../../modules/game/steam.nix
    ../../modules/yubikey.nix
    ../../modules/udev_moonlander_rules.nix
    ../../modules/kdeconnect.nix
  ];

  config = {
    services = {
      displayManager = {
        defaultSession = "cosmic";
        autoLogin = {
          enable = true;
          user = config.users.users.tornax.name;
        };
      };

      # crowdsec = {
      #   enable = true;
      #   package = pkgs.callPackage (import ./crowdsec-package.nix) { };
      # };
    };

    documentation.dev.enable = true;

    environment = {
      systemPackages = with pkgs; [
      ];
    };

    programs = {
      ausweisapp = {
        enable = true;
        openFirewall = true;
      };
    };

    virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vboxusers.members = [ config.users.users.tornax.name ];

    boot.initrd.kernelModules = [ "amdgpu" ];
    services = {
      xserver.videoDrivers = [ "amdgpu" ];
    };

    hardware.graphics.enable = true;

    networking = {
      networkmanager.enable = false;
      interfaces.enp6s0.wakeOnLan.enable = true;
    };
  };
}
