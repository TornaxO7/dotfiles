{ ... }:
{
  config = {
    home = {
      pointerCursor.x11.enable = true;

      shellAliases = {
        x = "xclip -selection clipboard";
      };
    };
  };
}
