{ unstable, ... }:
{
  config = {
    programs.alacritty = {
      enable = true;
      package = unstable.alacritty;
      settings = {
        keyboard = {
          bindings = [{ key = "="; mods = "Control"; action = "ResetFontSize"; }];
        };

        font.normal = {
          family = "FiraCode Nerd Font";
          style = "Regular";
        };

        general.live_config_reload = false;
        window.opacity = 0.9;
      };

      theme = "tokyo_night_storm";
      themePackage = unstable.alacritty-theme;
    };
  };
}
