{config, pkgs, lib, ...}:
{
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    layout = "de";
    xkbVariant = "bone";
  };

  qt = {
    style = "adwaita-dark";
    # platformTheme = "gtk";
  };

  programs.dconf.enable = true;

  environment.pathsToLink = [ "/libexec" ];

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
