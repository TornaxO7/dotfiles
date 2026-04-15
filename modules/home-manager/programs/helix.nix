{ pkgs, inputs, lib, unstable, ... }:
let
  lspmux-pkg = unstable.lspmux;
in
{
  nix.settings = {
    extra-substituters = [ "https://helix.cachix.org" ];
    extra-trusted-public-keys = [ "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs=" ];
  };

  systemd.user.services = {
    lspmux = {
      Unit = {
        Description = "start lspmux server";
      };

      Service = {
        ExecStart = "${lspmux-pkg}/bin/lspmux server";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };

  xdg.configFile.lspmux = {
    enable = true;
    text = ''
      pass_environment = ["PATH", "LD_LIBRARY_PATH", "PKG_CONFIG_PATH"]
    '';
    target = "lspmux/config.toml";
  };

  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.default;
    defaultEditor = true;

    languages = {
      language-server = {
        lspmux = {
          command = "${lspmux-pkg}/bin/lspmux";
          args = [ "client" ];
        };

        matlab = {
          command = "${pkgs.matlab-language-server}/bin/matlab-language-server";
          args = [ "--stdio" ];
        };

        marksman = {
          command = "${unstable.marksman}/bin/marksman";
          args = [ ];
        };

        nil = {
          command = "${lib.getExe pkgs.nil}";
          args = [ ];
        };

        html = {
          command = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";
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
          command = "${lib.getExe' pkgs.clang-tools "clangd"}";
        };

        # typst-lsp = {
        #   command = "${pkgs.typst-lsp}/bin/typst-lsp";
        # };

        wgsl = {
          command = "${lib.getExe pkgs.wgsl-analyzer}";
        };

        css = {
          command = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
        };

        scss = {
          command = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
        };

        markdown-oxide = {
          command = "${lib.getExe pkgs.markdown-oxide}";
        };

        json = {
          command = "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server";
          args = [ "--stdio" ];
        };

        taplo = {
          command = "${pkgs.taplo}/bin/taplo";
          args = [ "lsp" "stdio" ];
        };

        jdtls = {
          command = "${lib.getExe pkgs.jdt-language-server}";
        };

        gopls = {
          command = "${lib.getExe pkgs.gopls}";
        };
      };

      language = [
        {
          name = "css";
          auto-format = true;
          file-types = [ "css" ];
          language-servers = [ "css" ];
          formatter = {
            command = "${lib.getExe pkgs.nodePackages.prettier}";
            args = [ "--stdin-filepath" "rofl.css" ];
          };
        }
        {
          name = "scss";
          auto-format = true;
          file-types = [ "scss" ];
          language-servers = [ "scss" ];
        }
        {
          name = "html";
          auto-format = true;
          file-types = [ "html" ];
          language-servers = [ "html" ];
          formatter = {
            command = "${lib.getExe pkgs.nodePackages.prettier}";
            args = [ "--stdin-filepath" "rofl.html" ];
          };
        }
        {
          name = "rust";
          auto-format = true;
          file-types = [ "rust" "rs" ];
          language-servers = [ "lspmux" ];
        }
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
            command = "${lib.getExe pkgs.nixpkgs-fmt}";
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
          formatter = {
            command = "${lib.getExe' pkgs.clang-tools "clang-format"}";
          };
        }
        {
          name = "typst";
          auto-format = true;
          file-types = [ "typst" ];
          formatter = {
            command = "${lib.getExe pkgs.typstyle}";
          };
          # language-servers = [ "typst-lsp" ];
        }
        {
          name = "toml";
          auto-format = true;
          file-types = [ "toml" ];
          formatter = {
            command = "${lib.getExe pkgs.taplo} format";
          };
          language-servers = [ "taplo" ];
        }
        {
          name = "json";
          auto-format = false;
          file-types = [ "json" ];
          language-servers = [ "json" ];
          formatter = {
            command = "${pkgs.jaq}/bin/jaq";
          };
        }
        # {
        #   name = "wgsl";
        #   file-types = [ "wgsl" ];
        #   language-servers = [ "wgsl" ];
        #   formatter = {
        #     command = "${lib.getExe' pkgs.wgsl-analyzer "wgslfmt"}";
        #   };
        # }
        {
          name = "java";
          file-types = [ "java" ];
          language-servers = [ "jdtls" ];
        }
        {
          name = "markdown";
          auto-format = true;
          file-types = [ "markdown" "md" ];
          language-servers = [ "markdown-oxide" "marksman" ];
          formatter = {
            command = "${lib.getExe pkgs.nodePackages.prettier}/bin/prettier";
            args = [ "--stdin-filepath" "rofl.md" ];
          };
        }
        {
          name = "matlab";
          auto-format = true;
          file-types = [ "matlab" ];
          language-servers = [ "matlab" ];
        }
        {
          name = "go";
          auto-format = true;
          file-types = [ "go" ];
          language-servers = [ "gopls" ];
        }
      ];
    };

    themes = {
      tokyonight_storm_transparent = {
        "inherits" = "tokyonight_storm";
        "ui.background" = [ ];
      };
    };

    settings = {
      theme = "tokyonight_storm_transparent";

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
        popup-border = "all";
        end-of-line-diagnostics = "hint";
        rainbow-brackets = true;

        inline-diagnostics = {
          cursor-line = "warning";
          other-lines = "warning";
        };

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

        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        indent-guides.render = true;
      };
    };
  };
}

