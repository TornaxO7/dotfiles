{inputs, config, lib}:
let
    configPath = "/home/tornax/dotfiles/config";
    mkMutableSymlink = path: config.lib.file.mkOutOfStoreSymlink
      (configPath + lib.strings.removePrefix (toString inputs.self) (toString path));
in {
  configFile = {
    neovim = {
      enable = true;
      recursive = true;
      source = mkMutableSymlink ../config/nvim;
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
