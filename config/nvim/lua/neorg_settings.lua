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
        ["core.integrations.telescope"] = {},
    }
})

-- keybindings
local key = require("which-key")

local tprolog = "<Cmd>Telescope neorg "

key.register({
	name = "+Neorg",
    n = { ":Neorg<CR>", "Open neorg"},
	i = {
		name = "insert",
		l = { tprolog .. "insert_link<CR>", "Insert Link" },
		f = { tprolog .. "insert_file_link<CR>", "Insert File link" },
	},
	s = { tprolog .. "search_headings<CR>", "Search Headings" },
	w = { tprolog .. "switch_workspace<CR>", "Switch Workspace" },
	f = {
		name = "find",
		l = { tprolog .. "find_linkable<CR>", "Find Linkable" },
		t = { tprolog .. "find_project_tasks<CR>", "Find Project Tasks" },
	},
	p = { "<Cmd>Neorg presenter start<CR>", "Start Presenter" },
	t = { "<Cmd>Neorg toc split<CR>", "Split TOC" },
}, { prefix = "mn" })
