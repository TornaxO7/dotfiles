require("overseer").setup({
	templates = {
		"builtin",
		"python",
        "rust",
        "nix",
	},
	strategy = {
		"toggleterm",
		use_shell = false,
		direction = "horizontal",
		auto_scroll = true,
		close_on_exit = false,
		open_on_start = true,
		on_create = function()
			vim.cmd("stopinsert")
		end,
	},
})
require("plugins.overseer_settings.whichkey")
