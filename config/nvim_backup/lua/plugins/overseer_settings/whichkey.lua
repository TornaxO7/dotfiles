local overseer = require("overseer")
local key = require("which-key")

key.register({
    name = "overseer",
    e = {"<cmd>OverseerRun<cr>", "Run"},
    i = {overseer.toggle, "Toggle task list"},
}, {prefix = "mn"})
