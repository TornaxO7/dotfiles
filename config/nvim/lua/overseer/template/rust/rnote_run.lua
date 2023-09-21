local overseer = require("overseer")

return {
	name = "rnote run",
	builder = function(params)
		return {
			cmd = { "./target/debug/bin/rnote" },
		}
	end,
	priority = 50,
	condition = {
        dir = "/home/tornax/Programming/pull_requests/rnote",
	},
}
