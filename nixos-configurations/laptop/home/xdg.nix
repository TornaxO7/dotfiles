{
  configFile = {
    i3 = {
      enable = true;
      recursive = true;
      source = ../config/i3/laptop.i3conf;
      target = "i3/laptop.i3conf";
    };

    i3status-rust = {
      enable = true;
      recursive = true;
      source = ../config/i3status-rust;
      target = "i3status-rust";
    };
  };
}
