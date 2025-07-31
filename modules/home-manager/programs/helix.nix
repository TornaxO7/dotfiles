{ pkgs, inputs, lib, unstable, ... }:
let
  ra-multiplex-pkg = inputs.ra-multiplex.packages.${pkgs.system}.default;
  # wgsl-pkg = inputs.wgsl-analyzer.packages.${pkgs.system}.default;
in
{
  nix.settings = {
    extra-substituters = [ "https://helix.cachix.org" ];
    extra-trusted-public-keys = [ "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs=" ];
  };

  systemd.user.services = {
    ra-multiplex = {
      Unit = {
        Description = "start ra-multiplex server";
      };

      Service = {
        ExecStart = "${ra-multiplex-pkg}/bin/ra-multiplex server";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };

  xdg.configFile.ra-multiplex = {
    enable = true;
    text = ''
      pass_environment = ["PATH", "LD_LIBRARY_PATH", "PKG_CONFIG_PATH"]
    '';
    target = "ra-multiplex/config.toml";
  };

  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.default;
    defaultEditor = true;

    languages = {
      language-server = {
        ra-multiplex = {
          command = "${ra-multiplex-pkg}/bin/ra-multiplex";
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
          command = "${pkgs.nil}/bin/nil";
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
          command = "${pkgs.clang-tools}/bin/clangd";
        };

        # typst-lsp = {
        #   command = "${pkgs.typst-lsp}/bin/typst-lsp";
        # };

        # wgsl = {
        #   command = "${wgsl-pkg}/bin/wgsl_analyzer";
        # };

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
          command = "${pkgs.jdt-language-server}/bin/jdt-language-server";
        };
      };

      language = [
        {
          name = "css";
          auto-format = true;
          file-types = [ "css" ];
          language-servers = [ "css" ];
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
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
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [ "--stdin-filepath" "rofl.html" ];
          };
        }
        {
          name = "rust";
          auto-format = true;
          file-types = [ "rust" "rs" ];
          language-servers = [ "ra-multiplex" ];
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
          formatter = {
            command = "${pkgs.clang-tools}/bin/clang-format";
          };
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
          formatter = {
            command = "${pkgs.jaq}/bin/jaq";
          };
        }
        # {
        #   name = "wgsl";
        #   file-types = [ "wgsl" ];
        #   language-servers = [ "wgsl" ];
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
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [ "--stdin-filepath" "rofl.md" ];
          };
        }
        {
          name = "matlab";
          auto-format = true;
          file-types = [ "matlab" ];
          language-servers = [ "matlab" ];
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

