{inputs, config, lib}:
let
    configPath = "/home/tornax/dotfiles/config";
    mkMutableSymlink = path: config.lib.file.mkOutOfStoreSymlink
      (configPath + lib.strings.removePrefix (toString inputs.self) (toString path));
in {
  configFile = {
    neovim = {
      enable = true;
<<<<<<< Updated upstream
      recursive = true;
      source = mkMutableSymlink ../config/nvim;
=======
      # recursive = true;
      # text = "source ~/Programming/projects/dotfiles/config/nvim/init.vim";
      # source = mkMutableSymlink ../config/nvim;
      source = "${../config/nvim}";
>>>>>>> Stashed changes
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
