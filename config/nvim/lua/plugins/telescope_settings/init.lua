local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<C-l>"] = actions.close,
            },
        },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
        },
    },
})
telescope.load_extension("ui-select")
telescope.load_extension("notify")

require("plugins.telescope_settings.whichkey")
