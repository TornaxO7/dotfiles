local nvim_lsp = require('lspconfig')

local function loader(on_attach, capabilities)
    nvim_lsp.rnix.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        autostart = true,
    })
end

return loader
