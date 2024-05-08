{ pkgs, system, inputs, lib, ... }:
{
  nix.settings = {
    extra-substituters = [ "https://helix.cachix.org" ];
    extra-trusted-public-keys = [ "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs=" ];
  };

  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${system}.default;
    defaultEditor = true;

    languages = {
      language-server = {
        nil = {
          command = "${pkgs.nil}/bin/nil";
          args = [ ];
        };

        # pylyzer = {
        #   command = "${pkgs.pylyzer}/bin/pylyzer";
        #   args = [ "--server" ];
        # };

        yaml = {
          command = "${pkgs.nodePackages.yaml-language-server}/bin/yaml-language-server";
          args = [ "--stdio" ];
        };

        clangd = {
          command = "${pkgs.clang-tools}/bin/clangd";
        };

        # typst-lsp = {
        #   command = "${pkgs.typst-lsp}/bin/typst-lsp";
        # };

        markdown-oxide = {
          command = "${lib.getExe pkgs.markdown-oxide}";
        };

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
          # language-servers = [ "pylyzer" ];
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
        {
          name = "markdown";
          auto-format = true;
          file-types = [ "markdown" ];
          language-servers = [ "markdown-oxide" ];
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
        popup-border = "all";

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

