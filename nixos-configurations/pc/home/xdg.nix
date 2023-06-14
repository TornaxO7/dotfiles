{
  configFile = {
    i3 = {
      enable = true;
      recursive = true;
      source = ../config/i3;
      target = "i3";
    };

    eww = {
      enable = true;
      recursive = true;
      source = ../config/eww;
      target = "eww";
    };
  };
}
