return {
	"TimUntersberger/neogit",
    enabled = false,
	dependencies = {
		"sindrets/diffview.nvim",
		"folke/which-key.nvim",
	},
	config = function()
		local neogit = require("neogit")

		neogit.setup({
			integrations = {
				diffview = true,
			},
		})

		require("plugins.neogit_settings.whichkey")
	end,
}
