local nvim_lsp = require('lspconfig')

local function loader(on_attach, capabilities)

    local function override_on_attach(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
        })
        on_attach(client, bufnr)
    end

    nvim_lsp.eslint.setup({
        on_attach = override_on_attach,
        capabilities = capabilities
    })
end

return loader
