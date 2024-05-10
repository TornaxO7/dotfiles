{ ... }:
let
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
      "${win}+b" = "exec --no-startup-id eww open --toggle dashboard";
    };

    bars = [ ];
  };
}
