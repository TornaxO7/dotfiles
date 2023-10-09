{
  enable = true;
  defaultEditor = true;
  settings = {
    theme = "tokyonight_storm";

    editor = {
      line-number = "relative";

      statusline = {
        left = [ "mode" "file-name" "file-modification-indicator" "spinner"];
        center = [ "version-control" ];
        right = [
          "diagnostics"
          "selections"
          "file-encoding"
          "file-type"
          "position-percentage"
        ];
        mode = {
          normal = "NORMAL";
          insert = "INSERT";
          select = "SELECT";
        };
      };

      lsp = {
        display-inlay-hints = true;
      };

      indent-guides.render = true;
    };
  };
}
