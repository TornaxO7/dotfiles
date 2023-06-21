return {
	"toppair/peek.nvim",
    ft = "markdown",
	build = "deno task --quiet build:fast",
	config = function()
		require("peek").setup({
			auto_load = false,
			close_on_bdelete = true,
			syntax = false,
			theme = "dark",
			update_on_change = true,
            app = {'google-chrome-stable', '--new-window'},
            filetype = {"markdown"},
			throttle_at = 200000,
			throttle_time = "auto",
		})

        require("plugins.peek_settings.commands")
	end,
}
