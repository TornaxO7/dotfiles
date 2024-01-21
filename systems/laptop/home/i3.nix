{ config, pkgs, lib, ... }:
let
  win = "Mod4";
in
{
  xsession.windowManager.i3.config = {
    keybindings = {
      "${win}+Control+l" = "exec ${pkgs.i3lock}/bin/i3lock -i /main/Images/FSN/ArcherRinBlue.png -e -t";
    };

    bars = [
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
  };
}
