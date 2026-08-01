{ ... }:
{
  programs.claude-code = {
    enable = true;
    settings = {
      extraKnownMarketplaces = {
        caveman = {
          source = {
            source = "github";
            repo = "JuliusBrussee/caveman";
          };
        };
      };
      enabledPlugins = {
        "caveman@caveman" = true;
      };
    };
  };
}
