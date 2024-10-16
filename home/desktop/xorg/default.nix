{ ... }:
{
  config = {
    home = {
      pointerCursor.x11.enable = true;

      sessionVariables = {
        MOZ_USE_XINPUT2 = "1";
      };

      shellAliases = {
        x = "xclip -selection clipboard";
      };
    };
  };
}
