{
  flameshot.enable = true;

  playerctld.enable = true;

  redshift = {
    enable = true;
    latitude = 52.52;
    longitude = 13.4;
    provider = "manual";
    settings.redshift = {
      transition = 1;
      brightness-day = 1;
      brightness-night = 0.6;
    };

    temperature = {
      day = 5700;
      night = 1000;
    };
  };
}
