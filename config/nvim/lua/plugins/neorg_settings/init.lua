local neorg = require("neorg")
neorg.setup({
    load = {
        ["core.defaults"] = {},
        ["core.dirman"] = {
            config = {
                workspaces = {
                    main = "/main/Dokumente/NeorgNotes",
                }
            }
        },
        ["core.completion"] = {
            config = {
                engine = "nvim-cmp",
            }
        },
        ["core.export"] = {},
        ["core.concealer"] = {},
        ["core.presenter"] = {
            config = {
                zen_mode = "zen-mode",
            }
        },
        -- ["core.integrations.telescope"] = {},
    }
})

require("plugins.neorg_settings.whichkey")
