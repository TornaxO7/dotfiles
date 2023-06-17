{config}: {
  configFile = {
    neovim = {
      enable = true;
      recursive = true;
      source = config.lib.meta.mkMutableSymlink ../config/nvim;
      # recursive = true;
      # text = "source ~/Programming/projects/dotfiles/config/nvim/init.vim";
      # source = mkMutableSymlink ../config/nvim;
      target = "nvim";
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
