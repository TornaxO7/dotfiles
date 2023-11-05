{ pkgs, lib, ... }:
{
  config.programs = {
    bat.enable = true;

    bottom.enable = true;

    eza = {
      enable = true;
      # enableAliases = true;
      icons = true;
      git = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "rg --files --engine=pcre2";
      defaultOptions = [
        "--prompt='> '"
        "--cycle"
        "--preview='bat --color always {}'"
        "+i"
        "--bind=ctrl-j:preview-half-page-down,ctrl-k:preview-half-page-up"
      ];
    };

    helix = {
      enable = true;
      defaultEditor = false;

      extraPackages = with pkgs; [
        nil
        nixpkgs-fmt
      ];

      languages = {
        language-server = {
          rnix = with pkgs; {
            command = "${pkgs.rnix-lsp}/bin/rnix-lsp";
            args = [ ];
          };
        };

        language = [{
          name = "nix";
          auto-format = true;
          formatter = {
            command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
          };
          file-types = [ "nix" ];
          language-servers = [ "rnix" ];
        }];
      };

      settings = {
        theme = "tokyonight_storm";

        editor = {
          auto-pairs = false;
          scrolloff = 7;
          line-number = "relative";
          idle-timeout = 0;
          color-modes = true;
          insert-final-newline = false;

          statusline = {
            left = [ "mode" "file-name" "read-only-indicator" "file-modification-indicator" ];
            center = [ "version-control" ];
            right = [ "diagnostics" "selections" "register" "position" "file-encoding" "file-type" "spinner" ];

            mode = {
              normal = "NORMAL";
              insert = "INSERT";
              select = "SELECT";
            };
          };

          lsp.display-inlay-hints = true;

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          indent-guides.render = true;
        };
      };
    };

    home-manager.enable = true;

    git = {
      enable = true;
      delta.enable = true;
      signing = {
        key = "7559 3129 41F8 AAAD 9EB6  D913 F652 0002 D62D 6194";
        signByDefault = true;
      };
      userEmail = "tornax@proton.me";
      userName = "TornaxO7";
      extraConfig = {
        core = {
          editor = "nvim";
        };

        merge.tool = "nvimdiff";

        mergetool = {
          vimdiff.layout = "(LOCAL,REMOTE)/MERGED";
          keepBackup = false;
        };

        push.autoSetupRemote = true;
        pull.rebase = false;
      };
    };

    gpg = {
      enable = true;

      scdaemonSettings = {
        disable-ccid = true;
        reader-port = "Yubico Yubi";
      };
    };

    jq = {
      enable = true;
      package = pkgs.jql;
    };

    less.enable = true;

    man.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        gcc13
        deno
      ];
      withPython3 = true;
      vimdiffAlias = true;
    };

    password-store.enable = true;

    ssh = {
      enable = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      settings = {
        add_newline = false;

        format = lib.concatStrings [
          "┌─ $os$all"
          # "[└─](bold green)"
        ];
        right_format = "$battery";

        directory.style = "bold fg:#00affa";

        os.disabled = false;

        battery.display = [{
          threshold = 100;
          style = "bold #dbcf00";
        }];

        git_status = {
          style = "bold fg:#ffcb00";

          format = "([\\[$all_status$ahead_behind\\]]($style) )";
          staged = "+$count";
          deleted = "-$count";
          modified = "!$count";
        };

        git_branch.style = "bold fg:#00da00";
      };
    };

    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };

    zathura = {
      enable = true;
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

    zellij.enable = true;

    zoxide.enable = true;

    nushell.enable = false;

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      shellAliases = import ./shell_aliases.nix;
      sessionVariables = import ./session_variables.nix;
      initExtra = ''
        bindkey '^ ' autosuggest-accept
        eval "$(zoxide init zsh)"
      '';
      oh-my-zsh = {
        enable = true;
        plugins = [
          "aliases"
          "git"
        ];
      };
    };
  };
}
