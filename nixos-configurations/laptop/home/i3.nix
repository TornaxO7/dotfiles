{ config, pkgs, lib, ... }:
{
  xsession.windowManager.i3.config.bars = [
    {
      statusCommand = "${pkgs.i3status-rust}/bin/i3status-rust";
      position = "top";
    }
  ];
}
