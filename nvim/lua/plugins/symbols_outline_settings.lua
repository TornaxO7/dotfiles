return {
    'simrat39/symbols-outline.nvim',
    init = function()
        require("symbols-outline").setup()

        vim.keymap.set("n", "<C-t>", function() vim.api.nvim_command(":SymbolsOutline") end, {silent = true})
    end
}
