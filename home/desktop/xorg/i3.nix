{ config, pkgs, lib, ... }:
let
  alt = "Mod1";
  win = "Mod4";

  ws1 = "1";
  ws2 = "2";
  ws3 = "3";
  ws4 = "4";
  ws5 = "5";
  ws6 = "6";

  flameshot = "${pkgs.flameshot}/bin/flameshot";
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
        modifier = alt;
      };

      modifier = alt;
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

        "${alt}+n" = "exec --no-startup-id playerctl -p spotify next";
        "${alt}+r" = "exec --no-startup-id playerctl -p spotify previous";
        "${alt}+s" = "exec --no-startup-id playerctl -p spotify play-pause";

        "${alt}+Return" = "exec --no-startup-id rio";
        "${alt}+Shift+q" = "kill";
        "${alt}+d" = "exec --no-startup-id ${pkgs.rofi}/bin/rofi -show run";

        "${alt}+l" = "focus right";
        "${alt}+h" = "focus left";
        "${alt}+j" = "focus down";
        "${alt}+k" = "focus up";

        "${alt}+Shift+h" = "move left";
        "${alt}+Shift+j" = "move down";
        "${alt}+Shift+k" = "move up";
        "${alt}+Shift+l" = "move right";

        "${alt}+e" = "split v";
        "${alt}+i" = "split h";
        "${alt}+w" = "layout tabbed";
        "${alt}+f" = "fullscreen toggle";

        "${alt}+Shift+space" = "floating toggle";

        "${alt}+space" = "focus mode_toggle";

        "${alt}+Shift+b" = "move scratchpad";
        "${alt}+b" = "scratchpad show";

        # workspaces
        "${alt}+1" = "workspace number ${ws1}";
        "${alt}+2" = "workspace number ${ws2}";
        "${alt}+3" = "workspace number ${ws3}";
        "${alt}+4" = "workspace number ${ws4}";
        "${alt}+5" = "workspace number ${ws5}";
        "${alt}+6" = "workspace number ${ws6}";

        "${win}+n" = "workspace number ${ws1}";
        "${win}+r" = "workspace number ${ws2}";
        "${win}+s" = "workspace number ${ws3}";
        "${win}+g" = "workspace number ${ws4}";
        "${win}+q" = "workspace number ${ws5}";
        "${win}+z" = "workspace number ${ws6}";

        "${alt}+Shift+1" = "move container to workspace number ${ws1}";
        "${alt}+Shift+2" = "move container to workspace number ${ws2}";
        "${alt}+Shift+3" = "move container to workspace number ${ws3}";
        "${alt}+Shift+4" = "move container to workspace number ${ws4}";
        "${alt}+Shift+5" = "move container to workspace number ${ws5}";
        "${alt}+Shift+6" = "move container to workspace number ${ws6}";

        "${alt}+Shift+r" = "restart";
        "${alt}+Shift+e" = "exec i3-msg exit";
        "${alt}+Shift+f" = "exec --no-startup-id ${flameshot} gui";

        # applications
        "ctrl+shift+f" = "exec --no-startup-id ${pkgs.firefox}/bin/firefox";
      };
    };
  };
}
