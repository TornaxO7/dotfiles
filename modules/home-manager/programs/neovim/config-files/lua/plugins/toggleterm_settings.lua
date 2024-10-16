return {
    "akinsho/toggleterm.nvim",
    init = function()
        local toggleterm = require("toggleterm")

        toggleterm.setup({
            start_in_insert = false,
        })
    end,
}
