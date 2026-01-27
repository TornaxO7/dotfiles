{ self, config, pkgs, ... }:
{
  home-manager = {
    sharedModules = [
      self.homeManagerModules.gtt
    ];

    users.tornax = { ... }: {
      programs.gtt = {
        enable = true;
        package = pkgs.gtt;
        settings.api_key.DeepL.file = config.age.secrets.deepl.path;
        keymap = {
          clear = "C-l";

          translate = "C-n";
          copy_destination = "C-r";
          exit = "C-s";
          swap_language = "C-z";
        };
      };
    };
  };
}
