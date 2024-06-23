{ ... }:
{
  programs.zathura = {
    enable = false;
    extraConfig = ''
      set notification-error-bg "#ff5555"
      set notification-error-fg "#94cf95"
      set notification-warning-bg "#ffb86c"
      set notification-warning-fg "#44475a"
      set notification-bg "#1a1725"
      set notification-fg "#94cf95"

      set completion-bg "#1a1725"
      set completion-fg "#6272a4"
      set completion-group-bg "#1a1725"
      set completion-group-fg "#6272a4"
      set completion-highlight-bg "#44475a"
      set completion-highlight-fg "#94cf95"

      set index-bg "#1a1725"
      set index-fg "#94cf95"
      set index-active-bg "#44475a"
      set index-active-fg "#94cf95"

      set inputbar-bg "#1a1725"
      set inputbar-fg "#94cf95"

      set statusbar-bg "#1a1725"
      set statusbar-fg "#94cf95"

      set highlight-color "#0B610B"
      set highlight-active-color "#088A85"

      #set default-bg "#1a1725" # Background of border
      set default-fg "#94cf95" # Foreground

      set render-loading true
      set render-loading-fg "#1a1725" # Background
      set render-loading-bg "#94cf95" # Foreground

      # Recolor mode settings
      #
      #
      set recolor-lightcolor "#1a1725" # Background
      set recolor-darkcolor "#94cf95" # Foreground
    '';

    options = {
      adjust-open = "width";
      recolor = true;
      selection-clipboard = "clipboard";
      first-page-column = "1:1";
      synctex = true;
      synctex-editor-command = "nvim --headless -c \"VimtexInverseSearch %l f\"";
      incremental-search = true;
      page-cache-size = 500;
      font = "FiraCode";
      sandbox = "none";
    };
  };

}
