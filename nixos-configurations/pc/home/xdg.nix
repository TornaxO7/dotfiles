{
  configFile = {
    i3 = {
      enable = true;
      recursive = true;
      source = ../config/i3/config;
      target = "i3/config";
    };

    eww = {
      enable = true;
      recursive = true;
      source = ../config/eww;
      target = "eww";
    };
  };
}
