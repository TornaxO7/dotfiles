{ inputs, system, pkgs, ... }:
{
  imports = [
    ./i3.nix
    ./minecraft.nix
  ];

  home = {
    packages = with pkgs; [
      eww
      rpi-imager
      lact
    ] ++ [
      inputs.deploy-rs.packages.${system}.default
    ];

    pointerCursor.size = 20;
  };

  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
  };

  xdg.configFile = {
    eww = {
      enable = true;
      recursive = true;
      source = ../config/eww;
      target = "eww";
    };
  };

  # programs.fish.loginShellInit = ''
  #   # Start X at login
  #   if status is-login
  #       if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
  #           exec startx -- -keeptty
  #       end
  #   end
  # '';
}
