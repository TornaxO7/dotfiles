return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",

        "nvim-neotest/neotest-python",
        "rouge8/neotest-rust",
    },
    config = function()
        require("neotest-python")({
            dap = {justMyCode = false},
            runner = "python -m pytest",
        })

        require("neotest-rust")
    end,
}
