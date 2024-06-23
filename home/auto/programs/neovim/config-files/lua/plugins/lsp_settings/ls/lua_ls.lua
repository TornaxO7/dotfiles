local nvim_lsp = require('lspconfig')

local function loader(on_attach, capabilities)
    nvim_lsp.lua_ls.setup({
        autostart = false,
        settings = {
            Lua = {
                completion = {
                    callSnippet = "Replace",
                },
            }
        }
    })
end

return loader
