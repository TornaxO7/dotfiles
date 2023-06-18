local overseer = require("overseer")

return {
	name = "cargo doc --open",
	builder = function(params)
		return {
			cmd = { "cargo" },
			args = { "doc", "--open" },
		}
	end,
	tags = { overseer.TAG.BUILD },
	priority = 50,
	condition = {
		filetype = { "rust" },
	},
}
