{config, pkgs, lib, ...}:
{
  services.xserver = {
    enable = true;

    displayManager = {
      defaultSession = "none+i3";
      autoLogin = {
        enable = true;
        user = "tornax";
      };
    };

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
    };

    layout = "de";
    xkbVariant = "bone";
  };

  qt.style = "adwaita-dark";

  security.rtkit.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
