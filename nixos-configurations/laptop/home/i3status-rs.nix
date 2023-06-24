{ config, pkgs, lib, ... }:
{
  programs.i3status-rust = {
    enable = true;
    bars.default = {
      icons = "awesome5";
      theme = "solarized-dark";

      blocks = [
        {
          block = "backlight";
          device = "intel_backlight";
          cycle = [5 15 40 75 90];
        }
        {
          block = "battery";
          interval = 10;
          full_threshold = 95;
          full_format = "Full $power";
          format = "$icon  $percentage $time";
          good = 60;
          info = 40;
          warning = 20;
          critical = 10;
        }
        {
          block = "cpu";
          interval = 1;
          format = "$icon $utilization";
        }
        {
          block = "memory";
          format = "$icon $mem_used.eng(prefix:M)/$mem_total.eng(prefix:M)";
          interval = 5;
          warning_mem = 80;
          warning_swap = 80;
          critical_mem = 95;
          critical_swap = 95;
        }
        {
          block = "net";
          device = "wlan0";
          format = "$icon $ssid $signal_strength";
          inactive_format = "$icon  Down";
          interval = 5;
        }
        {
          block = "sound";
          step_width = 2;
          max_vol = 100;
        }
        {
          block = "time";
          format = "$icon $timestamp.datetime(f:'%d/%m', l:de_DE), $timestamp.datetime(f:%R, l:de_DE)";
          timezone = "Europe/Berlin";
          interval = 60;
        }
      ];
    };
  };
}
