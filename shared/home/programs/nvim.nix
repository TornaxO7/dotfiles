{ pkgs }:
{
  enable = true;
  defaultEditor = true;
  extraPackages = with pkgs; [
    gcc13
  ];
  withPython3 = true;
  vimdiffAlias = true;
  # plugins = with pkgs.vimPlugins; [
  #   barbar-nvim
  #   comment-nvim
  #   gitsigns-nvim
  #   hydra-nvim
  #   indent-blankline-nvim
  #   lualine-nvim
  #   luasnip
  #   neogen
  #   neorg
  #   neotest
  #   noice-nvim
  #   nvim-bqf
  #   nvim-cmp
  #   nvim-dap
  #   nvim-highlight-colors
  #   nvim-lspconfig
  #   nvim-surround
  #   nvim-treesitter
  #   plenary-nvim
  #   presence-nvim
  #   refactoring-nvim
  #   symbols-outline-nvim
  #   telescope-nvim
  #   tokyonight-nvim
  #   treesj
  #   trouble-nvim
  #   vim-easy-align
  #   vimtex
  #   which-key-nvim
  # ];
}
