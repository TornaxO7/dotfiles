{ config, pkgs, lib, ... }:
let
  win = "Mod4";

  ws1 = "1";
  ws2 = "2";
  ws3 = "3";
  ws4 = "4";
  ws5 = "5";
  ws6 = "6";

  flameshot = "${pkgs.flameshot}/bin/flameshot";
  terminal = "${pkgs.rio}/bin/rio";
in
{
  xsession.windowManager.i3 = {
    enable = true;

    config = {
      fonts = {
        names = [ "FiraCode Nerd Font" ];
        style = "SemiBold";
        size = 11.0;
      };

      startup = [
        {
          command = "${flameshot}";
          notification = false;
        }
      ];

      menu = "${pkgs.rofi}/bin/rofi -show run";

      gaps = null;
      modes = { };

      floating = {
        modifier = win;
      };

      modifier = win;
      terminal = "rio";

      window = {
        border = 1;
        titlebar = false;
      };
      assigns = {
        "4" = [{ class = "discord"; }];
        "5" = [{ class = "spotify"; }];
      };

      keybindings = {
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +2%";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -2%";
        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle";

        "${win}+l" = "focus right";
        "${win}+h" = "focus left";
        "${win}+j" = "focus down";
        "${win}+k" = "focus up";

        "${win}+Shift+h" = "move left";
        "${win}+Shift+j" = "move down";
        "${win}+Shift+k" = "move up";
        "${win}+Shift+l" = "move right";

        "${win}+w" = "layout tabbed";
        "${win}+p" = "layout splith";

        "${win}+Shift+space" = "floating toggle";
        "${win}+space" = "focus mode_toggle";

        # workspaces; right main row and one bottom
        "${win}+n" = "workspace number ${ws1}";
        "${win}+r" = "workspace number ${ws2}";
        "${win}+s" = "workspace number ${ws3}";
        "${win}+g" = "workspace number ${ws4}";
        "${win}+q" = "workspace number ${ws5}";
        "${win}+z" = "workspace number ${ws6}";

        "${win}+Shift+n" = "move container to workspace number ${ws1}";
        "${win}+Shift+r" = "move container to workspace number ${ws2}";
        "${win}+Shift+s" = "move container to workspace number ${ws3}";
        "${win}+Shift+g" = "move container to workspace number ${ws4}";
        "${win}+Shift+q" = "move container to workspace number ${ws5}";
        "${win}+Shift+z" = "move container to workspace number ${ws6}";

        # == utilities + applications ==
        # top right row
        "${win}+7" = "exec --no-startup-id playerctl -p spotify next";
        "${win}+8" = "exec --no-startup-id playerctl -p spotify previous";
        "${win}+9" = "exec --no-startup-id playerctl -p spotify play-pause";

        "${win}+Return" = "exec --no-startup-id ${terminal}";

        # left bottom row
        "${win}+e" = "exec --no-startup-id ${pkgs.firefox}/bin/firefox";
        "${win}+i" = "exec --no-startup-id ${pkgs.rofi}/bin/rofi -show run";
        "${win}+t" = "exec --no-startup-id ${flameshot} gui";

        "${win}+Shift+f" = "move scratchpad";
        "${win}+f" = "scratchpad show";

        # left top row
        "${win}+Shift+a" = "kill";
        "${win}+Shift+d" = "restart";
        "${win}+Shift+u" = "exec i3-msg exit";
      };
    };
  };
}
