{ config, pkgs, lib, ... }:
{
  home = {
    packages = import ./packages.nix {inherit pkgs;};
  };
  services = import ./services.nix;
  programs = import ./programs.nix;

  xsession = {
    enable = true;
    initExtra = "xset r rate 250";
  };

  gtk = {
    enable = true;

    # cursorTheme = {
    #   name = 
    # };

    theme = {
      name = "Tokyonight-Storm-B";
      package = pkgs.tokyo-night-gtk;
    };
  };
}
