{pkgs, lib}: {
  enable = true;
  defaultEditor = true;

  extraConfigVim = ''
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
    };
    nvim-dap.enable = true;
    nvim-dap-ui.enable = true;
    plantuml-syntax.enable = true;
    plenary-nvim.enable = true;
    rust-tools.enable = true;
    telescope.enable = true;
    treesitter.enable = true;
    treesitter-context.enable = true;
    trouble.enable = true;
    vim-easy-align.enable = true;
    vimtex.enable = true;
    which-key.enable = true;
  };

  extraPlugins = with pkgs.vimExtraPlugins; [
    treesj
    lsp-zero-nvim
    nvim-surround
    toggleterm-nvim
    cmp-vsnip
    nvim-ts-autotag
    pantran-nvim
    nvim-revJ-lua
    peek-nvim
    mason-nvim
    overseer-nvim
    nvim-treesitter-refactor
    neorg
    virtual-types-nvim
    neogen
    fzf-lsp-nvim
    presence-nvim
    lsp-colors-nvim
    hydra-nvim
  ];
}
