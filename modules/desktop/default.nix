{ ... }:
{
  qt = {
    style = "adwaita-dark";
    # platformTheme = "gtk";
  };

  programs.dconf.enable = true;

  environment.pathsToLink = [ "/libexec" ];

  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    printing.enable = true;
    # avahi = {
    #   enable = true;
    #   nssmdns4 = true;
    # };
  };
}
