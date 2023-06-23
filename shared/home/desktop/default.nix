{ config, pkgs, lib, ... }:
{
  home = {
    packages = import ./packages.nix {inherit pkgs;};
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
  services = import ./services.nix;
  programs = import ./programs.nix;

  xsession = {
    enable = true;
    initExtra = "xset r rate 250";
  };

  gtk = {
    enable = true;

    theme = {
      name = "Tokyonight-Storm-B";
      package = pkgs.tokyo-night-gtk;
    };
  };
}
