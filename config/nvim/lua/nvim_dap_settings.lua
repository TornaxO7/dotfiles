-- hydra
local dap = require("dap")
local dapui = require("dapui")

require("hydra")({
    name = "DAP",
    mode = "n",
    body = "<localleader>d",
    config = {
        color = "pink",
    },
    heads = {
        {"b", dap.toggle_breakpoint, {desc = "toggle breakpoint", nowait = true}},
        {"c", dap.continue, {desc = "continue", nowait = true}},
        {"t", dap.terminate, {desc = "terminate", nowait = true}},
        {"u", dapui.toggle, {desc = "dap-ui toggle", nowait = true}},

        {"n", dap.step_over, {desc = "step over", nowait = true}},
        {"r", dap.step_into, {desc = "step into", nowait = true}},
        {"s", dap.step_out, {desc = "step out", nowait = true}},
    }
})

-- dapui
dap_ui.setup({
    icons = {expanded = "⯆", collapsed = "⯈", circular = "↺"},
    mappings = {expand = "<CR>", open = "o", remove = "d"},
    layouts = {
        {
            elements = {
                -- You can change the order of elements in the sidebar
                "scopes",
                "watches",
                "stacks"
            },
            size = 40,
            position = "left" -- Can be "left" or "right"
        },
        {
            elements = {"repl"},
            size = 10,
            position = "bottom" -- Can be "bottom" or "top"
        }
    },
    floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil -- Floats will be treated as percentage of your screen.
    }
})
