{ ... }:
{
  programs.bugstalker = {
    enable = true;

    keymap = {
      special = {
        switch_window_tab = [ "Tab" ];
        expand_left = [ "Alt-1" ];
        expand_right = [ "Alt-2" ];
        focus_left = [ "Ctrl-h" ];
        focus_right = [ "Ctrl-l" ];
        switch_ui = [ "Esc" ];
        close_app = [ "q" ];
        continue = [ "i" "F9" ];
        run = [ "e" "F10" ];
        step_over = [ "r" ];
        step_into = [ "n" ];
        step_out = [ "s" ];
      };
      common = {
        up = [ "k" ];
        down = [ "j" ];
        scroll_down = [ "Ctrl-d" ];
        scroll_up = [ "Ctrl-u" ];
        goto_begin = [ "Home" ];
        goto_end = [ "End" ];
        submit = [ "Enter" ];
        cancel = [ "Esc" ];
        left = [ "h" ];
        right = [ "l" ];
        input_delete = [ "Delete" ];
        input_backspace = [ "Backspace" ];
      };
    };
  };
}
