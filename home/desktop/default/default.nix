{ pkgs, ... }:
{
  imports = [
    ./packages.nix
    ./services
    ./programs
  ];

  config = {

    home = {
      pointerCursor = {
        package = pkgs.libsForQt5.breeze-gtk;
        gtk.enable = true;
        name = "breeze";
      };
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
