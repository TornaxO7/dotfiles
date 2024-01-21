{ pkgs, config, lib, ... }:
{
  config.programs = rec {
    bat.enable = true;

    bottom.enable = true;

    eza = {
      enable = true;
      enableAliases = !nushell.enable;
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
      defaultEditor = true;

      languages = {
        language-server = {
          nil = {
            command = "${pkgs.nil}/bin/nil";
            args = [ ];
          };

          pylyzer = {
            command = "${pkgs.pylyzer}/bin/pylyzer";
            args = [ "--server" ];
          };

          yaml = {
            command = "${pkgs.nodePackages.yaml-language-server}/bin/yaml-language-server";
            args = [ "--stdio" ];
          };

          clangd = {
            command = "${pkgs.rocmPackages.llvm.clang-tools-extra}/bin/clangd";
          };

          # typst-lsp = {
          #   command = "${pkgs.typst-lsp}/bin/typst-lsp";
          # };

          json = {
            command = "${pkgs.nodePackages_latest.vscode-json-languageserver}/bin/vscode-json-languageserver";
            args = [ "--stdio" ];
          };

          taplo = {
            command = "${pkgs.taplo}/bin/taplo";
            args = [ "lsp" "stdio" ];
          };

          jdtls = {
            command = "${pkgs.jdt-language-server}/bin/jdt-language-server";
          };
        };

        language = [
          {
            name = "python";
            auto-format = true;
            file-types = [ "python" "py" ];
            language-servers = [ "pylyzer" ];
          }
          {
            name = "nix";
            auto-format = true;
            formatter = {
              command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
            };
            file-types = [ "nix" ];
            language-servers = [ "nil" ];
          }
          {
            name = "yaml";
            auto-format = true;
            file-types = [ "yaml" "yml" ];
            language-servers = [ "yaml" ];
          }
          {
            name = "c";
            auto-format = true;
            file-types = [ "c" "cpp" ];
            language-servers = [ "clangd" ];
          }
          {
            name = "typst";
            auto-format = true;
            file-types = [ "typst" ];
            formatter = {
              command = "${pkgs.typst-fmt}/bin/typst-fmt";
            };
            # language-servers = [ "typst-lsp" ];
          }
          {
            name = "toml";
            auto-format = true;
            file-types = [ "toml" ];
            formatter = {
              command = "${pkgs.taplo}/bin/taplo format";
            };
            language-servers = [ "taplo" ];
          }
          {
            name = "json";
            auto-format = false;
            file-types = [ "json" ];
            language-servers = [ "json" ];
          }
          {
            name = "java";
            file-types = [ "java" ];
            language-servers = [ "jdtls" ];
          }
        ];
      };

      settings = {
        theme = "tokyonight_storm";

        keys = {
          insert = {
            C-l = "normal_mode";
          };

          select = {
            C-l = "normal_mode";
          };
        };

        editor = {
          scrolloff = 7;
          line-number = "relative";
          idle-timeout = 0;
          color-modes = true;
          insert-final-newline = false;

          statusline = {
            left = [ "mode" "file-name" "read-only-indicator" "file-modification-indicator" ];
            center = [ "version-control" ];
            right = [ "diagnostics" "selections" "register" "position-percentage" "position" "file-encoding" "file-type" "spinner" ];

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
      package = pkgs.gitoxide;
      delta.enable = true;
      signing = {
        key = "7559 3129 41F8 AAAD 9EB6  D913 F652 0002 D62D 6194";
        signByDefault = true;
      };
      userEmail = "tornax@proton.me";
      userName = "TornaxO7";
      extraConfig = {
        core = {
          editor = "hx";
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
      defaultEditor = false;
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

    zoxide = {
      enable = true;
      enableNushellIntegration = config.programs.nushell.enable;
    };

    fish = {
      enable = true;
      shellAliases = import ./shell_aliases.nix;
      interactiveShellInit = ''
        bind -k nul accept-autosuggestion
      '';
    };

    nushell = {
      enable = false;

      environmentVariables = {
        EDITOR = "hx";
        # MANPAGER = "${lib.getExe pkgs.neovim} +Man!";
      };

      configFile.source = ../config/nushell/config.nu;
      envFile.source = ../config/nushell/env.nu;
    };

    yazi.enable = true;

    zsh = {
      enable = false;
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
