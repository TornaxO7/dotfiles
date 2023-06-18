local key = require("which-key")
local treesj = require("treesj")

treesj.setup({ use_default_keymaps = false })
key.register({
	s = { treesj.toggle, "Toggle split/join" },
}, { prefix = "<localleader>" })
