{ ... }:
{
  programs.opencode = {
    enable = true;
    settings = {
      plugin = [ "opencode-caveman" ];
    };
  };
}
