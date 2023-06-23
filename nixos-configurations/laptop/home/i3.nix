{ config, pkgs, lib, ... }:
{
  xsession.windowManager.i3.config.bars = [
    {
      statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
      position = "top";
      fonts = {
          names = [ "FiraCode Nerd Font" ];
          style = "SemiBold";
          size = 11.0;
      };
    }
  ];
}
