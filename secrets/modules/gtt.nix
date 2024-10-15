{ self, config, inputs, pkgs, ... }:
{
  home-manager = {
    sharedModules = [
      self.homeManagerModules.gtt
    ];

    users.main = { ... }: {
      programs.gtt = {
        enable = true;
        package = inputs.gtt.packages.${pkgs.system}.default;
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
