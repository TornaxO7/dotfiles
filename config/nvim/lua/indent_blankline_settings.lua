vim.opt.list = true

vim.cmd [[highlight IndentBlanklineSpaceCharBlankline guifg=Gray]]
vim.cmd [[highlight IndentBlanklineSpaceChar guifg=Gray]]
vim.cmd [[highlight IndentBlanklineContextStart gui=underline]]

require("indent_blankline").setup {
    show_current_context_start = true,
    show_current_context = true,
    show_end_of_line = true
    -- char_highlight_list = {
    --     "IndentBlanklineIndent1",
    --     "IndentBlanklineIndent2",
    --     "IndentBlanklineIndent3",
    --     "IndentBlanklineIndent4",
    --     "IndentBlanklineIndent5",
    --     "IndentBlanklineIndent6",
    -- },
}
