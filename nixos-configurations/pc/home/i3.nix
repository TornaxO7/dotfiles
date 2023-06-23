{config, pkgs, lib, ...}:
let
  alt = "Mod1";
  win = "Mod4";
in
{
  xsession.windowManager.i3.config = {
    startup = [
      {
        command = "exec --no-startup-id eww daemon";
        always = false;
        notification = false;
      }
    ];

    keybindings = {
        "${alt}+z" = "exec --no-startup-id eww open --toggle dashboard";
    };
  };
}
