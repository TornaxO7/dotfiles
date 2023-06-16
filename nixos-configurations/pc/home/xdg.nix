{
  configFile = {
    i3 = {
      enable = true;
      recursive = true;
      source = ../config/i3/pc.i3conf;
      target = "i3/pc.i3conf";
    };

    eww = {
      enable = true;
      recursive = true;
      source = ../config/eww;
      target = "eww";
    };
  };
}
