return {
	"klen/nvim-config-local",
	init = function()
		require("config-local").setup({
			config_files = { ".nvim/init.lua" }, -- Config file patterns to load (lua supported)
		})
	end,
}
