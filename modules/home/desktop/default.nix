{ config, pkgs, lib, ... }:
{
  imports = [
    ./packages.nix
    ./services.nix
    ./programs.nix
  ];

  config = {
    home = {
      pointerCursor = {
        package = pkgs.libsForQt5.breeze-gtk;
        gtk.enable = true;
        name = "breeze";
        x11.enable = true;
      };
      shellAliases = {
        x = "xclip -selection clipboard";
      };
    };

    xsession = {
      initExtra = "xset r rate 250";
    };

    gtk = {
      enable = true;

      theme = {
        name = "Tokyonight-Storm-B";
        package = pkgs.tokyo-night-gtk;
      };
    };
  };
}
