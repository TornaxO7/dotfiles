{config, pkgs, lib, ...}:
let
  vimExtraPlugins =  with pkgs.vimExtraPlugins; [
          treesj

          lsp-zero-nvim
          fzf-lsp-nvim
          lsp-colors-nvim
          virtual-types-nvim
          null-ls-nvim
          mason-nvim
          cmp-vsnip

          nvim-surround
          FTerm-nvim
          fm-nvim
          nvim-ts-autotag
          pantran-nvim
          nvim-revJ-lua
          peek-nvim
          overseer-nvim
          nvim-treesitter-refactor
          neorg
          neogen
          presence-nvim
          hydra-nvim
          nvim-bqf
          nvim-notify
          nvim-highlight-colors
          toggleterm-nvim
        ];

  vimPlugins = with pkgs.vimPlugins; [
    telescope-ui-select-nvim
    project-nvim
    fzf-lua
    noice-nvim
    playground

    symbols-outline-nvim
  ];
in
{
  config = {
    programs.nixneovim = {
        enable = true;
        defaultEditor = true;

        extraConfigLua = ''
          require("plugins.neorg_settings")
          require("plugins.nvim_dap_settings")
          require("plugins.overseer_settings")
          require("plugins.pantran_settings")
          require("plugins.peek_settings")
          require("plugins.telescope_settings")
          require("plugins.fm_nvim_settings")
          require("plugins.hydra_settings")
          require("plugins.indent_blankline_settings")
          require("plugins.lualine_settings")
          require("plugins.lsp_lines_settings")
          require("plugins.mason_settings")
          require("plugins.neogen_settings")
          require("plugins.noice_settings")
          require("plugins.notify_settings")
          require("plugins.nvim_cmp_settings")
          require("plugins.nvim_surround_settings")
          require("plugins.presence_settings")
          require("plugins.project_nvim_settings")
          require("plugins.symbols_outline_settings")
          require("plugins.toggleterm_settings")
          require("plugins.treesj_settings")
          require("plugins.trouble_settings")
          require("plugins.vimtex_settings")
          require("plugins.whichkey_settings")
        '';

        extraConfigVim = ''
          let g:mapleader = " "
          let g:maplocalleader = " "

          ${lib.strings.fileContents ../../../config/nvim/settings.vim}
          ${lib.strings.fileContents ../../../config/nvim/autocmds.vim}
          ${lib.strings.fileContents ../../../config/nvim/commands.vim}
          ${lib.strings.fileContents ../../../config/nvim/mappings.vim}
          ${lib.strings.fileContents ../../../config/nvim/colorscheme.vim}
        '';

        colorschemes.tokyonight = {
          enable = true;
          style = "storm";
        };

        plugins = {
          lsp = {
            enable = true;
            servers = {
              bashls.enable = true;
              clangd.enable = true;
              html.enable = true;
              jsonls.enable = true;
              pyright.enable = true;
              rnix-lsp.enable = true;
              rust-analyzer.enable = true;
              texlab.enable = true;
            };
          };

          barbar.enable = true;
          comment.enable = true;
          floaterm.enable = true;
          gitsigns = {
            enable = true;
            numhl = true;
            currentLineBlame = true;
          };
          indent-blankline.enable = true;
          lsp-lines.enable = true;
          lspkind.enable = true;
          lualine.enable = true;
          luasnip.enable = true;
          notify.enable = true;
          nvim-cmp = {
            enable = true;
            snippet.luasnip.enable = true;

            sources = {
              nvim_lsp = {
                enable = true;
                priority = 10;
              };

              path = {
                enable = true;
                priority = 1;
              };
            };
          };
          nvim-dap.enable = true;
          nvim-dap-ui.enable = true;
          plantuml-syntax.enable = true;
          plenary-nvim.enable = true;
          rust-tools.enable = true;
          telescope.enable = true;
          treesitter = {
            enable = true;
          };
          treesitter-context.enable = true;
          trouble.enable = true;
          vim-easy-align.enable = true;
          vimtex.enable = true;
          which-key.enable = true;
        };

        extraPlugins = vimExtraPlugins ++ vimPlugins;
    };

    xdg.configFile = {
      nvim-ftplugin = {
        enable = true;
        recursive = true;
        source = ../../../config/nvim/ftplugin;
        target = "nvim/ftplugin";
      };

      nvim-lua = {
        enable = true;
        recursive = true;
        source = ../../../config/nvim/lua/plugins;
        target = "nvim/lua/plugins";
      };
    };
  };
}
