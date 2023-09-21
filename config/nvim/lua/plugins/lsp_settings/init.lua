return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"folke/which-key.nvim",
		"folke/neodev.nvim",
		"mfussenegger/nvim-jdtls",
		"folke/lsp-colors.nvim",
		"folke/neoconf.nvim",
		"jubnzv/virtual-types.nvim",
		"gfanto/fzf-lsp.nvim",
		"junegunn/fzf",
		"simrat39/rust-tools.nvim",
		{
			url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
			init = function()
				vim.api.nvim_create_user_command("LspLinesToggle", ':lua require("lsp_lines").toggle()', {})
			end,
		},
		{
			"jose-elias-alvarez/null-ls.nvim",
			dependencies = {
				"ThePrimeagen/refactoring.nvim",
			},
			init = function()
				local null_ls = require("null-ls")
				local code_actions = null_ls.builtins.code_actions
				local diagnostics = null_ls.builtins.diagnostics
				-- formatting sources
				local formatting = null_ls.builtins.formatting
				null_ls.setup({
					sources = {
						code_actions.refactoring,

						diagnostics.checkmake,
						diagnostics.chktex,
						diagnostics.clang_check,
						diagnostics.cmake_lint,
                        diagnostics.ruff,

						formatting.rustfmt,
						formatting.stylua,
						formatting.prettier,
						formatting.autopep8,
						formatting.clang_format,
                        formatting.sqlfmt,
					},
				})
			end,
		},
		{
			"williamboman/mason.nvim",
			dependencies = {
				"folke/which-key.nvim",
				{
					"jayp0521/mason-nvim-dap.nvim",
					dependencies = {
						"mfussenegger/nvim-dap",
					},
				},
			},
			init = function()
				local mason_data_dir = vim.fn.expand("~/Apps/nvim_mason_dir")
				local function exists(path)
					local file = io.open(path, "r")
					if file ~= nil then
						io.close(file)
						return true
					else
						return false
					end
				end

				require("which-key").register({
					M = {
						function()
							vim.api.nvim_command(":Mason")
						end,
						"Mason",
					},
				}, { prefix = "<localleader>" })

				if not exists(mason_data_dir) then
					os.execute("mkdir -p " .. mason_data_dir)
				end

				require("mason").setup({
					install_root_dir = vim.fn.expand(mason_data_dir),
				})

				require("mason-nvim-dap").setup({})
			end,
		},
	},
	config = function()
		require("plugins.lsp_settings.neoconf")
		require("plugins.lsp_settings.settings")
		require("plugins.lsp_settings.keybindings")
	end,
}
