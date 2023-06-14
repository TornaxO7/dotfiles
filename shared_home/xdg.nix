{
  configFile = {
    neovim = {
      enable = true;
      recursive = true;
      source = ../config/nvim;
      target = "nvim";
    };

    zellij = {
      enable = true;
      recursive = true;
      source = ../config/zellij;
      target = "zellij";
    };
  };
}
