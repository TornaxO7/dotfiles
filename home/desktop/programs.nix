{ inputs, ... }:
let
  system = pkgs.system;
in
{
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

    rofi = {
      enable = true;
      font = "FiraCode Nerd Font 12";
    };

    firefox.enable = true;

    rio = {
      enable = true;
      package = inputs.rio.packages.${system}.default;
    };
  };
}

