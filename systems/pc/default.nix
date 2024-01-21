{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    services.xserver = {
      displayManager = {
        defaultSession = "none+i3";
        autoLogin = {
          enable = true;
          user = "tornax";
        };
      };
    };

    boot.initrd.kernelModules = [ "amdgpu" ];

    hardware.opengl.driSupport = true;

    networking = {
      networkmanager.enable = false;
      hostName = "pc";
      interfaces.enp6s0.wakeOnLan.enable = true;
    };

    services.printing.enable = true;

    virtualisation.podman.enable = true;
  };
}
