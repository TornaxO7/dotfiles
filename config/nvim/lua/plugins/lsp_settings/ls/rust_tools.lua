local rt = require("rust-tools")
local mason_registry = require("mason-registry")

local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
local codelldb_path = codelldb_root .. "adapter/codelldb"
local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"

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
		dap = {
			adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
		},
	})
end

return loader
