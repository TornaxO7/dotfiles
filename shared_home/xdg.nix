{
  configFile = {
    neovim = {
      enable = false;
      recursive = true;
      text = "source ~/Programming/projects/dotfiles/config/nvim/init.vim";
      target = "nvim/init.vim";
    };

    zellij = {
      enable = true;
      recursive = true;
      source = ../config/zellij;
      target = "zellij";
    };

    vifm = {
      enable = true;
      recursive = true;
      source = ../config/vifm;
      target = "vifm";
    };
  };
}
