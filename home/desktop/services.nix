{ inputs, system, ... }:
{
  config.services = {
    flameshot.enable = true;

    playerctld.enable = true;

    kdeconnect.enable = true;

    redshift = {
      enable = false;
      latitude = 52.52;
      longitude = 13.4;
      provider = "manual";
      settings.redshift = {
        transition = 1;
        brightness-day = 0.8;
        brightness-night = 0.6;
      };

      temperature = {
        day = 5700;
        night = 1000;
      };
    };

    wired = {
      enable = true;
      package = inputs.wired.packages.${system}.default;
      config = ../../config/wired/wired.ron;
    };
  };
}
