{
  configFile = {
    i3 = {
      enable = true;
      recursive = true;
      source = ../config/i3;
      target = "i3";
    };

    i3status-rust = {
      enable = true;
      recursive = true;
      source = ../config/i3status-rust;
      target = "i3status-rust";
    };
  };
}
