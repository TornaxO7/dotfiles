local rt = require("rust-tools")
local mason_registry = require("mason-registry")

local function loader(on_attach, capabilities)
	rt.setup({
		server = {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					inlayHints = {
						locationLinks = false,
					},
                    procMacro = {
                        enable = true,
                    },
				},
			},
		},
	})
end

return loader
