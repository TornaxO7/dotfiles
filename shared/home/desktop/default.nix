{ config, pkgs, lib, ... }:
{
  home = {
    packages = import ./packages.nix {inherit pkgs;};
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

    cursorTheme = {
      name = "breeze";
      package = pkgs.libsForQt5.breeze-gtk;
    };

    theme = {
      name = "Tokyonight-Storm-B";
      package = pkgs.tokyo-night-gtk;
    };
  };
}
