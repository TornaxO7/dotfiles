{ config, ... }:
{
  imports = [
    ./alacritty.nix
    ./rio
  ];

  config = {
    programs = {
      sioyek = {
        enable = false;
        bindings = {
          move_up = "k";
          move_down = "j";

          previous_page = "K";
          next_page = "J";

          zoom_in = "+";
          zoom_out = "-";

          reload = "<C-r>";

          fit_to_page_width = "s";
          fit_to_page_height = "r";

          goto_toc = "<tab>";

          command = ":";
        };
        config = {
          startup_commands = "toggle_mouse_drag_mode";
        };
      };

      obsidian = {
        enable = true;
        # defaultSettings.hotkeys = {
        #   "app:delete-file" = [
        #     {
        #       "modifiers" = [ "Mod" ];
        #       "key" = "Delete";
        #     }
        #   ];
        #   "switcher:open" = [

        #   ];
        # };
      };

      rofi = {
        enable = true;
        font = "FiraCode Nerd Font 12";
      };

      firefox = {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
      };
    };
  };
}

